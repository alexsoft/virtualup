#!/usr/bin/env bash

# Ubuntu 14.04 Trusty Tahr

sudo apt-get install python-software-properties curl wget -y
# add repo for php5.5
sudo add-apt-repository ppa:ondrej/php5-5.6 -y

while getopts "n" OPTION
do
	case $OPTION in
		n)
			NODE=1
			;;
	esac
done

if [ $NODE = 1 ]; then
	sudo add-apt-repository ppa:chris-lea/node.js -y
fi

sudo apt-add-repository ppa:nginx/stable -y

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

# Set MySQL root password
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

sudo apt-get install build-essential git nginx php5 php5-cgi php5-cli php5-fpm \
php5-gd php5-common php5-curl php5-json php5-mcrypt php5-mysql mysql-server -y

if [ $NODE = 1 ]; then
	sudo apt-get install nodejs -y
fi

# Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

cd ~
mkdir .ssh
cd ~/.ssh
if [ -n "$1" ]; then
	USER='asft'
else
	USER="$1"
fi
HOST=$HOSTNAME
ssh-keygen -f id_rsa -t rsa -N '' -C $USER'@'$HOST

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

sudo apt-get autoremove -y

sudo reboot