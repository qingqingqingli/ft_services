[![Logo](https://github.com/qingqingqingli/readme_images/blob/master/codam_logo_1.png)](https://github.com/qingqingqingli/ft_services)

# ft_services
***This is a System Administration and Networking project. It introduces us to cluster management and deployment with Kubernetes.***

## Technical considerations

- Must use Kubernetes
- Set up a multi-service cluster. Each service run in a dedicated container
- Containers to be built using Alpine Linux
- Dockerfile needs to be built. Forbidden to use docker images from DockerHub

## How to test
- Disclaimer: The ```setup.sh``` file in the repo includes steps to follow on MacOS. This demonstration is done on a Linux distribution (```Pop!_OS 20.04 LTS```).

> Step 1: Install Minikube

```shell
# install homebrew 
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# LINUX: Add Homebrew to your PATH and bash shell profile script
$ test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
$ test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
$ test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
$ echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

# install kubectl
$ brew install kubectl

# install minikube
$ brew install minikube
```

> Step 2: Install Docker, VirtualBox & FileZilla Client
- The required steps are dependant on the OS, and are therefore skipped here. 

> Step 3: Start a Minikube instace

```shell
# remove existing minikube instance
$ minikube delete

# Start a new minikube instance
$ minikube start --driver=virtualbox --memory=3000MB --bootstrapper=kubeadm

# MacOS: Replace minikube ip in secret file
$ sed -i "" "s|MINIKUBE_IP|$(minikube ip)|g" srcs/secret.yml

# Linux: Replace minikube ip in secret file
$ sed -i "s|MINIKUBE_IP|$(minikube ip)|g" srcs/secret.yml

# Add minikube instance
$ minikube addons enable dashboard
$ minikube addons enable metrics-server
$ sleep 5

# Connect minikube to docker
$ eval $(minikube -p minikube docker-env)

```
> Step 4: Deploy MetalLB, secrets & services

```shell
# Deploy MetalLB
$ kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
$ kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
$ kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
$ kubectl apply -f srcs/metalLB/metalLB_config.yml

# Deploy secrets
$ kubectl apply -f srcs/secret.yml

# Deploy Nginx
$ docker build -t nginx srcs/nginx/
$ kubectl apply -f srcs/nginx/nginx.yml

# Deploy FTPS
$ docker build -t ftps srcs/ftps/
$ kubectl apply -f srcs/ftps/ftps.yml

# Deploy MySQL
$ docker build -t mysql srcs/mysql/
$ kubectl apply -f srcs/mysql/mysql.yml

# Deploy Wordpress
$ docker build -t wordpress srcs/wordpress/
$ kubectl apply -f srcs/wordpress/wordpress.yml

# Deploy PhpMyAdmin
$ docker build -t phpmyadmin srcs/phpmyadmin/
$ kubectl apply -f srcs/phpmyadmin/phpmyadmin.yml

# Deploy influxDB
$ docker build -t influxdb srcs/influxDB/
$ kubectl apply -f srcs/influxDB/influxdb.yml

# Deploy Grafana
$ kubectl create configmap grafana-config \
--from-file=grafana_datasource.yml=srcs/grafana/grafana_datasource.yml \
--from-file=grafana_dashboard_provider.yml=srcs/grafana/grafana_dashboard_provider.yml \
--from-file=influxdb_dashboard.json=srcs/grafana/dashboard/influxdb_dashboard.json \
--from-file=mysql_dashboard.json=srcs/grafana/dashboard/mysql_dashboard.json \
--from-file=grafana_dashboard.json=srcs/grafana/dashboard/grafana_dashboard.json \
--from-file=nginx_dashboard.json=srcs/grafana/dashboard/nginx_dashboard.json \
--from-file=phpmyadmin_dashboard.json=srcs/grafana/dashboard/phpmyadmin_dashboard.json \
--from-file=wordpress_dashboard.json=srcs/grafana/dashboard/wordpress_dashboard.json \
--from-file=ftps_dashboard.json=srcs/grafana/dashboard/ftps_dashboard.json \
--from-file=telegraf_dashboard.json=srcs/grafana/dashboard/telegraf_dashboard.json

$ kubectl apply -f srcs/grafana/grafana.yml

# Deploy telegraf
$ docker build -t telegraf srcs/telegraf/
$ kubectl apply -f srcs/telegraf/telegraf.yml

```

## Examples

- Output of ```kubectle get all```

![ft_services_10](https://github.com/qingqingqingli/readme_images/blob/master/ft_services_10.png)

- Output of ```minikube dashboard```

![ft_services_11](https://github.com/qingqingqingli/readme_images/blob/master/ft_services_11.png)

- IP addresses of different services

![ft_services_12](https://github.com/qingqingqingli/readme_images/blob/master/ft_services_12.png)
