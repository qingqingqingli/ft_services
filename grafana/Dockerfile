FROM alpine

LABEL maintainer="qli"

ENV GRAFANA_VERSION=7.0.5

RUN apk add --no-cache wget libc6-compat ca-certificates su-exec bash

RUN wget -c https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
    && tar -xzvf grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
    && rm grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
    && mv /grafana-${GRAFANA_VERSION} /usr/share/ \
    && mv /usr/share/grafana-${GRAFANA_VERSION} /usr/share/grafana

ENV PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV GF_PATHS_CONFIG="/etc/grafana/grafana.ini"
ENV GF_PATHS_DATA="/var/lib/grafana"
ENV GF_PATHS_HOME="/usr/share/grafana"
ENV GF_PATHS_LOGS="/var/log/grafana"
ENV GF_PATHS_PLUGINS="/var/lib/grafana/plugins"
ENV GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

RUN addgroup -S grafana && adduser -S grafana -G grafana

RUN mkdir -p "$GF_PATHS_HOME/.aws" "$GF_PATHS_PROVISIONING/datasources" "$GF_PATHS_PROVISIONING/dashboards" "$GF_PATHS_PROVISIONING/notifiers" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_DATA" \
    && chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING" \
    && chmod -R 777 "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING"

COPY srcs/grafana.ini "$GF_PATHS_CONFIG"
COPY srcs/start_grafana.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 3000

CMD ["/run.sh"]