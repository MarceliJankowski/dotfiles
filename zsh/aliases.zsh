##################################################
#                    ALIASES                     #
##################################################

# use extended RegExp support by default
alias sed='sed -E'
alias grep='grep -E'

# single-column colored ls
alias ls='ls -1 --color=tty'
alias sl='ls -1 --color=tty'

# make these interactive (ask before overwriting)
alias mv='mv -i'
alias cp='cp -i'

# curl doesn't postfix response with '\n' (newline) character by default, this causes ZSH to display it with '%' sign at the end
# I'm "fixing" this annoying behaviour with the '-w' (write-out) flag
alias curl="curl -w '\n'"

# nvim
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# get rid of GDB startup text
alias gdb='gdb --quiet'

# functions.zsh
alias fdirv='fdir && $EDITOR .'
alias rfdirv='rfdir && $EDITOR .'

# other
alias dotfiles='$EDITOR $DOTFILES'
alias notes='$EDITOR $NOTES'
alias docker-compse='docker-compose'
alias t='tmux'
