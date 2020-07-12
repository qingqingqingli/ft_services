FROM alpine

LABEL maintainer="qli"

# Setting environment variables
ENV MYSQL_ROOT_PASSWORD=admin
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=admin

# Installing packages MariaDB
RUN apk add --no-cache mysql mysql-client
RUN addgroup mysql mysql

# copy wordpress database
RUN mkdir -p /tmp
COPY srcs/wordpress.sql /tmp/wordpress.sql
COPY srcs/my.cnf /etc/mysql/my.cnf
COPY srcs/init_1.sh /tmp/init_1.sh
COPY srcs/init_2.sh /tmp/init_2.sh
RUN chmod +x /tmp/init_1.sh
RUN chmod +x /tmp/init_2.sh

EXPOSE 3306

CMD sh /tmp/init_1.sh