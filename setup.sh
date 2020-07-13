#!/bin/bash

# Set color
Color_Off='\033[0m'       # Text Reset
lack='\033[0;30m'         # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

####################################################################
#                           MINIKUBE SETUP                         #
####################################################################

# ---------------------------PREREQUISITES------------
echo -e "$Purple DELETE EXISTING MINIKUBE $Color_Off"
# minikube delete
# rm -rf /Volumes/Storage/goinfre/INTRA_NAME/minikube/.minikube

echo -e "$Purple INSTALL MINIKUBE & KUBECTL $Color_Off"
# install homebrew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# install kubectl
# brew install kubectl

# install minikube
# brew install minikube
# mkdir -p ~/goinfre/minikube
# chmod +x ~/goinfre/minikube
# export MINIKUBE_HOME=/Volumes/Storage/goinfre/INTRA_NAME/minikube/

echo -e "$Purple INSTALL DOCKER & VIRTUALBOX $Color_Off"
# Go to Managed Software Center

echo -e "$Purple INSTALL FILEZILLA CLIENT $Color_Off"
# https://filezilla-project.org/download.php?platform=osx

# ---------------------------START MINIKUBE-------------------------
echo -e "$Purple START A MINIKUBE INSTANCE$Color_Off"
minikube delete
minikube start --driver=virtualbox --memory=3000MB --bootstrapper=kubeadm

# change this based on whether it's macos or linux
# ---------------------------REPLACE MINIKUBE_IP--------------------
echo -e "$Purple REPLACE MINIKUBE_IP$Color_Off"
# MacOS
sed -i "" "s|MINIKUBE_IP|$(minikube ip)|g" srcs/secret.yml
# Linux
sed -i "s|MINIKUBE_IP|$(minikube ip)|g" srcs/secret.yml

# ---------------------------ADD MINIKUBE ADDONS--------------------
echo -e "$Purple ADD MINIKUBE ADDONS$Color_Off"
minikube addons enable dashboard
minikube addons enable metrics-server
sleep 5

# ---------------------------CONNECT MINIKUBE TO DOCKER-------------
echo -e "$Purple CONNECT MINIKUBE TO DOCKER$Color_Off"
eval $(minikube -p minikube docker-env)

####################################################################
#                           DEPLOY METALLB                         #
####################################################################

# ---------------------------DEPLOY METALLB-------------------------
echo -e "$Purple DEPLOY METALLB$Color_Off"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f srcs/metalLB/metalLB_config.yml

####################################################################
#                           DEPLOY SECRETS                         #
####################################################################

# ---------------------------DEPLOY SECRETS-------------------------
echo -e "$Purple DEPLOY SECRETS$Color_Off"
kubectl apply -f srcs/secret.yml

####################################################################
#                           DEPLOY SERVICES                        #
####################################################################

# ---------------------------DEPLOY NGINX---------------------------
echo -e "$Purple DEPLOY NGINX$Color_Off"
docker build -t nginx srcs/nginx/
kubectl apply -f srcs/nginx/nginx.yml

# to access nginx via ssh
# ssh test@192.168.99.200 -p 4500

# ---------------------------DEPLOY FTPS----------------------------
echo -e "$Purple DEPLOY FTPS$Color_Off"
docker build -t ftps srcs/ftps/
kubectl apply -f srcs/ftps/ftps.yml

# ---------------------------DEPLOY MYSQL---------------------------
echo -e "$Purple DEPLOY MYSQL$Color_Off"

docker build -t mysql srcs/mysql/
kubectl apply -f srcs/mysql/mysql.yml

# ---------------------------DEPLOY WORDPRESS-----------------------
echo -e "$Purple DEPLOY WORDPRESS$Color_Off"

docker build -t wordpress srcs/wordpress/
kubectl apply -f srcs/wordpress/wordpress.yml

# ---------------------------DEPLOY PHPMYADMIN----------------------
echo -e "$Purple DEPLOY PHPMYADMIN$Color_Off"

