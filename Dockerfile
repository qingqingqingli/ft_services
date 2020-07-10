
# the OS to use
FROM debian:buster

# the maintainer & contact details
LABEL MAINTAINER="qli"

# update packages
RUN apt-get update && apt-get upgrade -y

# install Nginx & openssl
RUN apt-get install -y nginx openssl

# generate ssl certificate
RUN openssl req -x509 \
	-nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/localhost.key \
	-out /etc/ssl/certs/localhost.crt \
	-subj "/C=NL/ST=Noord Holland/L=Amsterdam\
	/O=Codam/CN=www.localhost.com"

# copy nginx config file to the right place
COPY srcs/nginx.conf /etc/nginx/sites-available/localhost

# symlin this to sites-enabled to enable it
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled

# install MySQL to store & manage site data
RUN apt-get install mariadb-server mariadb-client -y

# create mysql database
RUN service mysql start && \
	echo "CREATE USER 'qli'@'localhost' IDENTIFIED BY 'server';" | mysql -u root && \
	echo "GRANT ALL PRIVILEGES ON *.* TO 'qli'@'localhost';" | mysql -u root && \
	echo "CREATE USER 'pma'@'localhost' IDENTIFIED BY 'pmapass';" | mysql -u root && \
	echo "GRANT ALL PRIVILEGES ON *.* TO 'pma'@'localhost';" | mysql -u root && \
	echo "GRANT SELECT, INSERT, DELETE, UPDATE ON phpmyadmin.* TO 'root'@'localhost';" | mysql -u root && \
	echo "FLUSH PRIVILEGES;" | mysql -u root && \
	echo "update mysql.user set plugin = 'mysql_native_password' where user='root';" | mysql -u root

# install & configure PHP to handle the admin of MySQL
RUN apt-get install -y php7.3-fpm php7.3-mysql php-json php-mbstring wget
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-english.tar.gz
RUN tar -zxvf phpMyAdmin-4.9.5-english.tar.gz
RUN mkdir /var/www/html/wordpress
RUN mv phpMyAdmin-4.9.5-english /var/www/html/wordpress/phpmyadmin
RUN rm -f phpMyAdmin-4.9.5-english.tar.gz
COPY srcs/config.inc.php /var/www/html/wordpress/phpmyadmin
RUN cd /etc/php/7.3/fpm && \
	sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/g' php.ini &&\
	sed -i 's/post_max_size = 8M/post_max_size = 20M/g' php.ini &&\
	sed -i 's/max_execution_time = 30/max_execution_time = 300/g' php.ini
RUN chmod 660 /var/www/html/wordpress/phpmyadmin/config.inc.php
RUN mkdir /var/www/html/wordpress/phpmyadmin/tmp
RUN chmod -R 777 /var/www/html/wordpress/phpmyadmin/tmp
RUN chown -R www-data:www-data /var/www/html/wordpress/phpmyadmin

# run the database in mysql
RUN service mysql start && \
	mysql < /var/www/html/wordpress/phpmyadmin/sql/create_tables.sql -u root

# download wp-cli
RUN wget -c https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# install send mail
RUN apt-get install -y sendmail
RUN echo "127.0.0.1 localhost localhost.localdomain" >> /etc/hosts

# create a new user & database
RUN service mysql start &&\
	echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql -u root && \
	echo "GRANT ALL ON wordpress.* TO 'qli'@'localhost' IDENTIFIED BY 'server';" | mysql -u root &&\
	echo "FLUSH PRIVILEGES;" | mysql -u root

# download wordpress
RUN chmod -R 755 /var/www/html/wordpress/
RUN chown -R www-data:www-data /var/www/html/wordpress/
RUN wp core download --path=/var/www/html/wordpress/ --allow-root

#install wordpress
RUN service mysql start &&\
	wp config create --dbname=wordpress --dbuser=qli --dbpass=server \
	--locale=ro_RO --path=/var/www/html/wordpress/ --allow-root
RUN service mysql start &&\
	wp core install --url=localhost --title=Welcome_to_server \
	--admin_user=qli --admin_password=server --admin_email=amy_liqing@hotmail.com\
	--path=/var/www/html/wordpress/ --allow-root
RUN chown -R www-data:www-data /var/www/html/wordpress/

# define the port number the container should expose
# 80 for HTTP && 443 for HTTPS
EXPOSE 80 443 110

# run the command
CMD service nginx start &&\
	service mysql start &&\
	service php7.3-fpm start &&\
	service sendmail start &&\
	bash

# NOTES: Turn autoindex off in interactive mode: 
# cd /etc/nginx/sites-available/ && sed -i 's/autoindex on/autoindex off/g' localhost
# service nginx restart

# NOTES: Create a new wordpress user via command line: 
# wp user create username emailaddress@hioh.com --allow-root --path=/var/www/html/wordpress/