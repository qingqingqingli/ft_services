# OS base image
FROM alpine:3.12

# maintainer
LABEL maintainer="qli"

# update the repo
RUN apk update

# install nginx
RUN apk add nginx openssl

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

# expose ports
EXPOSE 80 443

# start nginx
RUN mkdir /run/nginx/
CMD ["nginx", "-g", "daemon off;"]

