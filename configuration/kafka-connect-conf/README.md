# Kafka Connect
[Kafka Connect](http://kafka.apache.org/documentation/#connect) is a [Kafka](http://kafka.apache.org/) feature and framework that can be used for to implement deployable source and sink data ingestors to and from Kafka. It is backed by a cluster allowing resiliency and scaling through failover and rebalance techniques. We will use the [Confluent Kafka Connect](https://docs.confluent.io/2.0.0/connect/index.html) implementation as it offers natural integration with the [Confluent Kafka Schema Registry](https://docs.confluent.io/current/schema-registry/docs/index.html) and much more.
We'll use Confluent Platform Community packge 5.1.

## Installation

Fork the [kafka-connect-twitter](https://github.com/Eneco/kafka-connect-twitter) Eneco repository. Update the frameworks version numbers in the pom.xml file to suit your environment. Create a lambda-arch/configuration/kafka-connect-conf/kafka-connect-twitter directory. Build the connector and copy the target/kafka-connect-twitter-0.1-jar-with-dependencies.jar to the lambda-arch/configuration/kafka-connect-conf/kafka-connect-twitter directory.
```console
$ cd lambda-arch/configuration
$ scp -r kafka-connect-conf ubuntu@k8s-node02:/home/ubuntu
$ ssh ubuntu@k8s-node02
$ cd kafka-connect-conf
$ ./setup-kafka-connect.sh
```
## Create the connectors
Connectors can be created using the [kafka-connect-ui](https://github.com/plawson/lambda-arch/tree/master/configuration/ui-conf#kafka-connect-ui). However, the [Connect REST API](http://kafka.apache.org/documentation/#connect_rest) is better suited to automate connectors management. See the [Kafka Connect REST Interface](https://docs.confluent.io/current/connect/references/restapi.html) and [Managing Connectors](https://docs.confluent.io/3.2.0/connect/managing.html#common-rest-examples).

### Twitter source connector
In the below exerpt, replace (secret) with you Twitter keys.
```console
$ curl -XPOST -H "Content-Type: application/json" http://k8s-node02:8083/connectors -d '{
  "name": "LambdaTwitter",
  "config": {
    "connector.class": "com.eneco.trading.kafka.connect.twitter.TwitterSourceConnector",
    "twitter.token": "(secret)",
    "twitter.secret": "(secret)",
    "twitter.consumerkey": "(secret)",
    "twitter.consumersecret": "(secret)",
    "tasks.max": "1",
    "stream.type": "sample",
    "batch.size": "100",
    "language": "en",
    "value.converter.schema.registry.url": "http://k8s-node01:8081",
    "value.converter.schemas.enable": "true",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url": "http://k8s-node01:8081",
    "key.converter": "io.confluent.connect.avro.AvroConverter",
    "name": "LambdaTwitter",
    "topics": "tweets",
    "twitter.app.name": "KafkaConnectTwitterSource",
    "batch.timeout": "0.1"
  }
}'
```
### HDFS sink connector
The Twitter standard free API is used to pull tweets. This API offers two streaming modes, "filter" which requires filtering criteron or "sample" which supplies a sample of all tweets on each pull request. Using this API takes five to ten hours to pull 100 000 tweets, which is an average of 30Mb for an Avro file. This is not optimal for HDFS as the default block size is 128Mb, but this will do for this prototype as that pull rate wil not produce to many HDFS files. 
```console
$ curl -XPOST -H "Content-Type: application/json" http://k8s-node02:8083/connectors -d '{
  "name": "LambdaHDFSSink",
  "config": {
    "connector.class": "io.confluent.connect.hdfs.HdfsSinkConnector",
    "tasks.max": "3",
    "value.converter.schema.registry.url": "http://k8s-node01:8081",
    "value.converter.schemas.enable": "true",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url": "http://k8s-node01:8081",
    "key.converter": "io.confluent.connect.avro.AvroConverter",
    "name": "LambdaHDFSSink",
    "topics": "tweets",
    "flush.size": "100000",
    "format.class": "io.confluent.connect.hdfs.avro.AvroFormat",
    "schema.cache.size": 1000,
    "hdfs.url": "hdfs://k8s-node05:9000"
  }
}'
```
