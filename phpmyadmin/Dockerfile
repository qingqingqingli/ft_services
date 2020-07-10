FROM alpine

LABEL maintainer="qli"

# download packages
RUN apk --no-cache add php7 php7-mbstring php7-session php7-bcmath php7-cli php7-ctype php7-curl php7-fpm php7-gd php7-json php7-mcrypt php7-mysqli wget

# download phpmyadmin
RUN wget -c https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-english.tar.gz
RUN tar -zxvf phpMyAdmin-4.9.5-english.tar.gz
RUN rm -f phpMyAdmin-4.9.5-english.tar.gz
RUN mv phpMyAdmin-4.9.5-english /www
RUN sed -i \
        -e "s/upload_max_filesize = .*/upload_max_filesize = 64M/" \
        -e "s/post_max_size = .*/post_max_size = 64M/"  \
        -e "s/max_execution_time = .*/max_execution_time = 300/" \
        /etc/php7/php.ini

# create tmp folders
RUN mkdir -p /www/tmp
RUN chmod 777 /www/tmp

# copy relevant files
COPY srcs/config.inc.php /www
COPY srcs/start.sh .
RUN chmod +x start.sh

EXPOSE 5000

CMD sh start.sh