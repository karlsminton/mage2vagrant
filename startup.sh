sudo su
#stop any menus from interupting provision
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y

apt-get install nginx -y
apt-get install php-fpm -y

/etc/init.d/nginx start

apt-get install mysql-server-5.7 mysql-client-5.7 -y
apt-get install apache2 -y
apt-get install php -y
apt-get install libapache2-mod-php -y
#service apache2 restart
service apache2 stop

apt-get install php-xml -y
apt-get install mysql-server-5.6 -y
apt-get install php-gd -y
apt-get install php-curl -y
apt-get install php-mcrypt -y
apt-get install php-intl -y
apt-get install php-mbstring -y
apt-get install php-zip -y
apt-get install php-mysql -y
apt-get install php-soap -y
sudo ln -fs /vagrant/public_html/ /var/www/site

touch /var/nginx_access.log
touch /var/nginx_error.log

rm /etc/nginx/sites-available/default
touch /etc/nginx/sites-available/default

FILE="/etc/nginx/sites-available/default"

cat << EOF | sudo tee -a $FILE
# Default server configuration
#
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/site;

	# Add index.php to the list if you are using PHP
	index index.php;

	server_name nginx.local;

	location / {
		try_files \$uri \$uri/ /index.php?\$args;
	}

	# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
	#
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;

		fastcgi_pass unix:/run/php/php7.0-fpm.sock;
	}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	location ~ /\.ht {
		deny all;
	}

	location /static/ {

    # Remove signature of the static files that is used to overcome the browser cache
    location ~ ^/static/version {
      rewrite ^/static/(version\d*/)?(.*)$ /static/$2 last;
    }

    location ~* \.(ico|jpg|jpeg|png|gif|svg|js|css|swf|eot|ttf|otf|woff|woff2)$ {
      add_header Cache-Control "public";
      add_header X-Frame-Options "SAMEORIGIN";
      expires +1y;

      if (!-f \$request_filename) {
        rewrite ^/static/(version\d*/)?(.*)$ /static.php?resource=\$2 last;
      }
    }

    location ~* \.(zip|gz|gzip|bz2|csv|xml)$ {
      add_header Cache-Control "no-store";
      add_header X-Frame-Options "SAMEORIGIN";
      expires off;

      if (!-f \$request_filename) {
         rewrite ^/static/(version\d*/)?(.*)$ /static.php?resource=\$2 last;
      }
    }

    if (!-f \$request_filename) {
      rewrite ^/static/(version\d*/)?(.*)$ /static.php?resource=\$2 last;
    }

    add_header X-Frame-Options "SAMEORIGIN";
  }
}
EOF

phpenmod curl
phpenmod mcrypt
#ln -s /etc/nginx/sites-available/nginx.local /etc/nginx/sites-enabled/nginx.local

/etc/init.d/nginx restart
systemctl restart php7.0-fpm

mkdir /vagrant/public_html
mkdir /var/www/site

echo "##############################"
echo "### Add to your host machine"
echo "##############################"
