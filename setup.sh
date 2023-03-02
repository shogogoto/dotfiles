#!/bin/bash


# dotfilesのセットアップ
./init_dots.sh

# install neovim
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update -y
sudo apt install neovim -y

# space cli
sudo apt install unzip
curl -fsSL https://get.deta.dev/space-cli.sh | sh

# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install fromdos, todos command
sudo apt install tofrodos -y

# WSL2でクリップボードを有効にする
sudo apt install xsel xclip -y

sudo apt install tig -y

# node
sudo apt install npm -y

# python
sudo apt install python3-pip -y
pip install pipenv
curl https://pyenv.run | bash


# git
INS="~/dotfiles/.install"
mkdir -p $INS && cd $INS

git clone https://github.com/huyng/bashmarks.git
cd bashmarks && make install && cd $INS

. ~/.bashrc

# vim setup
vi -c PlugInstall -c q -c q
