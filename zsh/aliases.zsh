##################################################
#                    ALIASES                     #
##################################################

# use extended RegExp support by default
alias sed="sed -E"
alias grep="grep -E"

# single-column colored ls
alias ls="ls -1 --color=tty"
alias sl="ls -1 --color=tty"

# make these interactive (ask before overwriting)
alias mv="mv -i"
alias cp="cp -i"

# curl doesn't postfix response with '\n' (newline) character by default, this causes ZSH to display it with '%' sign at the end
# I'm "fixing" this annoying behaviour with the '-w' (write-out) flag
alias curl="curl -w '\n'"

# nvim
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias rvim="nvim"
alias nv="nvim"

# clear (yeah...)
alias c="clear"
alias cc="clear"
alias lcs="clear"
alias cleare ="clear"
alias clea="clear"
alias cear="clear"
alias lcear="clear"
alias clera="clear"
alias celar="clear"
alias cler="clear"
alias claer="clear"
alias clearc="clear"
alias cleawr="clear"
alias caler="clear"
alias calar="clear"
alias cclear="clear"
alias rclear="clear"
alias rlear="clear"
alias rclear="clear"
alias rcle="clear"
alias rcler="clear"
alias cls="clear"
alias csl="clear"

# other
alias notes="nvim $NOTES"
alias docker-compse="docker-compose"
alias t="tmux"
