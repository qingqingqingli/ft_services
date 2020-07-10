FROM alpine

LABEL maintainer="qli"

RUN apk add --no-cache influxdb

COPY srcs/start.sh .
RUN chmod +x ./start.sh

EXPOSE 8086

CMD sh start.sh