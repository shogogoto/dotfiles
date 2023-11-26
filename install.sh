#!/bin/bash
yes | sudo apt install software-properties-common -yq # add-apt-repositoryを追加
yes | sudo add-apt-repository ppa:apt-fast/stable -y
yes | sudo add-apt-repository ppa:neovim-ppa/unstable -y
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | yes | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
yes | sudo apt update -yq
yes | sudo apt upgrade -yq
sudo apt install apt-fast -y
# for ssh-agent
yes | sudo apt-fast install keychain -yq

# space cli
yes | sudo apt-fast install zip unzip -yq
curl -fsSL https://get.deta.dev/space-cli.sh | sh

yes | sudo apt-fast install tofrodos -yq # install fromdos, todos command
yes | sudo apt-fast install xsel xclip -yq # WSL2でクリップボードを有効にする
yes | sudo apt-fast install tig -yq

# nodejs
yes | sudo apt-fast install npm -yq # node
yes | sudo npm install -g n
yes | sudo n stable
yes | sodo apt-fast purge nodejs npm -yq # n導入後は不要なため

# python
yes | sudo apt-fast install libffi-dev -yq # for resolve ModuleNotFoundError: No module named '_ctypes'
yes | sudo apt-fast install libbz2-dev -yq # for resoluve ModuleNotFoundError: No module named '_bz2' in networkx
yes | sudo apt-fast install python3-pip -yq
curl https://pyenv.run | bash
#curl -sSL https://install.python-poetry.org | python3 -
yes | sudo apt-fast install python3-poetry -yq
poetry config virtualenvs.in-project true
poetry self add "poetry-dynamic-versioning[plugin]"
pip3 install ruff-lsp # python formmter

# docker
# yes | sudo apt-fast install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
yes | sudo apt-fast install docker -yq
## 権限設定 ref: https://linuxhandbook.com/docker-permission-denied/
# ERROR: permission denied while trying to connect to the Docker daemon socket
yes | sudo groupadd docker
yes | sudo usermod -aG docker $USER
newgrp docker

# etc
yes | sudo apt-fast install eog -yq # preview image file
yes | sudo apt-fast install jq -yq

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

