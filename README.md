[![Logo](https://github.com/qingqingqingli/readme_images/blob/master/codam_logo_1.png)](https://github.com/qingqingqingli/ft_services)

# ft_services
***This is a System Administration and Networking project. It introduces us to cluster management and deployment with Kubernetes.***

## Technical considerations

- Must use Kubernetes
- Set up a multi-service cluster. Each service run in a dedicated container
- Containers to be built using Alpine Linux
- Dockerfile needs to be built. Forbidden to use docker images from DockerHub

## How to test

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
```

![ft_services_0](https://github.com/qingqingqingli/readme_images/blob/master/ft_services_0.png)

![ft_services_1](https://github.com/qingqingqingli/readme_images/blob/master/ft_services_1.png)