#!/bin/bash

DOT_FILES=`cat << EOS
.vimrc
.gitconfig
EOS
`

for file in $DOT_FILES
do
  ln -is $HOME/dotfiles/$file $HOME/$file
done
