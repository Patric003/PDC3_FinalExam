#!/bin/bash

#Installing and Starting the HTTPD service

echo "Installing HTTPD"
yum install -y httpd
echo "Starting HTTPD"
systemctl start httpd.service

#Adding firewall rule to allow traffic to bypass the firewall

echo "Adding firewall rules"
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload


#Installation of PHP for the  web server

echo "Installing PHP Apache"
yum install -y php php-mysql

echo "Starting PHP Apache"
systemctl restart httpd.service

echo "Findout"
yum info php-fpm

echo "Installing PHP-FPM"
yum install -y php-fpm



#Going inside the html for the index.php

cd /var/www/html/
echo '<?php phpinfo(); ?>' > index.php


#Installation of MariaDB for the  relational database

echo "Installing MariaDB"
yum install -y mariadb-server mariadb

echo "Starting MariaDB"
systemctl start mariadb

echo "Running the simple security script"
mysql_secure_installation <<EOF

# To automate the additional information
y
hello003
hello003
y
y
y
y
EOF

#Finalizing the mariaDB

echo "enable MariaDB"
systemctl enable mariadb

echo "mariadb enable"
echo "Verifying Installation"

#Inserting the root and the password

mysqladmin -u root -phello003 version

#Automation process of Wordpress 

#adding all the additional infomation needed for the Wordpress Database

echo "CREATE DATABASE wordpress; CREATE USER pat@localhost IDENTIFIED BY 'hello003'; GRANT ALL PRIVILEGES ON wordpress.* TO pat@localhost IDENTIFIED BY 'hello003'; FLUSH PRIVILEGES; show databases;" | mysql -u root -phello003

#Installing of wordpress, apache service, wget, and tar

echo "Installing Wordpress"
yum install -y php-gd

echo "Restarting Apache"
service httpd restart

echo "installing wget"
yum install -y wget

echo "installing tar"
yum install -y tar


#This will download a compressed archive file containing the WordPress files that we need.

cd /opt/
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz


#Instalation of Rsnyc
echo "Installing Rsync"
yum install -y rsync

#this will add new directory called wordpress in your home directory
rsync -avP wordpress/ /var/www/html/

#Going inside he html
cd /var/www/html/

#adding a folder for WordPress to store uploaded files.
mkdir /var/www/html/wp-content/uploads

#Assigning the correct ownership and permissions to our WordPress files and folders.
chown -R apache:apache /var/www/html/*


# Copying the config-sample file
cp wp-config-sample.php wp-config.php

#Using the sed command will search and replace the text witten inside a file.
#This will be used to replace all the needed information for the wordpress.
sed -i 's/database_name_here/wordpress/g' wp-config.php
sed -i 's/username_here/pat/g' wp-config.php
sed -i 's/password_here/hello003/g' wp-config.php

#Installtion of PHP, Remi7, utils etc.
echo "Updating php"
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils
yum-config-manager --enable remi-php56
yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo

#Restarting the service 
systemctl restart httpd.service

#DONE!