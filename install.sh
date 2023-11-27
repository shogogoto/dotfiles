#!/bin/bash
export NEEDRESTART_MODE=a
sudo apt install software-properties-common -yq # add-apt-repositoryを追加
sudo add-apt-repository ppa:apt-fast/stable -y
# sudo add-apt-repository ppa:neovim-ppa/unstable -y
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | yes | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo apt update -yq
sudo apt upgrade -yq
sudo apt install apt-fast -y
# for ssh-agent
sudo apt-fast install keychain -yq

# space cli
sudo apt-fast install zip unzip -yq
curl -fsSL https://get.deta.dev/space-cli.sh | sh

sudo apt-fast install tofrodos -yq # install fromdos, todos command
sudo apt-fast install xsel xclip -yq # WSL2でクリップボードを有効にする
sudo apt-fast install tig -yq

# nodejs
sudo apt-fast install npm -yq # node
sudo npm install -g n
sudo n stable
sodo apt-fast purge nodejs npm -yq # n導入後は不要なため

# python
sudo apt-fast install libffi-dev -yq # for resolve ModuleNotFoundError: No module named '_ctypes'
sudo apt-fast install libbz2-dev -yq # for resoluve ModuleNotFoundError: No module named '_bz2' in networkx
sudo apt-fast install python3-pip -yq
curl https://pyenv.run | bash
#curl -sSL https://install.python-poetry.org | python3 -
sudo apt-fast install python3-poetry -yq
poetry config virtualenvs.in-project true
poetry self add "poetry-dynamic-versioning[plugin]"
pip3 install ruff-lsp # python formmter

# docker
# sudo apt-fast install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo apt-fast install docker -yq
## 権限設定 ref: https://linuxhandbook.com/docker-permission-denied/
# ERROR: permission denied while trying to connect to the Docker daemon socket
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# etc
sudo apt-fast install eog -yq # preview image file
sudo apt-fast install jq -yq

# vim setup
sudo apt-fast install neovim -yq
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
./init_dots.sh # keychinに依存
. ~/.bashrc
vim -c PlugInstall -c q -c q

# github repository
git clone https://github.com/huyng/bashmarks.git
cd bashmarks
make install
cd -

