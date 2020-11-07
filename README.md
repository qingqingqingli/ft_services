[![Logo](https://github.com/qingqingqingli/readme_images/blob/master/codam_logo_1.png)](https://github.com/qingqingqingli/ft_services)

# ft_services
***This is a System Administration and Networking project. It introduces us to cluster management and deployment with Kubernetes.***

## Technical considerations

- Must use Kubernetes
- Set up a multi-service cluster. Each service run in a dedicated container
- Containers to be built using Alpine Linux
- Dockerfile needs to be built. Forbidden to use docker images from DockerHub

## How to test
- Disclaimer: The ```setup.sh``` includes steps to follow on MacOS. This demonstration is done on a Linux distribution (```Pop!_OS 20.04 LTS```).

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

![ft_services_0](https://github.com/qingqingqingli/readme_images/blob/master/ft_services_0.png)

![ft_services_1](https://github.com/qingqingqingli/readme_images/blob/master/ft_services_1.png)

![ft_services_2](https://github.com/qingqingqingli/readme_images/blob/master/ft_services_2.png)

> Step 2: Install Docker, VirtualBox & FileZilla Client
- The steps needed depend on the OS and therefore skipped here. 

![ft_services_3](https://github.com/qingqingqingli/readme_images/blob/master/ft_services_3.png)

![ft_services_4](https://github.com/qingqingqingli/readme_images/blob/master/ft_services_4.png)

![ft_services_5](https://github.com/qingqingqingli/readme_images/blob/master/ft_services_5.png)

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