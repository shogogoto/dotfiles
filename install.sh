#!/bin/bash
./init_dots.sh # keychinに依存
. ~/.bashrc

sudo apt install software-properties-common -yqq # add-apt-repositoryを追加
sudo add-apt-repository ppa:apt-fast/stable -y
sudo add-apt-repository ppa:neovim-ppa/unstable -y
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo apt update -yqq
sudo apt upgrade -yqq
sudo apt install apt-fast -yqq
# for ssh-agent
sudo apt-fast install keychain -yqq

# space cli
sudo apt-fast install zip unzip -yqq
curl -fsSL https://get.deta.dev/space-cli.sh | sh

sudo apt-fast install tofrodos -yqq # install fromdos, todos command
sudo apt-fast install xsel xclip -yqq # WSL2でクリップボードを有効にする
sudo apt-fast install tig -yqq

# nodejs
sudo apt-fast install npm -yqq # node
sudo npm install -g n
sudo n stable
sodo apt-fast purge nodejs npm -yqq # n導入後は不要なため

# python
sudo apt-fast install libffi-dev -yqq # for resolve ModuleNotFoundError: No module named '_ctypes'
sudo apt-fast install libbz2-dev -yqq # for resoluve ModuleNotFoundError: No module named '_bz2' in networkx
sudo apt-fast install python3-pip -yqq
curl https://pyenv.run | bash
#curl -sSL https://install.python-poetry.org | python3 -
sudo apt-fast install python3-poetry -yqq
poetry config virtualenvs.in-project true
poetry self add "poetry-dynamic-versioning[plugin]"
pip3 install ruff-lsp # python formmter

# docker
# sudo apt-fast install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo apt-fast install docker -yqq
## 権限設定 ref: https://linuxhandbook.com/docker-permission-denied/
# ERROR: permission denied while trying to connect to the Docker daemon socket
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# etc
sudo apt-fast install eog -yqq # preview image file
sudo apt-fast install jq -yqq

# vim setup
sudo apt-fast install neovim -yqq
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c PlugInstall -c q -c q

# github repository
git clone https://github.com/huyng/bashmarks.git
cd bashmarks
make install
cd -

