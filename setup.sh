#!/bin/bash

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

echo -e "$Purple Process starts!\n$Color_Off"

# Installing nginx ingress takes some time
# echo -e "$Purple Install Nginx Ingress Controller\n$Color_Off"
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml

# Installing k8s dashboard
# echo -e "$Purple Install k8s dashboard\n$Color_Off"
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

# enable ingress controller
# minikube addons enable ingress

echo -e "$Purple Build Docker Image$Color_Off"
docker build -t nginx_qli nginx/

echo -e "\n$Purple Create ingress secrets$Color_Off"
kubectl create secret tls ingress-secret --key ingress/localhost.key --cert ingress/localhost.cert 
# kubectl create secret generic ca-secret --from-file=tls.crt=ingress/server.crt \
# --from-file=tls.key=ingress/server.key --from-file=ca.crt=ingress/ca.crt

echo -e "\n$Purple Create k8s objects$Color_Off"
kubectl apply -k ./

echo -e "\n$Purple\nDisplay all k8s objects$Color_Off"
kubectl get all

# docker desktop ip
# 192.168.1.104

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

# to enable dashboard & ingress controller
# minikube addons enable ingress
# minikube addons enable dashboard

# to get minikube ip
# minikube ip
# 192.168.99.100

# minikube dashboard missing package
# sudo apt install appmenu-gtk2-module appmenu-gtk3-module