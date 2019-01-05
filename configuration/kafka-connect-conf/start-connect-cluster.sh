#!/bin/bash

/home/ubuntu/confluent/bin/connect-distributed -daemon /home/ubuntu/confluent/etc/kafka/connect-distributed-lambda-1.properties
/home/ubuntu/confluent/bin/connect-distributed -daemon /home/ubuntu/confluent/etc/kafka/connect-distributed-lambda-2.properties
/home/ubuntu/confluent/bin/connect-distributed -daemon /home/ubuntu/confluent/etc/kafka/connect-distributed-lambda-3.properties
