# Apache Cassandra
[Cassandra](http://cassandra.apache.org) is the NoSQL database we'll use for the View and Speed layers.

## Installation
```console
$ ssh ubuntu@k8s-node09
$ echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
$ curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
$ sudo apt-get update
$ sudo apt-get install -y cassandra
$ scp -r cassandra-conf ubuntu@k8s-node09:/home/ubuntu
$ cd cassandra-conf
$ ./setup-cassandra.sh
```
