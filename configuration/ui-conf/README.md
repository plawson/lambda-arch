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

The UI is at [http://k8s-node10:8000](http://k8s-node10:8000)

## Kafka Topics UI
This is the [Landoop](https://github.com/Landoop/kafka-topics-ui) distribution. Browse Kafka topics and understand what's happening on your cluster. Find topics / view topic metadata / browse topic data (kafka messages) / view topic configuration / download data. This is a web tool for the [confluentinc/kafka-rest proxy](https://github.com/confluentinc/kafka-rest).

Intallation:
```console
$ cd lambda-arch/configuration/ui-conf
$ scp -r kafka-topics-ui ubuntu@k8s-node10:/home/ubuntu
$ ssh ubuntu@k8s-node10
$ docker pull landoop/kafka-topics-ui
```
Run the UI:
```console
$ ssh ubuntu@k8s-node10
$ cd kafka-topics-ui
$ ./start-topics-ui.sh
```

The UI is at [http://k8s-node10:8001](http://k8s-node10:8001)

## Kafka Manager
A tool for managing [Apache Kafka](http://kafka.apache.org/). The docker image is available at [https://hub.docker.com/r/hlebalbau/kafka-manager/](https://hub.docker.com/r/hlebalbau/kafka-manager/).

Installation
```console
$ cd lambda-arch/configuration/ui-conf
$ scp -r kafka-manager ubuntu@k8s-node10:/home/ubuntu
$ ssh ubuntu@k8s-node10
$ cd kafka-manager
$ docker pull hlebalbau/kafka-manager:stable
```

Run the UI:
```console
$ ssh ubuntu@k8s-node10
$ cd kafka-manager
$ ./start-kafka-manager.sh
```

The UI is at: [http://k8s-node10:9000](http://k8s-node10:9000)

## Schema Registry UI
This is the [Landoop](https://github.com/Landoop/schema-registry-ui).This is a web tool for the [confluentinc/schema-registry](https://github.com/confluentinc/schema-registry) in order to create / view / search / evolve / view history & configure Avro schemas of your Kafka cluster.

Installation:
```console
$ cd lambda-arch/configuration/ui-conf
$ scp -r schema-registry-ui ubuntu@k8s-node10:/home/ubuntu
$ ssh ubuntu@k8s-node10
$ docker pull landoop/schema-registry-ui
```

Run the UI:
```console
$ ssh ubuntu@k8s-node10
$ cd schema-registry-ui
$ ./start-schema-registry-ui.sh
```

The ui is at: [http://k8s-node10:8002](http://k8s-node10:8002)
