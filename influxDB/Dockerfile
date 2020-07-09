FROM alpine

LABEL maintainer="qli"

# Installing packages & influxdb
RUN apk update && apk add influxdb

VOLUME [ "/var/lib/influxdb" ]

# copy relevant files
COPY start.sh .
RUN chmod +x ./start.sh

EXPOSE 8086

CMD sh start.sh