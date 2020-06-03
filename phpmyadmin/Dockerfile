# OS base image
FROM alpine:3.12

# maintainer
LABEL maintainer="qli"

# update the repo
RUN apk update

# install wget
RUN apk add wget && rm -f /var/cache/apk/*

# install phpMyAdmin
RUN mkdir -p /usr/share/webapps/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-english.tar.gz
RUN tar -zxvf phpMyAdmin-4.9.5-english.tar.gz
RUN mv phpMyAdmin-4.9.5-english /usr/share/webapps
RUN rm -f phpMyAdmin-4.9.5-english.tar.gz
RUN cd /usr/share/webapps/ &&\
	mv phpMyAdmin-4.9.5-english phpmyadmin
RUN chmod -R 777 /usr/share/webapps/


# expose port
