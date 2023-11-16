#/bin/bash

# install xfce4 s.t. desktop env
# ref: https://learn.microsoft.com/ja-jp/azure/virtual-machines/linux/use-remote-desktop?tabs=azure-cli
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install xfce4
sudo apt install xfce4-session
sudo apt-get -y install xrdp
sudo systemctl enable xrdp
sudo adduser xrdp ssl-cert

sudo ufw 3389 # rdp port
sudo ufw reload
sudo ufw status # check
