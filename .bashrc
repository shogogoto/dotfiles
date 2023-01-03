function cd(){
  builtin cd "$@" && ls
}

alias vimn="vim -u NONE -N"

alias dos2unix='fromdos'
alias unix2dos='todos'
alias vi='nvim'

export XDG_CONFIG_HOME="$HOME/dotfiles"
