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