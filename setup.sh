#!/bin/bash

sudo add-apt-repository ppa:neovim-ppa/unstable -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo apt update -y

# for ssh-agent
sudo apt install keychain -y

# space cli
sudo apt install zip unzip
curl -fsSL https://get.deta.dev/space-cli.sh | sh

sudo apt install tofrodos -y # install fromdos, todos command
sudo apt install xsel xclip -y # WSL2でクリップボードを有効にする
sudo apt install tig -y

# nodejs
sudo apt install npm -y # node
sudo apt install -g n
sudo n stable
sodo apt purge nodejs npm -y # n導入後は不要なため

# python
sudo apt install libffi-dev -y # for resolve ModuleNotFoundError: No module named '_ctypes'
sudo apt install libbz2-dev -y # for resoluve ModuleNotFoundError: No module named '_bz2' in networkx
sudo apt install python3-pip -y
pip install pipenv
curl https://pyenv.run | bash

# docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
## 権限設定 ref: https://linuxhandbook.com/docker-permission-denied/
# ERROR: permission denied while trying to connect to the Docker daemon socket
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# vim setup
sudo apt install neovim -y
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c PlugInstall -c q -c q


./init_dots.sh # dotfilesのセットアップ
. ~/.bashrc
