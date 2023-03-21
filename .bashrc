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
export PIPENV_VENV_IN_PROJECT=1  # pipenvの仮想環境がプロジェクト内に作成される ~/.local/share/virtualenvsではなく
export GIT_EDITOR=vim
export EDITOR=vim

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

. ~/dotfiles/.bash_aliases
