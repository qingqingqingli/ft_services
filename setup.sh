#!/bin/bash

# Set color
Color_Off='\033[0m'       # Text Reset
lack='\033[0;30m'        # Black
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

# ---------------------------DELETE EXISTING ENVIRONMENT------------
# echo -e "$Purple DELETE EXISTING ENVIRONMENT$Color_Off"
# minikube delete
# rm -rf /Volumes/Storage/goinfre/qli/minikube/.minikube
# mkdir -p ~/goinfre/minikube
# chmod +x ~/goinfre/minikube
# export MINIKUBE_HOME=/Volumes/Storage/goinfre/qli/minikube/

# ---------------------------START MINIKUBE-------------------------
# echo -e "$Purple START A MINIKUBE INSTANCE$Color_Off"
# minikube start --driver=virtualbox --memory=3000MB --bootstrapper=kubeadm \
# --extra-config=apiserver.service-node-port-range=1-65535

# ---------------------------REPLACE MINIKUBE_IP--------------------
echo -e "$Purple REPLACE MINIKUBE_IP$Color_Off"
# MacOS
sed -i "" "s|MINIKUBE_IP|$(minikube ip)|g" secret.yml
# Linux
# sed -i "s|MINIKUBE_IP|$(minikube ip)|g" secret.yml

# ---------------------------ADD MINIKUBE ADDONS--------------------
echo -e "$Purple ADD MINIKUBE ADDONS$Color_Off"
minikube addons enable dashboard
minikube addons enable metrics-server
sleep 15

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
kubectl apply -f metalLB/metalLB_config.yml
sleep 15

####################################################################
#                           DEPLOY SECRETS                         #
####################################################################

# ---------------------------DEPLOY SECRETS-------------------------
echo -e "$Purple DEPLOY SECRETS$Color_Off"
kubectl apply -f secret.yml

####################################################################
#                           DEPLOY SERVICES                        #
####################################################################

# ---------------------------DEPLOY NGINX---------------------------
echo -e "$Purple DEPLOY NGINX$Color_Off"
docker build -t nginx nginx/
kubectl apply -f nginx/nginx.yml

# ---------------------------DEPLOY FTPS----------------------------
echo -e "$Purple DEPLOY FTPS$Color_Off"
kubectl apply -f ftps/ftps.yml

# ---------------------------DEPLOY MYSQL---------------------------
echo -e "$Purple DEPLOY MYSQL$Color_Off"
kubectl apply -f mysql/mysql.yml

# ---------------------------DEPLOY WORDPRESS-----------------------
echo -e "$Purple DEPLOY WORDPRESS$Color_Off"
kubectl apply -f wordpress/wordpress.yml

# ---------------------------DEPLOY PHPMYADMIN----------------------
echo -e "$Purple DEPLOY PHPMYADMIN$Color_Off"
kubectl apply -f phpmyadmin/phpmyadmin.yml

# ---------------------------DEPLOY INFLUXDB------------------------
echo -e "$Purple DEPLOY INFLUXDB$Color_Off"
kubectl apply -f influxDB/influxdb.yml

# ---------------------------DEPLOY GRAFANA-------------------------
echo -e "$Purple DEPLOY GRAFANA$Color_Off"
kubectl create configmap grafana-config \
--from-file=grafana_datasource.yml=grafana/grafana_datasource.yml \
--from-file=grafana_dashboard_provider.yml=grafana/grafana_dashboard_provider.yml \
--from-file=influxdb_dashboard.json=grafana/influxdb_dashboard.json \
--from-file=mysql_dashboard.json=grafana/mysql_dashboard.json \
--from-file=grafana_dashboard.json=grafana/grafana_dashboard.json \
--from-file=nginx_dashboard.json=grafana/nginx_dashboard.json \
--from-file=phpmyadmin_dashboard.json=grafana/phpmyadmin_dashboard.json \
--from-file=wordpress_dashboard.json=grafana/wordpress_dashboard.json

