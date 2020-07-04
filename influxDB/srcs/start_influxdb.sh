#!/bin/bash

set -m
CONFIG_FILE="/etc/influxdb/influxdb.conf"

exec influxd -config=${CONFIG_FILE}