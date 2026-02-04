#!/bin/bash

dot_files=`cat << EOS
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
  echo "eval "$(starship init bash)"" >> ~/.bashrc
  echo "added source dotfiles bashrc"
fi

# weztermの設定ファイル
mkdir -p ~/.config/wezterm && ln -s ~/dotfiles/config/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
