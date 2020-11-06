FROM alpine

LABEL maintainer="qli"

ENV TELEGRAF_VERSION 1.14.5

RUN apk add --no-cache wget

RUN wget -c https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz
RUN tar -xzvf telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz
RUN rm -rf telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz
RUN chmod +x telegraf/*
RUN cp telegraf/telegraf /usr/bin/

EXPOSE 8125

COPY srcs/start.sh .
RUN chmod +x ./start.sh

CMD sh start.sh