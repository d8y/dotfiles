#!/bin/bash

# Debug log
echo "[$(date)] Hook called" >> /tmp/claude_global_hook.log

# JSON 入力を読み取り、コマンドとツール名を抽出
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command' 2>/dev/null || echo "")
tool_name=$(echo "$input" | jq -r '.tool_name' 2>/dev/null || echo "")

echo "tool_name: $tool_name" >> /tmp/claude_global_hook.log
echo "command: $command" >> /tmp/claude_global_hook.log

# Bash コマンドのみをチェック
if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

# settings.json から拒否パターンを読み取り（グローバル + プロジェクトローカル）
global_settings="$HOME/.claude/settings.json"
project_settings_local=".claude/settings.local.json"
project_settings=".claude/settings.json"

extract_deny_patterns() {
  jq -r '.permissions.deny[] | select(startswith("Bash(")) | gsub("^Bash\\("; "") | gsub("\\)$"; "")' "$1" 2>/dev/null
}

# 全ソースから拒否パターンを結合（重複は後段で問題にならない）
deny_patterns=$(
  extract_deny_patterns "$global_settings"
  [ -f "$project_settings" ] && extract_deny_patterns "$project_settings"
  [ -f "$project_settings_local" ] && extract_deny_patterns "$project_settings_local"
)

# コマンドが拒否パターンにマッチするかチェックする関数
matches_deny_pattern() {
  local cmd="$1"
  local pattern="$2"

  # 先頭・末尾の空白を削除
  cmd="${cmd#"${cmd%%[![:space:]]*}"}" # 先頭の空白を削除
  cmd="${cmd%"${cmd##*[![:space:]]}"}" # 末尾の空白を削除

  # :* で終わる場合はプレフィックスマッチ（Claude Code の :* 構文）
  if [[ "$pattern" == *":*" ]]; then
    local prefix="${pattern%:*}"
    [[ "$cmd" == "$prefix"* ]]
  else
    # glob パターンマッチング（ワイルドカード対応）
    [[ "$cmd" == $pattern ]]
  fi
}

# まずコマンド全体をチェック
while IFS= read -r pattern; do
  # 空行をスキップ
  [ -z "$pattern" ] && continue

  # コマンド全体がパターンにマッチするかチェック
  if matches_deny_pattern "$command" "$pattern"; then
    echo "Error: コマンドが拒否されました: '$command' (パターン: '$pattern')" >&2
    exit 2
  fi
done <<<"$deny_patterns"

# コマンドを論理演算子で分割し、各部分もチェック
# セミコロン、&& と || で分割（パイプ | と単一 & は分割しない）
temp_command="${command//;/$'\n'}"
temp_command="${temp_command//&&/$'\n'}"
temp_command="${temp_command//\|\|/$'\n'}"

IFS=$'\n'
for cmd_part in $temp_command; do
  # 空の部分をスキップ
  [ -z "$(echo "$cmd_part" | tr -d '[:space:]')" ] && continue

  # 各拒否パターンに対してチェック
  while IFS= read -r pattern; do
    # 空行をスキップ
    [ -z "$pattern" ] && continue

    # このコマンド部分がパターンにマッチするかチェック
    if matches_deny_pattern "$cmd_part" "$pattern"; then
      echo "Error: コマンドが拒否されました: '$cmd_part' (パターン: '$pattern')" >&2
      exit 2
    fi
  done <<<"$deny_patterns"
done

# コマンドを許可
exit 0