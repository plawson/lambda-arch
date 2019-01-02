# Kafka
Kafka installation and configuration.

## Overview
This is a single node Kafka broker configuration. In production at 3 Kafka instances are needed.
The Kafka version is 2.1.0 (Scala 2.11).

## Installation and configuration
Kafka cluster creation:
```console
$ cd lambda-arch/configuration
$ scp -r kafka-conf ubuntu@k8s-node04:/home/ubuntu
$ ssh ubuntu@k8s-node04
$ cd kafka-conf
$ ./setup-kafka.sh
```
"tweets" topic creation:
```console
$ ssh ubuntu@k8s-node04
$ cd kafka
$ bin/kafka-topics.sh --zookeeper zookeeper:2181 --create --topic tweets --replication-factor 1 --partitions 3
```
