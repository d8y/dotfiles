
### github gl
function cd-fzf-ghqlist() {
    local GHQ_ROOT=`ghq root`
    local REPO=`ghq list -p | sed -e 's;'${GHQ_ROOT}/';;g' |fzf +m`
    if [ -n "${REPO}" ]; then
        cd ${GHQ_ROOT}/${REPO}
    fi
}
alias -g gl=cd-fzf-ghqlist
### end github gl

## github open
function cd-fzf-ghqlist-open() {
    local GHQ_ROOT=`ghq root`
    local REPO=`ghq list -p | sed -e 's;'${GHQ_ROOT}/';;g' |fzf +m`
    if [ -n "${REPO}" ]; then
        BUFFER="phpstorm ${GHQ_ROOT}/${REPO}"
    else
        zle reset-prompt
    fi
    zle accept-line
}
zle -N cd-fzf-ghqlist-open
bindkey '^G' cd-fzf-ghqlist-open
## end github open

### history
function buffer-fzf-history() {
    local HISTORY=$(history -n -r 1 | fzf +m)
    BUFFER=$HISTORY
    if [ -n "$HISTORY" ]; then
        CURSOR=$#BUFFER
    else
        zle accept-line
    fi
}
zle -N buffer-fzf-history
bindkey '^R' buffer-fzf-history
### end history

### ssh
function sshp() {
    local HOST="$(command egrep -i '^Host\s+.+' $HOME/.ssh/config $(find $HOME/.ssh/conf.d/ -type f 2>/dev/null) $(find $HOME/.ssh/conf.d/work -type f -o -type l 2>/dev/null) | command egrep -v '[*?]' | awk '{print $2}' | sort | fzf)"

    if [ -n "$HOST" ]; then
        ssh $HOST
    fi
}
zle -N sshp
### end ssh

### aws-vault
function aws_vault_prompt {
  if [ -n "$AWS_VAULT" ]; then
    echo "(aws-vault: $AWS_VAULT)"
  fi
}
### end aws-vault

### phpstorm
phpstorm() {
    open -na "PhpStorm.app" --args "$@"
}
### end phpstorm

### docker-compose
alias dc='docker compose'
### end docker-compose

### docker
function dcd() {
    dc down
}
zle -N dcd
### end docker

### docker
function dcu() {
    dc up --remove-orphans
}
zle -N dcu
### end docker

### Claude
alias cc="ENABLE_BACKGROUND_TASKS=1 MAX_THINKING_TOKENS=31999 ANTHROPIC_SMALL_FAST_MODEL=sonnet CLAUDE_CODE_MAX_OUTPUT_TOKENS=32000 MAX_MCP_OUTPUT_TOKENS=120000 CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 DISABLE_NON_ESSENTIAL_MODEL_CALLS=1 MCP_TIMEOUT=30000 MCP_TOOL_TIMEOUT=300000 claude --model opus --dangerously-skip-permissions --append-system-prompt 'use context7.'"