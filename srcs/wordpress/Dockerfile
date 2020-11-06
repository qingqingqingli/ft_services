FROM alpine

LABEL maintainer="qli"

RUN apk add --no-cache wget php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

# download wordpress
RUN mkdir -p /usr/share/webapps/
RUN wget -c https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz -C /usr/share/webapps/
RUN rm latest.tar.gz

# copy relevant file
COPY srcs/wp-config.php /usr/share/webapps/wordpress/wp-config.php
COPY srcs/start.sh .
RUN chmod +x ./start.sh

EXPOSE 5050

CMD sh ./start.sh