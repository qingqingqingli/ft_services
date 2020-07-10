FROM alpine

LABEL maintainer="qli"

ENV VERSION_WORDPRESS 4.9.6
ENV APACHE_SERVER_NAME example.com
ENV APACHE_SERVER_PATH /var/www/localhost/htdocs
ENV MYSQL_DATABASE wordpress
ENV MYSQL_USER admin
ENV MYSQL_PASSWORD admin
ENV MYSQL_HOST mysql

# Installing dependencies
RUN apk add --no-cache --virtual .build-deps unzip wget mysql mysql-client
RUN apk add --no-cache apache2 php7 php7-apache2 php7-openssl php7-xml php7-pdo php7-mcrypt php7-session php7-mysqli php7-zlib su-exec
RUN mkdir -p /run/apache2 /run/httpd

# Download & install wordpress
RUN wget -c https://wordpress.org/wordpress-${VERSION_WORDPRESS}.zip
RUN unzip -q wordpress-${VERSION_WORDPRESS}.zip -d ./ && \
    rm -rf ${APACHE_SERVER_PATH} && \
    mv wordpress/ ${APACHE_SERVER_PATH} && \
    rm /wordpress-${VERSION_WORDPRESS}.zip \
        ${APACHE_SERVER_PATH}/wp-config-sample.php \
        ${APACHE_SERVER_PATH}/license.txt \
        ${APACHE_SERVER_PATH}/readme.html && \
    chown -R apache:apache ${APACHE_SERVER_PATH} && \
    apk del .build-deps

# Copy of the HTTPD startup script
COPY srcs/wp-config.php ${APACHE_SERVER_PATH}/wp-config.php
COPY srcs/start.sh ./start.sh
RUN chmod +x ./start.sh

EXPOSE 80

CMD [ "./start.sh" ]