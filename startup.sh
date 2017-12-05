sudo su
#stop any menus from interupting provision
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y
apt-get install apache2 -y
apt-get install php -y
apt-get install libapache2-mod-php -y
service apache2 restart
apt-get install php-xml -y
apt-get install mysql-server-5.6 -y
apt-get install php-gd -y
apt-get install php-curl -y
apt-get install php-mcrypt -y
apt-get install php-intl -y
apt-get install php-mbstring -y
apt-get install php-zip -y
sudo ln -fs /vagrant/public_html/ /var/www/site

FILE="/etc/apache2/sites-available/default.conf"

cat << EOF | sudo tee -a $FILE
<Directory "/var/www">
        AllowOverride All
</Directory>
<VirtualHost *:80>
        DocumentRoot /var/www/site
        ServerName mage2.dev
</VirtualHost>
EOF
phpenmod curl
phpenmod mcrypt
a2enmod rewrite
a2ensite default.conf
service apache2 restart
mkdir /vagrant/public_html
mkdir /var/www/site

echo "##############################"
echo "### Add to your host machine"
echo "##############################"
