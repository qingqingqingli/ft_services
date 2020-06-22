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

echo -e "$Green Cleaning starts!\n$Color_Off"

# remove deployment
echo -e "$Green Delete k8s deployment & service$Color_Off"
kubectl delete -k ./

# remove ingress secret
echo -e "\n$Green Delete ingress secret$Color_Off"
kubectl delete secrets/ingress-secret
# kubectl delete secrets/ca-secret

# remove ingress controller
# echo -e "\n$Green Remove Nginx Ingress Controller$Color_Off"
# kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml

# remove all images
echo -e "\n$Green Remove docker images$Color_Off"
docker image prune -a --force
docker container prune -f

echo -e "\n$Green Cleaning finishes!$Color_Off"
