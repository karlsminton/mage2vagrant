sudo su
#stop any menus from interupting provision
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y

apt-get install python-software-properties -y
add-apt-repository ppa:ondrej/php -y
sudo apt-get update -y
apt-get install mysql-server-5.7 mysql-client-5.7 -y
apt-get install apache2 -y

apt-get install php7.1 -y
apt-get install libapache2-mod-php -y
service apache2 restart
apt-get install php7.1-xml -y
apt-get install mysql-server-5.6 -y

apt-get install php7.1-gd -y
apt-get install php7.1-curl -y
apt-get install php7.1-mcrypt -y
apt-get install php7.1-intl -y
apt-get install php7.1-mbstring -y
apt-get install php7.1-zip -y
apt-get install php7.1-mysql -y
apt-get install php7.1-soap -y
sudo ln -fs /vagrant/public_html/ /var/www/site

FILE="/etc/apache2/sites-available/default.conf"

cat << EOF | sudo tee -a $FILE
<Directory "/var/www">
        AllowOverride All
</Directory>
<VirtualHost *:80>
        DocumentRoot /var/www/site
        ServerName mage2.local
</VirtualHost>
EOF
phpenmod curl
phpenmod mcrypt
a2enmod rewrite
a2ensite default.conf
service apache2 restart
mkdir /vagrant/public_html
mkdir /var/www/site

rm /usr/bin/php
ln -sf /usr/bin/php7.1 /usr/bin/php

echo "##############################"
echo "### Add to your host machine"
echo "##############################"
