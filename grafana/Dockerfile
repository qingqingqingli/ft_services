# FROM alpine:3.12

# LABEL maintainer="qli"

# ENV GRAFANA_VERSION 4.6.3

# ENV GF_PATHS_CONFIG="/etc/grafana/conf/grafana.ini" \
#     # GF_PATHS_DATA="/var/lib/grafana" \
#     GF_PATHS_HOME="/etc/grafana/" \
#     # GF_PATHS_LOGS="/var/log/grafana" \
#     GF_PATHS_PLUGINS="/etc/grafana/plugins-bundled" \
#     GF_PATHS_PROVISIONING="/etc/grafana/conf/provisioning"

# RUN apk update \
#     && apk add --no-cache wget openrc openssl ca-certificates \
#     && wget https://dl.grafana.com/oss/release/grafana-7.0.5.linux-amd64.tar.gz \
#     && tar -zxvf grafana-7.0.5.linux-amd64.tar.gz \
#     && mv grafana-7.0.5/ etc/grafana/ \
#     && rm grafana-7.0.5.linux-amd64.tar.gz

# COPY srcs/grafana.ini /etc/grafana/conf/grafana.ini

# # WORKDIR /grafana

# EXPOSE 3000

# # start grafana
# # COPY srcs/start_grafana.sh /bin/bash/start_grafana.sh
# # RUN chmod +x /bin/bash/start_grafana.sh
# # CMD ["bin/sh", "/bin/bash/start_grafana.sh"]

# FROM alpine:3.12

# ENV GRAFANA_VERSION=7.0.0

# RUN mkdir /tmp/grafana \
#   && wget -P /tmp/ https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
#   && tar xfz /tmp/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz --strip-components=1 -C /tmp/grafana \
#   && rm /tmp/grafana-7.0.0.linux-amd64.tar.gz \
#   && mkdir -p /usr/share/grafana \
#   && mv /tmp/grafana/ /usr/share/

# ENV GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
#     GF_PATHS_HOME="/usr/share/grafana" \
#     GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

# RUN mkdir -p "$GF_PATHS_HOME/.aws" \
#     && mkdir -p "$GF_PATHS_PROVISIONING/datasources" \
#         "$GF_PATHS_PROVISIONING/dashboards" \
#         "$GF_PATHS_PROVISIONING/notifiers" \
#     && chmod -R 777 "$GF_PATHS_HOME/.aws" "$GF_PATHS_PROVISIONING"

# COPY srcs/grafana.ini "$GF_PATHS_CONFIG"
# COPY srcs/start_grafana.sh /run.sh
# RUN chmod +x /run.sh

# EXPOSE 3000

# CMD ["/run.sh"]

ARG BASE_IMAGE=alpine:3.12
FROM ${BASE_IMAGE}

ENV GRAFANA_VERSION=7.0.0
RUN mkdir /tmp/grafana \
  && wget -P /tmp/ https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
  && tar xfz /tmp/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz --strip-components=1 -C /tmp/grafana \
  && rm /tmp/grafana-7.0.0.linux-amd64.tar.gz \
  && mkdir -p /usr/share/grafana \
  && mv /tmp/grafana/ /usr/share/

ENV PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/usr/share/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

WORKDIR $GF_PATHS_HOME    

RUN set -ex \
    && addgroup -S grafana \
    && adduser -S -G grafana grafana \
    && apk add --no-cache libc6-compat ca-certificates su-exec bash

# COPY --from=0 /tmp/grafana "$GF_PATHS_HOME"
RUN mkdir -p "$GF_PATHS_HOME/.aws" \
    && mkdir -p "$GF_PATHS_PROVISIONING/datasources" \
        "$GF_PATHS_PROVISIONING/dashboards" \
        "$GF_PATHS_PROVISIONING/notifiers" \
        "$GF_PATHS_LOGS" \
        "$GF_PATHS_PLUGINS" \
        "$GF_PATHS_DATA" \
    && chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING" \
    && chmod -R 777 "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING"

COPY srcs/grafana.ini "$GF_PATHS_CONFIG"
COPY srcs/start_grafana.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 3000

CMD ["/run.sh"]