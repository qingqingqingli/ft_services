FROM alpine:3.12

LABEL maintainer="qli"

ENV PHP_MYADMIN_VERSION="4.9.5" \
    PMA_DB="phpmyadmin" \
    PMA_SECRET="mjB47SYB;2w[jqZncnMat.IeuP{]WAg;" \
    PMA_USERNAME="pma" \
    PMA_PASSWORD="password" \
    MYSQL_HOSTNAME="mysql" \
    PMA_HOST="mysql" \
    PMA_PORT="3306"

RUN apk upgrade \
    && apk --update add php7 php7-mbstring php7-session php7-bcmath php7-cli php7-ctype php7-curl php7-fpm php7-gd php7-json php7-mcrypt php7-mysqli \
      php7-opcache php7-openssl php7-pdo php7-pdo_mysql php7-phar php7-xml php7-zip php7-zlib ca-certificates \
      nginx mysql-client curl xz sed \
    && curl -L http://files.phpmyadmin.net/phpMyAdmin/${PHP_MYADMIN_VERSION}/phpMyAdmin-${PHP_MYADMIN_VERSION}-all-languages.tar.xz -o /phpmyadmin.tar.xz \
    && tar -xJpf /phpmyadmin.tar.xz \
    && rm -rf /phpmyadmin.tar.xz \
    && mkdir -p /www/ /www/tmp\
    && mv /phpMyAdmin-*-all-languages /www/phpmyadmin \
    && sed -i \
        -e "s/upload_max_filesize = .*/upload_max_filesize = 64M/" \
        -e "s/post_max_size = .*/post_max_size = 64M/"  \
        -e "s/max_execution_time = .*/max_execution_time = 300/" \
        /etc/php7/php.ini

COPY ./srcs/config.ini.php /www/phpmyadmin/config.inc.php
COPY ./srcs/start.sh /start.sh
COPY ./srcs/nginx.conf /etc/nginx/nginx.conf
COPY ./srcs/php-fpm.conf /etc/php7/php-fpm.conf

RUN chmod u+x /start.sh

EXPOSE 80

CMD ["/start.sh"]