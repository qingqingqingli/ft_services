#!/bin/bash

echo "Process starts!"

echo "***Build Docker Image***"
docker build -t nginx nginx/

echo "***Create k8s deployment & service***"
kubectl create -f nginx/nginx_deployment.yml
kubectl create -f nginx/nginx_service.yml

kubectl get pods

# docker desktop ip
# 192.168.1.104

# Run the image in docker 
# docker run --rm -it -p 80:80 -p 443:443 nginx:latest

# get all kubernetes content
# kubectl get all