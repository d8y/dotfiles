### history
HISTFILE=~/.zsh_history
export SAVEHIST=10000
export HISTSIZE=1000

# share .zshhistory
setopt share_history
setopt inc_append_history

setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt extended_history
### end history

autoload -Uz colors && colors

export LANG=ja_JP.UTF-8
setopt print_eight_bit
setopt correct
setopt auto_pushd
setopt no_beep
PROMPT="%F{green}%n%f %F{cyan}($(arch))%f:%F{magenta}%~%f %# "

fpath=(${ASDF_DIR}/completions $fpath)

autoload -Uz compinit && compinit

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%b'