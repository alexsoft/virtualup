#!/usr/bin/env bash

# Ubuntu 12.04 Precise Pangolin

sudo apt-get install python-software-properties
# add repo for php5.5
sudo add-apt-repository ppa:ondrej/php5

# add key for nginx
cd ~
wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key

echo 'deb http://nginx.org/packages/ubuntu/ precise nginx' >> /etc/apt/sources.list
echo 'deb-src http://nginx.org/packages/ubuntu/ precise nginx' >> /etc/apt/sources.list

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y build-essential git nginx php5 php5-cgi php5-cli \
php5-common php5-curl php5-json php5-mcrypt php5-mysql

# Install MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server

# Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

cd ~
mkdir .ssh
cd ~/.ssh
ssh-keygen -f id_rsa -t rsa -N ''

# Setup Authorized Keys
cd ~/.ssh
wget https://raw.github.com/alexsoft/virtualup/master/authorized_keys

cd /
sudo mkdir asft
cd asft
sudo mkdir sites
sudo chown asft:asft -R /asft/

cd /var
sudo mkdir www
sudo chown asft:asft -R www/