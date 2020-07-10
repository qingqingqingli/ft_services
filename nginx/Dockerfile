# OS base image
FROM alpine

# maintainer
LABEL maintainer="qli"

# install packages
RUN apk add --no-cache nginx openssl openssh

# create user & give access
RUN addgroup www && adduser -S www -G www

# create a directory for html files
RUN mkdir /www && chmod +x /www
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
COPY srcs/nginx.conf /etc/nginx/

# add ssh user & config
RUN addgroup ssh && adduser -DH -G ssh test && \
	echo "test:test" | chpasswd && \
	ssh-keygen -A
COPY srcs/sshd_config /etc/ssh/sshd_config

# expose ports
EXPOSE 80 443 4500

# start nginx
RUN mkdir -p /run/nginx/
COPY srcs/start.sh ./start.sh
RUN chmod +x ./start.sh
CMD sh ./start.sh
