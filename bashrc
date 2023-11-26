function cd(){
  builtin cd "$@" && ls
}

clean_vim() {
  ps aux|grep gotoh|grep node|awk -F ' ' '{print $2}'|xargs kill
}

# ssh-add, ssh-agent ref:https://qiita.com/reoring/items/f8c090393e11b673da84A
if [ -f /usr/bin/keychain ]; then
  keychain
  . ~/.keychain/`hostname`-sh
fi

# WSLに割り当てられるIPアドレス
# neovimでclipboardを使うのに必要
# export DISPLAY=$(cat /etc/resolv.conf | grep -e "^nameserver" | awk '{print $2}'):0.0
export XDG_CONFIG_HOME="$HOME/dotfiles"
export PIPENV_VENV_IN_PROJECT=1  # pipenvの仮想環境がプロジェクト内に作成される ~/.local/share/virtualenvsではなく
if [ -f /usr/bin/nvim ]; then
	export GIT_EDITOR=nvim # tig-explorerのエラー回避
fi
export EDITOR=nvim
export PATH=$PATH:$HOME/dotfiles/bin
export DEBIAN_FRONTEND=noninteractive
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

. ~/dotfiles/bash_aliases

. ~/dotfiles/conoha/bashrc

if [ -f ~/.local/bin/bashmarks.sh ]; then
  . ~/.local/bin/bashmarks.sh
  ## ~/.bashrcのaliasのせいでlコマンドが使えないかも
  # s <bookmark_name> - Saves the current directory as "bookmark_name"
  # g <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"
  # p <bookmark_name> - Prints the directory associated with "bookmark_name"
  # d <bookmark_name> - Deletes the bookmark
  # l                 - Lists all available bookmarks
fi
