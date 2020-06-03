# OS base image
FROM alpine

# maintainer
LABEL maintainer="qli"

# environment variables
ENV MYSQL_ROOT_PASSWORD root
ENV MYSQL_DATABASE app
ENV MYSQL_USER app
ENV MYSQL_PASSWORD app
ENV MYSQL_USER_MONITORING monitoring
ENV MYSQL_PASSWORD_MONITORING monitoring

# update the repo
RUN apk update

# install mysql
RUN apk add --no-cache mysql mysql-client && rm -f /var/cache/apk/*
RUN addgroup mysql mysql
RUN mkdir -p /run/mysqld
RUN chown -R mysql:mysql /run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql

RUN mysql_install_db --user=mysql > /dev/null
RUN echo "[i] MySql root password: $MYSQL_ROOT_PASSWORD"

# RUN service mysql start && \
# 	echo "CREATE USER 'qli'@'localhost' IDENTIFIED BY 'server';" | mysql -u root && \
# 	echo "GRANT ALL PRIVILEGES ON *.* TO 'qli'@'localhost';" | mysql -u root && \
# 	echo "CREATE USER 'pma'@'localhost' IDENTIFIED BY 'pmapass';" | mysql -u root && \
# 	echo "GRANT ALL PRIVILEGES ON *.* TO 'pma'@'localhost';" | mysql -u root && \
# 	echo "GRANT SELECT, INSERT, DELETE, UPDATE ON phpmyadmin.* TO 'root'@'localhost';" | mysql -u root && \
# 	echo "FLUSH PRIVILEGES;" | mysql -u root && \
# 	echo "update mysql.user set plugin = 'mysql_native_password' where user='root';" | mysql -u root

RUN USE mysql; &&\
	FLUSH PRIVILEGES; &&\
	DELETE FROM mysql.user; &&\
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION; &&\
	GRANT SELECT, SHOW VIEW, PROCESS ON *.* TO '$MYSQL_USER_MONITORING'@'%' IDENTIFIED BY '$MYSQL_PASSWORD_MONITORING' WITH GRANT OPTION;

EXPOSE 3306

# Creating the persistent volume

VOLUME [ "/var/lib/mysql" ]

ENTRYPOINT [ "./start.sh" ]