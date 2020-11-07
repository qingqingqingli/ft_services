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
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

![ft_services_0](https://github.com/qingqingqingli/readme_images/blob/master/ft_services_0.png)