#!/bin/bash

# launch script without being dependent to user
nohup sh /tmp/init_2.sh > /dev/null 2>&1 &
# to listen external requests
sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf
# define directory for db
/usr/bin/mysql_install_db --user=mysql --datadir="/var/lib/mysql"
# launch MySQL
/usr/bin/mysqld_safe --datadir="/var/lib/mysql"