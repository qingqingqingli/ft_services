#!/bin/bash

echo "Cleaning starts!"

# remove deployment
echo "Delete k8s deployment & service"
kubectl delete -f nginx/nginx_deployment.yml
kubectl delete -f nginx/nginx_service.yml
# kubectl delete deployment.apps/nginx-frontend
# kubectl delete service/nginx-frontend

# remove all images
echo "Remove docker images"
docker image prune -a --force

echo "Cleaning finishes!"
