#!/bin/bash


# dotfilesのセットアップ
./init_dots.sh

# install neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim

# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install fromdos, todos command
sudo apt install tofrodos

# WSL2でクリップボードを有効にする
sudo apt install xsel xclip

sudo apt install tig

# node
sudo apt install npm

# python
sudo apt install python3-pip
pip install pipenv
curl https://pyenv.run | bash


# git
INS="~/dotfiles/.install"
mkdir -p $INS && cd $INS

git clone https://github.com/huyng/bashmarks.git
cd bashmarks && make install && cd $INS
