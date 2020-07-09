FROM alpine

LABEL maintainer="qli"

# Setting environment variables
ENV MYSQL_ROOT_PASSWORD=admin
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=admin

# Installing packages MariaDB
RUN apk update && \
    apk upgrade --available && \
    apk add --no-cache mysql mysql-client
RUN addgroup mysql mysql

# Copy of the MySQL startup script
COPY srcs/my.cnf /etc/mysql/my.cnf
COPY srcs/start.sh .
RUN chmod +x start.sh

# Creating the persistent volume
VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

CMD sh start.sh