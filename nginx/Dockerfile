# OS base image
FROM alpine:3.12

# maintainer
LABEL maintainer="qli"

# update the repo
RUN apk update

# install nginx openssl
RUN apk add nginx openssl openssh && rm -f /var/cache/apk/*

# create user & give access
RUN adduser -D -g 'www' www

# create a directory for html files
RUN mkdir /www
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /www
COPY srcs/index.html /www
COPY srcs/style.css /www

# generate ssl certificate
RUN openssl req -x509 \
	-nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/localhost.key \
	-out /etc/ssl/certs/localhost.crt \
	-subj "/C=NL/ST=Noord Holland/L=Amsterdam\
	/O=Codam/CN=www.localhost.com"

# copy config file
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
COPY srcs/nginx.conf /etc/nginx/

# create a /bin/bash directory
RUN mkdir -p /bin/bash
RUN chmod -R 777 /bin/bash
RUN chown -R www:www /bin/bash

# add ssh user & config
RUN addgroup ssh && adduser -DH -G ssh test && \
	echo "test:test" | chpasswd && \
	ssh-keygen -A
COPY srcs/sshd_config /etc/ssh/sshd_config

# expose ports
EXPOSE 80 443 4500

# start nginx
RUN mkdir -p /run/nginx/
COPY srcs/start_nginx.sh /bin/bash/start_nginx.sh
RUN chmod +x /bin/bash/start_nginx.sh
CMD ["bin/sh", "/bin/bash/start_nginx.sh"]
