#!/bin/bash
sudo apt install software-properties-common -yq # add-apt-repositoryを追加

sudo apt update -yq
sudo apt upgrade -yq
sudo apt autoremove -y
# sudo add-apt-repository ppa:neovim-ppa/unstable -y
# for ssh-agent
sudo apt install keychain -yq

# nodejs
sudo apt install npm -yq # node
sudo npm install -g n
sudo n stable
sodo apt purge nodejs npm -yq # n導入後は不要なため
npm install --save-dev @marp-team/marp-cli # markdownからプレゼン生成

# python
sudo apt install libffi-dev -yq # for resolve ModuleNotFoundError: No module named '_ctypes'
sudo apt install libbz2-dev -yq # for resoluve ModuleNotFoundError: No module named '_bz2' in networkx
sudo apt install python3-pip -yq
sudo apt install libsqlite3-dev -yq # requre to pre-commit
curl https://pyenv.run | bash
# curl -sSL https://install.python-poetry.org | python3 -
sudo apt install python3-poetry -yq
poetry config virtualenvs.in-project true
poetry self update
poetry self add "poetry-dynamic-versioning[plugin]"
pip3 install ruff-lsp # python formmter

# docker
sudo apt install ca-certificates gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -yq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker -f
sudo gpasswd -a $USER docker

# etc
sudo apt install zip unzip curl -yq
sudo apt install tofrodos -yq # install fromdos, todos command
sudo apt install xsel xclip -yq # WSL2でクリップボードを有効にする
sudo apt install eog -yq # preview image file
sudo apt install jq -yq
sudo apt install preload -yq # よく使うアプリを事前に読み込む
sudo apt install direnv -yq
sudo apt install img2pdf -yq
sudo apt install pdftk -yq
sudo apt install byobu -yq

# git
sudo apt install tig -yq
sudo apt install gh -yq # GitHub CLI
sudo apt install hub -yq # cliからgithubを開く
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash # GitHub Actionsのローカル実行CLI

# vim setup
sudo apt install neovim -yq
sudo apt install cargo -yq # aiツール で必要
sudo apt install silversearcher-ag -yq # fzf for vim
sudo apt install cmigemo -yq
sudo apt install ripgrep bat universal-ctags -yq # for fzf.vim
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
./installers/init_dots.sh # keychinに依存
. ~/.bashrc
vim -c PlugInstall -c q -c q

# github repository
git clone https://github.com/huyng/bashmarks.git
cd bashmarks
make install
cd -

# ubuntu
sudo apt install neofetch -yq
sudo apt install flatpak -yq
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.github.vikdevelop.SaveDesktop -y
