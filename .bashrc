function cd(){
  builtin cd "$@" && ls
}

clean_vim() {
  ps aux|grep gotoh|grep node|awk -F ' ' '{print $2}'|xargs kill
}

# WSLに割り当てられるIPアドレス
# neovimでclipboardを使うのに必要
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export XDG_CONFIG_HOME="$HOME/dotfiles"

. ~/dotfiles/.bash_aliases
