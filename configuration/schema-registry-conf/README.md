# Kafka Schema Registry
Schema Registry installation and configuration.

## Overview
This is a single instance setup based on [Confluent Platform 5.1](https://docs.confluent.io/current/schema-registry/docs/installation.html).

## Installation and configuration
### Schema Registry
```console
$ cd lambda-arch/configuration
$ scp -r schema-registry-conf ubuntu@k8s-node01:/home/ubuntu
$ ssh ubuntu@k8s-node01
$ cd schema-registry-conf
$ ./setup-registry.sh
```

### REST Proxy
```console
$ ssh ubuntu@k8s-node01
$ cd schema-registry-conf
$ ./setup-rest-proxy.sh
```
