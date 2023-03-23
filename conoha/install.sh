#!/bin/bash

# WordPress Installation Manual ref:https://support.conoha.jp/v/hellovps-w-04/?btn_id=v-hellovps-ex-01-sidebar_v-hellovps-w-04

# web server ref:https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-20-04-ja
sudo apt install apache2
sudo ufw allow 'Apache'

# Install PHP
curl -L https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer \
    | bash
# git clone git://github.com/CHH/php-build.git ~/.phpenv/plugins/php-build
echo 'export PATH="$HOME/.phpenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(phpenv init -)"' >> ~/.bashrc
exec $SHELL -l

# php 5.4.16をインストールしようとして失敗したため適宜インストール
sudo apt install libxml2-dev　-y # php 5.4.16

sudo apt install pkg-config -y # php 7.4.33
sudo apt install libgssapi-krb5-2 -y
sudo apt install libsqlite3-dev -y
sudo apt install libcurl4-openssl-dev -y
sudo apt install libpng-dev libjpeg-dev libgmp-dev -y
sudo ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h
sudo apt install libonig-dev -y
sudo apt install libreadline-dev -y
sudo apt install libtidy-dev -y
sudo apt install libxslt-dev -y
sudo apt install libzip-dev -y

# RDB for WordPress
#   ref:
#       https://www.digitalocean.com/community/tutorials/how-to-install-mariadb-on-ubuntu-20-04-ja
#       https://support.conoha.jp/v/hellovps-w-04/?btn_id=v-hellovps-ex-01-sidebar_v-hellovps-w-04
#     mysql -u root -p でAccess Deniedにならないようにするには
#       >> sudo mysql -u root -p
#       >> grant all privileges on *.* to root@localhost identified by 'password' with grant option;
#       >> flush privileges;
sudo apt install mariadb-server -y
sudo mysql_secure_installation
