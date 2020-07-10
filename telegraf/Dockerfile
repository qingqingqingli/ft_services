FROM alpine

LABEL maintainer="qli"

ENV TELEGRAF_VERSION 1.14.5

RUN apk update && apk add wget

# install telegraf package
RUN wget -c https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz
RUN tar -xzvf telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz
RUN rm -rf telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz
RUN chmod +x telegraf/*
RUN cp telegraf/telegraf /usr/bin/

EXPOSE 8125

COPY start.sh .
RUN chmod +x ./start.sh

CMD sh start.sh