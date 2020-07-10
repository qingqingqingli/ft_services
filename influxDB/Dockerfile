FROM alpine

LABEL maintainer="qli"

# Installing packages & influxdb
RUN apk add --no-cache influxdb

VOLUME [ "/var/lib/influxdb" ]

# copy relevant files
COPY srcs/start.sh .
RUN chmod +x ./start.sh

EXPOSE 8086

CMD sh start.sh