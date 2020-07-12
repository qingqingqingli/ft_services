#!/bin/bash

# Color values
Color_Off='\033[0m'       # Text Reset
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

####################################################################
#                           CLEANING STARTS                        #
####################################################################
echo -e "$Green Cleaning starts!\n$Color_Off"

####################################################################
#                           REMOVING K8S OBJECTS                   #
####################################################################

# [CONNECT DOCKER TO MINIKUBE]
eval $(minikube -p minikube docker-env)

echo -e "$Green Delete k8s deployment & service$Color_Off"
kubectl delete -f srcs/nginx/nginx.yml
kubectl delete -f srcs/ftps/ftps.yml
kubectl delete -f srcs/mysql/mysql.yml
kubectl delete -f srcs/wordpress/wordpress.yml
kubectl delete -f srcs/phpmyadmin/phpmyadmin.yml
kubectl delete -f srcs/influxDB/influxdb.yml
kubectl delete -f srcs/grafana/grafana.yml
kubectl delete -f srcs/telegraf/telegraf.yml

kubectl delete -f srcs/secret.yml

kubectl delete configmap/grafana-config

####################################################################
#                           REMOVE METALLB                         #
####################################################################

# [DEPLOY MANIFEST]
# kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
# kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# kubectl delete secret -n metallb-system memberlist
# kubectl delete -f srcs/metalLB/metalLB_config.yml

####################################################################
#                           REMOVING DOCKER PROPERTIES             #
####################################################################

# [CONNECT DOCKER TO MINIKUBE]
eval $(minikube -p minikube docker-env)

echo -e "\n$Green Remove docker images & containers$Color_Off"
docker container prune -f
docker image prune -a --force

echo -e "\n$Green Cleaning finishes!$Color_Off"