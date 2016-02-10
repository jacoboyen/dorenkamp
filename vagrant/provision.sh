#!/bin/sh

## Install all the things
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install --assume-yes php5 php5-mysql php5-cli php5-curl php-apc \
	apache2 libapache2-mod-php5 mysql-client mysql-server supervisor \
	vim ntp bzip2 php-pear imagemagick php5-imagick

## make www-data use /bin/bash for shell
chsh -s /bin/bash www-data

## Create a directory structure
## (These would probably already exist within your project)
mkdir /var/www/html

## Create an Apache vhost
## (This would probably already exist within your project)
echo "<VirtualHost *:80>
ServerName aldorenkamp.com
DocumentRoot /var/www/html
<Directory /var/www/html>
	AllowOverride All
    Allow from All
</Directory>
</VirtualHost>" > /var/www/html/aldorenkamp.dev.conf

## Tell Apache about our vhost
ln -s /var/www/html/aldorenkamp.dev.conf /etc/apache2/sites-enabled/foreverDutch.dev.conf

## Tweak permissions for www-data user
chgrp www-data /var/log/apache2
chmod g+w /var/log/apache2

## Enable Apache's mod-rewrite, if it's not already
a2enmod rewrite

## Disable the default sites
a2dissite 000-default

## Configure PHP for dev
echo "upload_max_filesize = 15M
log_errors = On
display_errors = On
display_startup_errors = On
error_log = /var/log/apache2/php.log
memory_limit = 1024M
date.timezone = America/Chicago" > /etc/php5/mods-available/software.ini

php5enmod software

## Restart Apache
service apache2 reload

## Create a default .htaccess
echo "#
<IfModule mod_rewrite.c>
RewriteEngine On
</IfModule>
#" > /var/www/wordpress/.htaccess

## Set excessively liberal permissions on all of WordPress since we are testing.
chmod -R 777 /var/www/html
chown www-data.www-data /var/www/html -R
