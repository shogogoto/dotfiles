function cd(){
  builtin cd "$@" && ls
}

alias vimn="vim -u NONE -N"

alias dos2unix='fromdos'
alias unix2dos='todos'
alias vi='nvim'
alias pipenv='python3 -m pipenv'
alias dd='cd ~/dev'
alias dot='cd ~/dotfiles'
export XDG_CONFIG_HOME="$HOME/dotfiles"

clean_vim() {
  ps aux|grep gotoh|grep node|awk -F ' ' '{print $2}'|xargs kill
}

# WSLに割り当てられるIPアドレス
# neovimでclipboardを使うのに必要
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
