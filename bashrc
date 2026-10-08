function cd(){
  builtin cd "$@" && ls
}

clean_vim() {
  ps aux|grep gotoh|grep node|awk -F ' ' '{print $2}'|xargs kill
}

# ssh-add, ssh-agent ref:https://qiita.com/reoring/items/f8c090393e11b673da84A
# if [ -f /usr/bin/keychain ]; then
#   keychain
#   . ~/.keychain/`hostname`-sh
# fi

# Directory renaming is a one-time setup step; see README.md.
# WSLに割り当てられるIPアドレス
# neovimでclipboardを使うのに必要
# export DISPLAY=$(cat /etc/resolv.conf | grep -e "^nameserver" | awk '{print $2}'):0.0
export DOTFILE_CONFIG="$HOME/dotfiles/config"
export ZELLIJ_CONFIG_DIR=$DOTFILE_CONFIG/zellij
export STARSHIP_CONFIG=$DOTFILE_CONFIG/starship.toml


alias vi='nvim'
export GIT_EDITOR=nvim # tig-explorerのエラー回避
export EDITOR=nvim

export PIPENV_VENV_IN_PROJECT=1  # pipenvの仮想環境がプロジェクト内に作成される ~/.local/share/virtualenvsではなく
export PATH=$PATH:$HOME/dotfiles/bin:$HOME/bin
export DEBIAN_FRONTEND=noninteractive
export PYENV_ROOT="$HOME/.pyenv"
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
if [[ -z "${DOTFILES_HOME_MANAGER:-}" ]]; then
  if [[ -d "$PYENV_ROOT/bin" ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
  fi
  if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
  fi
fi
export PRE_COMMIT_ALLOW_NO_CONFIG=1
if [[ -z "${DOTFILES_HOME_MANAGER:-}" ]] && command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

. ~/dotfiles/bash_aliases
if [[ -z "${DOTFILES_HOME_MANAGER:-}" ]] && [ -f ~/.local/bin/bashmarks.sh ]; then
  . ~/.local/bin/bashmarks.sh
  ## ~/.bashrcのaliasのせいでlコマンドが使えないかも
  # s <bookmark_name> - Saves the current directory as "bookmark_name"
  # g <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"
  # p <bookmark_name> - Prints the directory associated with "bookmark_name"
  # d <bookmark_name> - Deletes the bookmark
  # l                 - Lists all available bookmarks
fi

bind '"\C-n": history-search-forward'
bind '"\C-p": history-search-backward'

# ついでに履歴の件数も上げておく
HISTSIZE=100000

export PATH=$HOME/.cargo/bin:$PATH


TODO_PATH=$DOTFILE_CONFIG/todo/config
if [[ -f "$TODO_PATH/todo_completion" ]]; then
  . "$TODO_PATH/todo_completion"
fi
export TODOTXT_CFG_FILE=$TODO_PATH/todo.cfg

# . <(curl -s https://raw.githubusercontent.com/shogogoto/conoha-client/main/conoha-client.bash)


# terminalの日本語入力の窓が近くに表示されるように
# export GTK_IM_MODULE=ibus
# export QT_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

if command -v gh >/dev/null 2>&1; then
  eval "$(gh completion -s bash)"
fi

. $ZELLIJ_CONFIG_DIR/bashrc


# alacrittyからsshでtigが開けなかったので対策
if [ -n "$SSH_CONNECTION" ]; then
  export TERM=xterm-256color
fi
