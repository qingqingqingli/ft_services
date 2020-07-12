#!/bin/bash

#starting sql
printf 'Waiting for mysql'
until mysql
do
	echo "."
	sleep 1
done
printf '\n'

# sending commands into commands.sql
cat << EOF > commands.sql
USE wordpress;
UPDATE wp_options SET option_value = "http://192.168.99.202:5050" WHERE option_id BETWEEN 1 AND 2;
USE mysql;
CREATE USER 'admin'@'%';
GRANT ALL PRIVILEGES ON wordpress.* TO 'admin'@'%' WITH GRANT OPTION;
SET PASSWORD FOR 'admin'@'%' = PASSWORD('admin');
FLUSH PRIVILEGES;
EOF

# sending commands into mysql
mysql -u root -e 'CREATE DATABASE wordpress;'
mysql -u root wordpress < /tmp/wordpress.sql
mysql -u root < commands.sql

rm -f commands.sql