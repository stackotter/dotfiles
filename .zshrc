# manydots (replace ... with ../.. etc.) (Based on http://stackoverflow.com/a/41420448/4757)
function expand-multiple-dots() {
    local MATCH
    if [[ $LBUFFER =~ '(^| )\.\.\.+' ]]; then
        LBUFFER=$LBUFFER:fs%\.\.\.%../..%
    fi
}

function expand-multiple-dots-then-expand-or-complete() {
    zle expand-multiple-dots
    zle expand-or-complete
}

function expand-multiple-dots-then-accept-line() {
    zle expand-multiple-dots
    zle accept-line
}

zle -N expand-multiple-dots
zle -N expand-multiple-dots-then-expand-or-complete
zle -N expand-multiple-dots-then-accept-line
bindkey '^I' expand-multiple-dots-then-expand-or-complete
bindkey '^M' expand-multiple-dots-then-accept-line

# auto cd
setopt auto_cd

# better auto-complete (case-insensitive and word doesn't need to be at the start of the match)
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# history filtering (the history will only include commands starting with the currently typed command)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# prompt
eval "$(starship init zsh)"

# create del alias
alias del="rmtrash"

# virtualenv
source /usr/local/bin/virtualenvwrapper.sh

# thefuck
eval $(thefuck --alias)

# docker helpers
alias docker_rm_stopped='docker rm $(docker ps --filter status=exited -q)'
alias docker_latest='LATEST_ID=$(docker ps -a | head -n 2 | tail -n 1 | cut -c1-12); docker start $LATEST_ID; docker exec -it $LATEST_ID /bin/bash'
