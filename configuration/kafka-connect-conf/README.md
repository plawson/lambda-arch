# Kafka Connect
[Kefke Connect](http://kafka.apache.org/documentation/#connect) is a [Kafka](http://kafka.apache.org/) feature and framework that can be used for to implement deployable source and sink data injectors to and from Kafka. It is backed by a cluster allowing resiliency and scaling through failover and rebalance techniques. We will use the [Confluent Kafka Connect](https://docs.confluent.io/2.0.0/connect/index.html) implementation as it offer natural integration with the [Confluent Kafka Schema Registry](https://docs.confluent.io/current/schema-registry/docs/index.html) and much more.
We'll use Confluent Platform Community packge 5.1.

Installation:

Fork the [kafka-connect-twitter](https://github.com/Eneco/kafka-connect-twitter) Eneco repository. Update the framework version number in the pom.xml file to suit your environment. Create a lambda-arch/configuration/kafka-connect-conf/kafka-connect-twitter directory. Build the connector and copy the target/kafka-connect-twitter-0.1-jar-with-dependencies.jar to the lambda-arch/configuration/kafka-connect-conf/kafka-connect-twitter directory.
```console
$ cd lambda-arch/configuration
$ scp -r kafka-connect-conf ubuntu@k8s-node02:/home/ubuntu
$ ssh ubuntu@k8s-node02
$ cd kafka-connect-conf
$ ./setup-kafka-connect.sh
```
