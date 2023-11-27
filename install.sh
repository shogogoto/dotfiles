#!/bin/bash
sudo NEEDSTART_MODE=a apt install software-properties-common -yq # add-apt-repositoryを追加

sudo apt list|grep apt-fast
if [ $? = -]; then
  sudo add-apt-repository ppa:apt-fast/stable -y
fi
# sudo add-apt-repository ppa:neovim-ppa/unstable -y
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | yes | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo NEEDSTART_MODE=a apt install apt-fast -y
sudo NEEDSTART_MODE=a apt-fast update -yq
sudo NEEDSTART_MODE=a apt-fast upgrade -yq
# for ssh-agent
sudo NEEDSTART_MODE=a apt-fast install keychain -yq

# space cli
sudo NEEDSTART_MODE=a apt-fast install zip unzip -yq
curl -fsSL https://get.deta.dev/space-cli.sh | sh

sudo NEEDSTART_MODE=a apt-fast install tofrodos -yq # install fromdos, todos command
sudo NEEDSTART_MODE=a apt-fast install xsel xclip -yq # WSL2でクリップボードを有効にする
sudo NEEDSTART_MODE=a apt-fast install tig -yq

# nodejs
sudo NEEDSTART_MODE=a apt-fast install npm -yq # node
sudo npm install -g n
sudo n stable
sodo apt-fast purge nodejs npm -yq # n導入後は不要なため

# python
sudo NEEDSTART_MODE=a apt-fast install libffi-dev -yq # for resolve ModuleNotFoundError: No module named '_ctypes'
sudo NEEDSTART_MODE=a apt-fast install libbz2-dev -yq # for resoluve ModuleNotFoundError: No module named '_bz2' in networkx
sudo NEEDSTART_MODE=a apt-fast install python3-pip -yq
curl https://pyenv.run | bash
#curl -sSL https://install.python-poetry.org | python3 -
sudo NEEDSTART_MODE=a apt-fast install python3-poetry -yq
poetry config virtualenvs.in-project true
poetry self add "poetry-dynamic-versioning[plugin]"
pip3 install ruff-lsp # python formmter

# docker
# sudo NEEDSTART_MODE=a apt-fast install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo NEEDSTART_MODE=a apt-fast install docker.io docker -yq
## 権限設定 ref: https://linuxhandbook.com/docker-permission-denied/
# ERROR: permission denied while trying to connect to the Docker daemon socket
sudo groupadd docker -f
sudo usermod -aG docker $USER
# newgrp docker

# etc
sudo NEEDSTART_MODE=a apt-fast install eog -yq # preview image file
sudo NEEDSTART_MODE=a apt-fast install jq -yq

# vim setup
sudo NEEDSTART_MODE=a apt-fast install neovim -yq
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
./init_dots.sh # keychinに依存
. ~/.bashrc
vim -c PlugInstall -c q -c q

# github repository
git clone https://github.com/huyng/bashmarks.git
cd bashmarks
make install
cd -

