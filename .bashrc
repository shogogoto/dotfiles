function cd(){
  builtin cd "$@" && ls
}

clean_vim() {
  ps aux|grep gotoh|grep node|awk -F ' ' '{print $2}'|xargs kill
}

# ssh-add, ssh-agent ref:https://qiita.com/reoring/items/f8c090393e11b673da84
keychain
. ~/.keychain/`hostname`-sh

# WSLに割り当てられるIPアドレス
# neovimでclipboardを使うのに必要
# export DISPLAY=$(cat /etc/resolv.conf | grep -e "^nameserver" | awk '{print $2}'):0.0
export XDG_CONFIG_HOME="$HOME/dotfiles"
export PIPENV_VENV_IN_PROJECT=1  # pipenvの仮想環境がプロジェクト内に作成される ~/.local/share/virtualenvsではなく
export GIT_EDITOR=vim
export EDITOR=vim
export PATH=$PATH:$HOME/dotfiles/bin

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

. ~/dotfiles/.bash_aliases

. ~/dotfiles/conoha/bashrc

. ~/.local/bin/bashmarks.sh
