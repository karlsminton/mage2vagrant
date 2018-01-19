sudo su
#stop any menus from interupting provision
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y
apt-get install nginx -y
apt-get install php-fpm -y

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

rm /etc/nginx/sites-available/default
touch /etc/nginx/sites-available/default

FILE="/etc/nginx/sites-available/default"

cat << EOF | sudo tee -a $FILE
##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# http://wiki.nginx.org/Pitfalls
# http://wiki.nginx.org/QuickStart
# http://wiki.nginx.org/Configuration
#
# Generally, you will want to move this file somewhere, and start with a clean
# file but keep this around for reference. Or just disable in sites-enabled.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

# Default server configuration
#
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	# SSL configuration
	#
	# listen 443 ssl default_server;
	# listen [::]:443 ssl default_server;
	#
	# Note: You should disable gzip for SSL traffic.
	# See: https://bugs.debian.org/773332
	#
	# Read up on ssl_ciphers to ensure a secure configuration.
	# See: https://bugs.debian.org/765782
	#
	# Self signed certs generated by the ssl-cert package
	# Don't use them in a production server!
	#
	# include snippets/snakeoil.conf;

	root /var/www/site;

	# Add index.php to the list if you are using PHP
	index index.php;

	server_name nginx.local;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ /index.php?$args;
		# try_files $uri $uri/ =404;
	}

	# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
	#
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;

		# With php7.0-cgi alone:
		#fastcgi_pass 127.0.0.1:9000;
		# With php7.0-fpm:
		fastcgi_pass unix:/run/php/php7.0-fpm.sock;
	}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	location ~ /\.ht {
		deny all;
	}
}

# Virtual Host configuration for example.com
#
# You can move that to a different file under sites-available/ and symlink that
# to sites-enabled/ to enable it.
#
#server {
#	listen 80;
#	listen [::]:80;
#
#	server_name example.com;
#
#	root /var/www/example.com;
#	index index.html;
#
#	location / {
#		try_files $uri $uri/ =404;
#	}
#}
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
