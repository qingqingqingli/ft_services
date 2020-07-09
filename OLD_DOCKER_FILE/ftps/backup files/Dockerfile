# OS base image
FROM alpine:3.12

# maintainer
LABEL maintainer="qli"

# update the repo
RUN apk update

# install openssl
RUN apk add openssl && rm -f /var/cache/apk/*

# install vsftpd
RUN apk add vsftpd

# copy config file
COPY srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf

# run vsftpd

RUN mkdir -p /run/vsftpd/
CMD ["vsftpd", "daemon off;"]
