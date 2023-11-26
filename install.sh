#!/bin/bash
sudo apt install software-properties-common -yq # add-apt-repositoryを追加
# sudo add-apt-repository ppa:apt-fast/stable -y
sudo add-apt-repository ppa:neovim-ppa/unstable -y
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | yes | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo apt update -yq
sudo apt upgrade -yq
# sudo apt install apt-fast -y
# for ssh-agent
yes | sudo apt install keychain -yq

# space cli
yes | sudo apt install zip unzip -yq
curl -fsSL https://get.deta.dev/space-cli.sh | sh

yes | sudo apt install tofrodos -yq # install fromdos, todos command
yes | sudo apt install xsel xclip -yq # WSL2でクリップボードを有効にする
yes | sudo apt install tig -yq

# nodejs
yes | sudo apt install npm -yq # node
yes | sudo npm install -g n
yes | sudo n stable
sodo apt purge nodejs npm -yq # n導入後は不要なため

# python
yes | sudo apt install libffi-dev -yq # for resolve ModuleNotFoundError: No module named '_ctypes'
yes | sudo apt install libbz2-dev -yq # for resoluve ModuleNotFoundError: No module named '_bz2' in networkx
yes | sudo apt install python3-pip -yq
curl https://pyenv.run | bash
#curl -sSL https://install.python-poetry.org | python3 -
yes | sudo apt install python3-poetry -yq
poetry config virtualenvs.in-project true
poetry self add "poetry-dynamic-versioning[plugin]"
pip3 install ruff-lsp # python formmter

# docker
# yes | yes | sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
yes | sudo apt install docker -yq
## 権限設定 ref: https://linuxhandbook.com/docker-permission-denied/
# ERROR: permission denied while trying to connect to the Docker daemon socket
yes | sudo groupadd docker
yes | sudo usermod -aG docker $USER
newgrp docker

# etc
yes | sudo apt install eog -yq # preview image file
yes | sudo apt install jq -yq

# vim setup
yes | sudo apt install neovim -yq
./init_dots.sh # keychinに依存
. ~/.bashrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c PlugInstall -c q -c q

# github repository
git clone https://github.com/huyng/bashmarks.git
cd bashmarks
make install
cd -

