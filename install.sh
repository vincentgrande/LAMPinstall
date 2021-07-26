#!/bin/bash
echo "Name of your project ?"
read input

echo "Updating & upgrading apt "
sudo add-apt-repository ppa:ondrej/php -y
sudo apt -y update  
sudo apt -y upgrade  

echo "Installing apache2 ..."
sudo apt -y install apache2  

echo "Installing Mysql-server ..."
sudo apt -y install mysql-server  
sudo mysql_secure_installation 

echo "Installing PHP7.4 ..."
sudo apt -y install software-properties-common  
sudo apt -y install php7.4  
sudo apt -y install  php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath  

echo "Installing Composer ..."
curl -sS https://getcomposer.org/installer -o composer-setup.php  
HASH=`curl -sS https://composer.github.io/installer.sig`  
php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" 
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer  

cd /etc/apache2/sites-available/
sudo a2dissite 000-default.conf  
sudo a2dissite default-ssl.conf  
sudo a2enmod rewrite  
sudo tee -a $input.conf > /dev/null <<EOT
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/$input/public/
        <Directory "/var/www/$input/public/">
            AllowOverride All
            Allow from All
        </Directory>
        RewriteEngine on
</VirtualHost>
EOT
sudo a2ensite $input.conf  
sudo service apache2 restart  

cd /var/www/
sudo chmod 777 .  
composer create-project laravel/laravel $input '7.*'  


cd /var/www/$input
sudo chmod -R 777 /var/www/$input  

echo "All done !" 