docker build -t phpmyadmin srcs/phpmyadmin/
kubectl apply -f srcs/phpmyadmin/phpmyadmin.yml

# ---------------------------DEPLOY INFLUXDB------------------------
echo -e "$Purple DEPLOY INFLUXDB$Color_Off"

docker build -t influxdb srcs/influxDB/
kubectl apply -f srcs/influxDB/influxdb.yml

# ---------------------------DEPLOY GRAFANA-------------------------
echo -e "$Purple DEPLOY GRAFANA$Color_Off"

docker build -t grafana srcs/grafana/

sleep 5

kubectl create configmap grafana-config \
--from-file=grafana_datasource.yml=srcs/grafana/grafana_datasource.yml \
--from-file=grafana_dashboard_provider.yml=srcs/grafana/grafana_dashboard_provider.yml \
--from-file=influxdb_dashboard.json=srcs/grafana/dashboard/influxdb_dashboard.json \
--from-file=mysql_dashboard.json=srcs/grafana/dashboard/mysql_dashboard.json \
--from-file=grafana_dashboard.json=srcs/grafana/dashboard/grafana_dashboard.json \
--from-file=nginx_dashboard.json=srcs/grafana/dashboard/nginx_dashboard.json \
--from-file=phpmyadmin_dashboard.json=srcs/grafana/dashboard/phpmyadmin_dashboard.json \
--from-file=wordpress_dashboard.json=srcs/grafana/dashboard/wordpress_dashboard.json \
--from-file=ftps_dashboard.json=srcs/grafana/dashboard/ftps_dashboard.json

kubectl apply -f srcs/grafana/grafana.yml

# ---------------------------DEPLOY TELEGRAF------------------------
echo -e "$Purple DEPLOY TELEGRAF$Color_Off"

docker build -t telegraf srcs/telegraf/
kubectl apply -f srcs/telegraf/telegraf.yml

####################################################################
#                           DISPLAY OBJECTS & LINKS                #
####################################################################

# ---------------------------DISPLAY ALL K8S OBJECTS----------------
echo -e "$Purple DISPLAY ALL K8S OBJECTS$Color_Off"
kubectl get all

# ---------------------------MINIKUBE DASHBOARD---------------------
echo -e "$Purple MINIKUBE DASHBOARD$Color_Off"
minikube dashboard

# ####################################################################
# #                           REMOVING K8S OBJECTS                   #
# ####################################################################

# # [CONNECT DOCKER TO MINIKUBE]
# eval $(minikube -p minikube docker-env)

# echo -e "$Green Delete k8s deployment & service$Color_Off"
# kubectl delete -f srcs/nginx/nginx.yml
# kubectl delete -f srcs/ftps/ftps.yml
# kubectl delete -f srcs/mysql/mysql.yml
# kubectl delete -f srcs/wordpress/wordpress.yml
# kubectl delete -f srcs/phpmyadmin/phpmyadmin.yml
# kubectl delete -f srcs/influxDB/influxdb.yml
# kubectl delete -f srcs/grafana/grafana.yml
# kubectl delete -f srcs/telegraf/telegraf.yml

# kubectl delete -f srcs/secret.yml

# kubectl delete configmap/grafana-config

# ####################################################################
# #                           REMOVE METALLB                         #
# ####################################################################

# # [DEPLOY MANIFEST]
# kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
# kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# kubectl delete secret -n metallb-system memberlist
# kubectl delete -f srcs/metalLB/metalLB_config.yml

# ####################################################################
# #                           REMOVING DOCKER PROPERTIES             #
# ####################################################################

# # [CONNECT DOCKER TO MINIKUBE]
# eval $(minikube -p minikube docker-env)

# echo -e "\n$Green Remove docker images & containers$Color_Off"
# docker container prune -f
# docker image prune -a --force

# remove minikube
# minikube delete
# rm -rf /Volumes/Storage/goinfre/INTRA_NAME/minikube/.minikube

# echo -e "\n$Green Cleaning finishes!$Color_Off"