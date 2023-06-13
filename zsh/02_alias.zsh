
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

### phpstorm
phpstorm() {
    open -na "PhpStorm.app" --args "$@"
}
### end phpstorm

### docker
dcea() {
    docker-compose exec app ash
}
zle -N dcea
### end docker

### docker
dcd() {
    docker-compose down
}
zle -N dcd
### end docker

### docker
dcu() {
    docker-compose up --remove-orphans
}
zle -N dcu
### end docker