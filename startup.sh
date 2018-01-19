sudo su
#stop any menus from interupting provision
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y
apt-get install nginx -y
apt-get install php -y

/etc/init.d/nginx start
apt-get install php-xml -y
apt-get install mysql-server-5.6 -y
apt-get install php-gd -y
apt-get install php-curl -y
apt-get install php-mcrypt -y
apt-get install php-intl -y
apt-get install php-mbstring -y
apt-get install php-zip -y
sudo ln -fs /vagrant/public_html/ /var/www/site

touch /var/nginx_access.log
touch /var/nginx_error.log

FILE="/etc/nginx/sites-available/nginx.local"

cat << EOF | sudo tee -a $FILE
server {
    listen 80;
    server_name nginx.local;

    access_log /var/nginx_access.log;
    error_log /var/nginx_error.log;

    location / {
        root /var/www/site/;
        index index.html;
    }
}
EOF

phpenmod curl
phpenmod mcrypt
ln -s /etc/nginx/sites-available/nginx.local /etc/nginx/sites-enabled/nginx.local

/etc/init.d/nginx restart

mkdir /vagrant/public_html
mkdir /var/www/site

echo "##############################"
echo "### Add to your host machine"
echo "##############################"
