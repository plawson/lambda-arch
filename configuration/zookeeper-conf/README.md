# Zookeeper
Zookeeper installation and configuration.

## Overview
This is a single node ZK configuration for one Kafka broker. In production a quorum of 3 or 5 ZK instances is to be used. Note that under 100 Kafka brokers, a 3 ZK instances quorum should be optimal setup in most cases.
The ZK version used is 3.4.0. This is the one provided by the Kafka 2.1.0 (Scala 2.11) distribution.

## Instalation and configuration
```console
$ cd lambda-arch/configuration
$ scp -r zookeeper-conf ubuntu@k8s-node03:/home/ubuntu
$ ssh ubuntu@k8s-node03
$ cd zookeeper-conf
$ ./setup-zookeeper.sh
```