kubectl apply -f grafana/grafana.yml

# ---------------------------DEPLOY TELEGRAF------------------------
echo -e "$Purple DEPLOY TELEGRAF$Color_Off"
kubectl apply -f telegraf/telegraf.yml

####################################################################
#                           DISPLAY OBJECTS & LINKS                #
####################################################################

# ---------------------------DISPLAY ALL K8S OBJECTS----------------
echo -e "$Purple DISPLAY ALL K8S OBJECTS$Color_Off"
kubectl get all

# ---------------------------MINIKUBE DASHBOARD---------------------
echo -e "$Purple MINIKUBE DASHBOARD$Color_Off"
# minikube dashboard

# ==================================================================

####################################################################
#                           MINIKUBE SETUP                         #
####################################################################

# [macOS]
# minikube delete
# rm -rf /Volumes/Storage/goinfre/qli/minikube/.minikube
# mkdir -p ~/goinfre/minikube
# chmod +x ~/goinfre/minikube
# export MINIKUBE_HOME=/Volumes/Storage/goinfre/qli/minikube/

# [LINUX - at root]
# minikube delete

# [MINIKUBE START - need to change nodeport]
# minikube start --driver=virtualbox --extra-config=apiserver.service-node-port-range=1-65535 --bootstrapper=kubeadm --extra-config=kubelet.authentication-token-webhook=true
# minikube start --driver=virtualbox --memory=3000MB --bootstrapper=kubeadm --extra-config=apiserver.service-node-port-range=1-65535

# echo -e "$Purple Change MINIKUBE_IP$Color_Off"

# MacOS
# [REPLACE MINIKUBE_IP TO ACTUAL IP]
# sed -i "" "s|MINIKUBE_IP|$(minikube ip)|g" secret.yml
# [REPLACE ACTUAL IP TO MINIKUBE_IP]
# sed -i "" "s|$(minikube ip)|MINIKUBE_IP|g" secret.yml

# Linux
# [REPLACE MINIKUBE_IP TO ACTUAL IP]
# sed -i "s|MINIKUBE_IP|$(minikube ip)|g" secret.yml
# [REPLACE ACTUAL IP TO MINIKUBE_IP]
# sed -i "s|$(minikube ip)|MINIKUBE_IP|g" secret.yml

# [ADD ALL MINIKUBE ADDONS]
# echo -e "$Purple Add ingress & dashboard$Color_Off"
# minikube addons enable ingress
# minikube addons enable dashboard
# minikube addons enable metrics-server
# sleep 15

# # [CONNECT DOCKER TO MINIKUBE]
# eval $(minikube -p minikube docker-env)

####################################################################
#                           DEPLOY METALLB                         #
####################################################################

# echo -e "$Purple Add metalLB$Color_Off"
# # [DEPLOY THE MANIFEST]
# kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
# kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# # [ONLY ON FIRST INSTALL]
# kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
# kubectl apply -f metalLB/metalLB_config.yml

####################################################################
#                           BUILD CUSTOM IMAGES                    #
####################################################################

# echo -e "\n$Purple Build Docker Image$Color_Off"
# docker build -t nginx nginx/

####################################################################
#                           BUILD K8S OBJECTS                      #
####################################################################

# echo -e "\n$Purple Build K8S Objects$Color_Off"

# echo -e "\n$Purple Create ingress secrets$Color_Off"
# kubectl create secret tls ingress-secret --key ingress/localhost.key --cert ingress/localhost.cert

# kubectl apply -f secret.yml 

