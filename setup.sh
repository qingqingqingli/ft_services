#!/bin/bash

echo "Process starts!"

echo "***Build Docker Image***"
docker build -t nginx nginx/

echo "***Create k8s deployment & service***"
kubectl apply -k ./

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
