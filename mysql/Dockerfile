# OS base image
FROM alpine:3.12

# maintainer
LABEL maintainer="qli"

# update the repo
RUN apk update

# install mysql
RUN apk add mysql mysql-client && rm -f /var/cache/apk/*