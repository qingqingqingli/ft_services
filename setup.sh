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

# echo -e "$Purple PROCESS STARTS\n$Color_Off"
# minikube delete
# rm -rf /Volumes/Storage/goinfre/qli/minikube/.minikube
# mkdir -p ~/goinfre/minikube
# chmod +x ~/goinfre/minikube
# export MINIKUBE_HOME=/Volumes/Storage/goinfre/qli/minikube/

# extend nodeport range at startup
# minikube start --driver=virtualbox --extra-config=apiserver.service-node-port-range=1-65535

# echo -e "$Purple Add ingress & dashboard$Color_Off"
# minikube addons enable ingress
# minikube addons enable dashboard
# minikube addons enable metrics-server
# sleep 60

# connect docker to minikube
# echo -e "$Purple connect docker to minikube$Color_Off"
# eval $(minikube -p minikube docker-env)

echo -e "\n$Purple Build Docker Image$Color_Off"
docker build -t nginx nginx/

echo -e "\n$Purple Create ingress secrets$Color_Off"
kubectl create secret tls ingress-secret --key ingress/localhost.key --cert ingress/localhost.cert 

echo -e "\n$Purple Create k8s objects$Color_Off"
kubectl apply -k ./

echo -e "\n$Purple\nDisplay all k8s objects$Color_Off"
kubectl get all

echo -e "\n$Purple\nAccess to services: \n$Color_Off"
echo -e "Link to Nginx: https://$(minikube ip)"
echo -e "Link to Wordpress: http://$(minikube ip):5050"
echo -e "Link to phpMyAdmin: http://$(minikube ip):5000"
echo -e "Link to Grafana: http://$(minikube ip):3000"

echo -e "\n$Purple\nDisplay dashboard$Color_Off"
minikube dashboard

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
