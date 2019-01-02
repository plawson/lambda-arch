# Various UI
This node is used to install administration UIs.

## Docker
Some of the UIs are distributed as Docker images. Install [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose).

## ZooNavigator
This is an open source Zookeeper UI. The source code is available on [GitHub](https://github.com/elkozmon/zoonavigator). It is distributed as two Docker images.
```console
$ cd lambda-arch/configuration/ui-conf
$ scp -r zoonavigator ubuntu@k8s-node10:/home/ubuntu
$ ssh ubuntu@k8s-node10
$ cd zoonavigator
$ docker-compose up -d
```