# create grafana configmap 
# kubectl create configmap grafana-config \
# --from-file=grafana_datasource.yml=grafana/grafana_datasource.yml \
# --from-file=grafana_dashboard_provider.yml=grafana/grafana_dashboard_provider.yml \
# --from-file=influxdb_dashboard.json=grafana/influxdb_dashboard.json \
# --from-file=mysql_dashboard.json=grafana/mysql_dashboard.json \
# --from-file=grafana_dashboard.json=grafana/grafana_dashboard.json \
# --from-file=nginx_dashboard.json=grafana/nginx_dashboard.json \
# --from-file=phpmyadmin_dashboard.json=grafana/phpmyadmin_dashboard.json \
# --from-file=wordpress_dashboard.json=grafana/wordpress_dashboard.json

# echo -e "\n$Purple Create k8s objects$Color_Off"
# kubectl apply -k ./

####################################################################
#                           DISPLAY OBJECTS & LINKS                #
####################################################################
# echo -e "\n$Purple\nDisplay all k8s objects$Color_Off"
# kubectl get all

# echo -e "\n$Purple\nDisplay dashboard$Color_Off"
# minikube dashboard

####################################################################
#                           BACKUP COMMANDS                        #
####################################################################

# FileZilla download link
# https://dl1.cdn.filezilla-project.org/client/FileZilla_3.48.1_macosx-x86.app.tar.bz2?h=kZVZGu7vGVngVkZyQWdQ_A&x=1593598398

# Before running Docker, run the commands below

# mkdir -p ~/goinfre/docker
# rm -rf ~/Library/Containers/com.docker.docker
# ln -s ~/goinfre/docker ~/Library/Containers/com.docker.docker

# clearhome
# alias clearhome="echo -n \"Available before:\t\"; df -h | grep $HOME | sed 's/  */:/g' | cut -d ':' -f 4; unsetopt nomatch; rm -Rf ~/Library/*.42_cache_bak*; rm -Rf ~/*.42_cache_bak_*; setopt nomatch; echo -n \"Available after:\t\"; df -h | grep $HOME | sed 's/  */:/g' | cut -d ':' -f 4;"
# clearhome

# [ACCESS TO SERVICES]
# echo -e "\n$Purple\nAccess to services: \n$Color_Off"
# echo -e "Link to Nginx: https://$(minikube ip)"
# echo -e "Link to Wordpress: http://$(minikube ip):5050"
# echo -e "Link to phpMyAdmin: http://$(minikube ip):5000"
# echo -e "Link to Grafana: http://$(minikube ip):3000"

# check for container logs
# kubectl logs -f container_name

# Run the image in docker 
# docker run --rm -it -p 80:80 -p 443:443 nginx:latest

# get all kubernetes content
# kubectl get all

# apply kustimization file is a quick way to deploy all ymal files
# (create & reconfigure) kubectl apply -k ./ 
# (delete) kubectl delete -k ./

# get all kubernetes resources on all namespaces
# kubectl get all --all-namespaces

# check the file system inside a pod container
# kubectl exec -it pod_name  -- /bin/sh
# or 
# kubectl exec -it pod_name  -- /bin/bash

# to restart docker
# sudo systemctl restart docker

# to start minikube with a smaller amount of memory (docker as default)
# minikube start --memory=1g

# check minikube status
# minikube status

# to get minikube ip
# minikube ip

# minikube dashboard missing package
# sudo apt install appmenu-gtk2-module appmenu-gtk3-module

# to check the current file usage
# df -h

# another way to create ingress secret
# kubectl create secret generic ca-secret --from-file=tls.crt=ingress/server.crt \
# --from-file=tls.key=ingress/server.key --from-file=ca.crt=ingress/ca.crt

# replace all the IP addresses - Does not work yet
# sed -i '' 's/MINIKUBE_IP/$(minikube ip)/g' nginx/srcs/index.html

# echo -e "\n$Purple Create grafana configmap$Color_Off"
# kubectl create configmap grafana-config \
#   --from-file=influxdb-datasource.yml=grafana/influxdb-datasource.yml \
#   --from-file=grafana-dashboard-provider.yml=grafana/grafana-dashboard-provider.yml
