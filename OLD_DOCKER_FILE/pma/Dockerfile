FROM alpine

LABEL maintainer="qli"

RUN apk update &&\
    apk --update add php7 php7-mbstring php7-session php7-bcmath php7-cli php7-ctype php7-curl php7-fpm php7-gd php7-json php7-mcrypt php7-mysqli wget

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-english.tar.gz
RUN tar -zxvf phpMyAdmin-4.9.5-english.tar.gz
RUN mkdir -p /www/
RUN mv phpMyAdmin-4.9.5-english /www/phpmyadmin
RUN rm -f phpMyAdmin-4.9.5-english.tar.gz
COPY config.inc.php /www/phpmyadmin/config.inc.php
RUN sed -i \
        -e "s/upload_max_filesize = .*/upload_max_filesize = 64M/" \
        -e "s/post_max_size = .*/post_max_size = 64M/"  \
        -e "s/max_execution_time = .*/max_execution_time = 300/" \
        /etc/php7/php.ini

RUN mkdir -p /www/phpmyadmin/tmp
RUN chmod -R 777 /www/phpmyadmin/tmp

COPY ./start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 80

# CMD ["/start.sh"]