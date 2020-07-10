#!/bin/sh

# Apache server name change
if [ ! -z "${APACHE_SERVER_NAME}" ]
	then
		sed -i "s/#ServerName www.example.com:80/ServerName ${APACHE_SERVER_NAME}:80/" /etc/apache2/httpd.conf
		echo "Changed server name to '${APACHE_SERVER_NAME}'..."
	else
		echo "NOTICE: Change 'ServerName' globally and hide server message by setting environment variable >> 'SERVER_NAME=your.server.name' in docker command or docker-compose file"
fi

# Start (ensure apache2 PID not left behind first) to stop auto start crashes if didn't shut down properly
echo "Clearing any old processes..."
rm -f /run/apache2/apache2.pid
rm -f /run/apache2/httpd.pid

echo "Updating HTTPD config"
sed -i "s/ErrorLog logs\/error.log/Errorlog \/dev\/stderr\nTransferlog \/dev\/stdout/" /etc/apache2/httpd.conf
sed -i "s/define('DB_NAME', null);/define('DB_NAME', '${MYSQL_DATABASE}');/" /var/www/localhost/htdocs/wp-config.php
sed -i "s/define('DB_USER', null);/define('DB_USER', '${MYSQL_USER}');/" /var/www/localhost/htdocs/wp-config.php
sed -i "s/define('DB_PASSWORD', null);/define('DB_PASSWORD', '${MYSQL_PASSWORD}');/" /var/www/localhost/htdocs/wp-config.php
sed -i "s/define('DB_HOST', null);/define('DB_HOST', '${MYSQL_HOST}');/" /var/www/localhost/htdocs/wp-config.php

# install wp-cli
mkdir -p /var/www/wordpress
wget -c https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# create mysql users
echo "[i] Create temp file: $tfile"
cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
CREATE USER 'qli'@'localhost' IDENTIFIED BY 'server';
GRANT ALL PRIVILEGES ON *.* TO 'qli'@'localhost';
CREATE USER 'pma'@'localhost' IDENTIFIED BY 'pmapass';
GRANT ALL PRIVILEGES ON *.* TO 'pma'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON phpmyadmin.* TO 'root'@'localhost';
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL ON wordpress.* TO 'qli'@'localhost' IDENTIFIED BY 'server';
FLUSH PRIVILEGES;
EOF

chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

# run sql in tempfile
echo "[i] run tempfile: $tfile"
/usr/bin/mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap --verbose=0 < $tfile
rm -f $tfile

# create mysql users
echo "[i] Create temp file: $tfile"
cat << EOF > $tfile
USE mysql;
wp core download --path=/var/www/wordpress --allow-root;
wp config create --dbname=wordpress --dbuser=qli --dbpass=server \
	--locale=ro_RO --path=/var/www/wordpress --allow-root;
wp core install --url="192.168.99.202:5050" --title=Welcome_to_server \
	--admin_user=qli --admin_password=server --admin_email=amy_liqing@hotmail.com\
	--path=/var/www/wordpress --allow-root;
EOF

# run sql in tempfile
echo "[i] run tempfile: $tfile"
/usr/bin/mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap --verbose=0 < $tfile
rm -f $tfile

echo "Starting all process ..."
exec httpd -DFOREGROUND