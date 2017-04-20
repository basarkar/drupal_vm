#!/usr/bin/env bash
echo " "
echo "==========================================================================="
echo "=============== Using: configs/vagrant/vagrant_provision.sh ==============="
echo "==========================================================================="

export DEBIAN_FRONTEND=noninteractive

# Update package manager
sudo apt-get update

# Use a custom .bashrc file. Current customizations:
# - Enable bash colors.
# - Customize prompt
# -- Show full hostname in prompt
cp /var/www/disignir/configs/vagrant/.bashrc /home/vagrant/.bashrc
source /home/vagrant/.bashrc

# Install Git.
sudo apt-get -y -q install git

# Force a blank root password for mysql
export DB_PASSWORD='m39cisk3T'

debconf-set-selections <<< "mysql-server mysql-server/root_password password ${DB_PASSWORD}"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${DB_PASSWORD}"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password ${DB_PASSWORD}"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password ${DB_PASSWORD}"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password ${DB_PASSWORD}"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

# Install mysql, php, Apache
echo " "
echo "=========================================================="
echo "=========== INSTALL APACHE/PHP/MYSQL ==========="
echo "=========================================================="
sudo apt-get install -q -y -f mysql-server mysql-client php5-xdebug libapache2-mod-auth-mysql apache2 php5 libapache2-mod-php5

### enable rewrite and header ###
sudo a2enmod headers
sudo a2enmod rewrite
### Copy vhost file ###
sudo rm /etc/apache2/sites-enabled/000-default.conf
sudo cp /var/www/disignir/configs/vagrant/vhost.conf /etc/apache2/sites-enabled/000-default.conf
#restart apache
echo "!!!!!RESTARTING APACHE!!!!"
sudo service apache2 restart

####set user .conf file for mysql###
sudo rm /etc/mysql/my.cnf
sudo cp /var/www/disignir/configs/vagrant/my.cnf /etc/mysql/my.cnf

#restart mysql
echo "!!!!!RESTARTING MYSQL!!!!"
sudo service mysql restart


# Install commonly used php packages
echo " "
echo "=========================================================="
echo "==================== INSTALL PHP PACKAGES ================"
echo "=========================================================="
sudo apt-get install -q -y -f php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-memcached php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php-apc php5-apcu
# Install snmp package to ignore errors when executing php from command line
sudo apt-get install -q -y -f snmp

# Install PHP Console Table.
sudo apt-get -q -y -f php-console-table

# Install better logfile viewer.
sudo apt-get -q -y -f lnav

# Install PHPMyAdmin
sudo apt-get install -y -f phpmyadmin

# Install some Linux packages
sudo apt-get install -y htop

# Copy custom php ini files
sudo rm /etc/php5/apache2/php.ini
sudo cp /var/www/disignir/configs/vagrant/apache2_php.ini /etc/php5/apache2/conf.d/php.ini
sudo cp /var/www/disignir/configs/vagrant/cli_php.ini /etc/php5/cli/conf.d/php.ini

# Install Composer
echo " "
echo "====================================================="
echo "=== Install Composer"
echo "====================================================="
cd ~/
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# echo " "
#echo "======================================================"
#echo "=== Configure NGINX "
#echo "====================================================="
# sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default
# sudo rm /etc/nginx/nginx.conf
# sudo cp /var/www/cms/configs/vagrant/nginx.conf /etc/nginx/nginx.conf
# sudo service nginx restart

# Make guest machine compatible with custom domain (local.cms.dnainfo.com)
# Requires for transporting logic to execute properly.
# Use private network IP address from Vagrantfile.
# @see http://ubuntuforums.org/archive/index.php/t-3407.html
