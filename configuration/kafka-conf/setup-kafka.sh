#!/bin/bash

SCRIPT=$(realpath $0)
SETUP_DIR=$(dirname $SCRIPT)
UBUNTU_DIR=/home/ubuntu
INSTALL_DIR=${UBUNTU_DIR}/kafka

echo "Downloading Kafka package..."
cd ${UBUNTU_DIR}
wget https://www-eu.apache.org/dist/kafka/2.1.0/kafka_2.11-2.1.0.tgz

echo "Extracting and installing Kafka package..."
tar xf kafka_2.11-2.1.0.tgz
rm kafka_2.11-2.1.0.tgz
ln -s kafka_2.11-2.1.0 kafka

echo "Configuring single Kafka instance..."
cp ${SETUP_DIR}/server-lambda.properties ${INSTALL_DIR}/config
sudo mkdir -p /data/kafka/logs
sudo chown ubuntu:ubuntu /data/kafka/logs

echo "Testing Kafka configuration..."
cd ${INSTALL_DIR}
bin/kafka-server-start.sh -daemon config/server-lambda.properties
echo "Waiting 60 seconds for registration to complete..."
sleep 60
nc -vz localhost 9092
if [[ $? -eq 1 ]]; then
	echo "ERROR: Kafka configuration problem!"
	exit 1
fi
echo "Stopping Kafka instance..."
bin/kafka-server-stop.sh

echo "Configuring Kafka as a service..."
sudo cp ${SETUP_DIR}/kafka.service /etc/systemd/system/kafka.service
sudo chown root:root /etc/systemd/system/kafka.service
sudo systemctl enable kafka

echo "Starting Kafka..."
sudo systemctl start kafka

echo "Kafka status..."
sudo systemctl status kafka
