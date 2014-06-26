#!/usr/bin/env bash

# Ubuntu 12.04 Precise Pangolin

sudo apt-get install python-software-properties curl wget -y
# add repo for php5.5
sudo add-apt-repository ppa:ondrej/php5 -y

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

if ! [ -f 'nginx_signing.key' ]; then
	# add key for nginx
	cd ~
	wget http://nginx.org/keys/nginx_signing.key
fi
sudo apt-key add nginx_signing.key
rm nginx_signing.key

sudo sh -c 'echo "deb http://nginx.org/packages/ubuntu/ precise nginx" >> /etc/apt/sources.list'
sudo sh -c 'echo "deb-src http://nginx.org/packages/ubuntu/ precise nginx" >> /etc/apt/sources.list'

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

# Set MySQL root password
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

sudo apt-get install build-essential git nginx php5 php5-cgi php5-cli php5-gd \
php5-common php5-curl php5-json php5-mcrypt php5-mysql mysql-server -y

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

sudo reboot