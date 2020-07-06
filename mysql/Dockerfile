# FROM alpine:3.12

# LABEL maintainer="qli"

# LABEL APP_REPOSITORY="https://pkgs.alpinelinux.org/package/edge/main/aarch64/mysql"

# ENV MYSQL_ROOT_PASSWORD test
# ENV MYSQL_DATABASE wordpress
# ENV MYSQL_USER test
# ENV MYSQL_PASSWORD test

# # Installing packages MariaDB
# RUN apk add --no-cache mysql
# RUN addgroup mysql mysql

# # Copy of the MySQL startup script
# COPY srcs/start_mysql.sh /run.sh
# RUN chmod +x /run.sh

# EXPOSE 3306

# CMD ["/run.sh"]


FROM alpine:latest

ENV MYSQL_ROOT_PASSWORD root
ENV MYSQL_DATABASE wordpress
ENV MYSQL_USER test
ENV MYSQL_PASSWORD test

WORKDIR /app
VOLUME /app

RUN apk add --update mysql mysql-client && rm -f /var/cache/apk/*

# These lines moved to the end allow us to rebuild image quickly after only these files were modified.
COPY startup.sh /startup.sh
COPY my.cnf /etc/mysql/my.cnf

RUN chmod +x /startup.sh

EXPOSE 3306
CMD ["/startup.sh"]