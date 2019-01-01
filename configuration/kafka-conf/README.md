# Kafka
Kafka installation and configuration.

## Overview
This is a single node Kafka broker configuration. In production at 3 Kafka instances are needed.
The Kafka version is 2.1.0 (Scala 2.11).

## Instalation and configuration
```console
$ cd lambda-arch/configuration
$ scp -r kafka-conf ubuntu@k8s-node04:/home/ubuntu
$ ssh ubuntu@k8s-node04
$ cd kafka-conf
$ ./setup-kafka.sh
```
