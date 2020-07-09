FROM alpine:3.12

LABEL maintainer="qli"

ENV INFLUXDB_VERSION=1.8.0

RUN mkdir /tmp/influxdb \
    && wget https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}_linux_amd64.tar.gz \
    && tar xvfz influxdb-${INFLUXDB_VERSION}_linux_amd64.tar.gz \
    && rm influxdb-${INFLUXDB_VERSION}_linux_amd64.tar.gz

COPY srcs/influxdb.conf /etc/influxdb/influxdb.conf

COPY srcs/start_influxdb.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 8086

CMD ["/run.sh"]