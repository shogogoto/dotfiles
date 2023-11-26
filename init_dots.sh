#!/bin/bash

dot_files=`cat << EOS
vimrc
gitconfig
tigrc
EOS
`

for file in $dot_files
do
  ln -is ~/dotfiles/$file $HOME/.$file
done

source_bash=". ~/dotfiles/bashrc"
grep -q "$source_bash" ~/.bashrc

# マッチあり
if [ $? = 0 ]; then
  echo "already written source dotfiles bashrc"
else
  echo $source_bash >> ~/.bashrc
  echo "added source dotfiles bashrc"
fi
