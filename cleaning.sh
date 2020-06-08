#!/bin/bash

echo "Cleaning starts!"

# remove deployment
echo "Delete k8s deployment & service"
kubectl delete -k ./

# remove all images
echo "Remove docker images"
docker image prune -a --force
docker container prune -f

echo "Cleaning finishes!"
