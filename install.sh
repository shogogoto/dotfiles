#!/bin/bash

sudo add-apt-repository ppa:apt-fast/stable -y
sudo add-apt-repository ppa:neovim-ppa/unstable -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo apt update -y

sudo apt install apt-fast -y
# for ssh-agent
sudo apt-fast install keychain -y

# space cli
sudo apt-fast install zip unzip
curl -fsSL https://get.deta.dev/space-cli.sh | sh

sudo apt-fast install tofrodos -y # install fromdos, todos command
sudo apt-fast install xsel xclip -y # WSL2でクリップボードを有効にする
sudo apt-fast install tig -y

# nodejs
sudo apt-fast install npm -y # node
sudo npm install -g n
sudo n stable
sodo apt-fast purge nodejs npm -y # n導入後は不要なため

# python
sudo apt-fast install libffi-dev -y # for resolve ModuleNotFoundError: No module named '_ctypes'
sudo apt-fast install libbz2-dev -y # for resoluve ModuleNotFoundError: No module named '_bz2' in networkx
sudo apt-fast install python3-pip -y
pip install pipenv
curl https://pyenv.run | bash
curl -sSL https://install.python-poetry.org | python3 -
poetry config virtualenvs.in-project true

# docker
sudo apt-fast install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
## 権限設定 ref: https://linuxhandbook.com/docker-permission-denied/
# ERROR: permission denied while trying to connect to the Docker daemon socket
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# etc
sudo apt-fast install eog -y # preview image file
sudo apt-fast install jq -y

# vim setup
sudo apt-fast install neovim -y
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c PlugInstall -c q -c q


# github repository
git clone https://github.com/huyng/bashmarks.git
cd bashmarks
make install
cd -


./init_dots.sh # dotfilesのセットアップ
. ~/.bashrc

