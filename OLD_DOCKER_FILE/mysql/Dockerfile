FROM alpine:3.12

LABEL maintainer="qli"

ENV MYSQL_ROOT_PASSWORD admin
ENV MYSQL_DATABASE wordpress
ENV MYSQL_USER admin
ENV MYSQL_PASSWORD admin

# Installing packages MariaDB
RUN apk add --no-cache mysql
RUN addgroup mysql mysql

# Work path
WORKDIR /scripts

# Copy of the MySQL startup script
COPY start.sh ./start.sh
COPY my.cnf ./etc/mysql/my.cnf
RUN chmod +x ./start.sh

# Creating the persistent volume
VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

ENTRYPOINT [ "./start.sh" ]