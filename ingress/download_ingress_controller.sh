#!/bin/bash

# 1. [Install nginx ingress controller for docker for mac ]
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml

# 2. [check if ingress controller has been properly installed]
# kubectl get pods -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx --watch

# 3. [apply ingress resource - included in kustomization file]

# 4. [to check the url]
# -k allow for insecure connection
# -L redo curl when the requested page is moved to another location

# curl -kL http://localhost 
# curl -kL http://localhost/wordpress

# !! be aware that the current docker image only create
# the installation page. So you will need to firstly install
# before tesing the wordpress connection