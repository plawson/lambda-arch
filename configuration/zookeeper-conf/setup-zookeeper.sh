#!/bin/bash

SCRIPT=$(realpath $0)
SETUP_DIR=$(dirname $SCRIPT)
UBUNTU_DIR=/home/ubuntu
INSTALL_DIR=${UBUNTU_DIR}/kafka

echo "Downloading Zookeper package..."
cd ${UBUNTU_DIR}
wget https://www-eu.apache.org/dist/kafka/2.1.0/kafka_2.11-2.1.0.tgz

echo "Extracting and installing Zookeeper package..."
tar xf kafka_2.11-2.1.0.tgz
rm kafka_2.11-2.1.0.tgz
ln -s kafka_2.11-2.1.0 kafka

echo "Configuring single Zookeeper instance..."
cp ${SETUP_DIR}/zookeeper-lambda.properties ${INSTALL_DIR}/config
sudo mkdir -p /var/zookeeper/log
sudo chown ubuntu:ubuntu /var/zookeeper/log
sudo mkdir -p /data/zookeeper
sudo chown ubuntu:ubuntu /data/zookeeper

echo "Testing Zookeeper configuration..."
cd ${INSTALL_DIR}
bin/zookeeper-server-start.sh -daemon config/zookeeper-lambda.properties
sleep 5
nc -vz localhost 2181
if [[ $? -eq 1 ]]; then
	echo "ERROR: Zookeeper configuration problem!"
	exit 1
fi
echo "Stopping Zookeeper instance..."
bin/zookeeper-server-stop.sh

echo "Configuring Zookeeper as a service..."
sudo cp ${SETUP_DIR}/zookeeper.service /etc/systemd/system/zookeeper.service
sudo chown root:root /etc/systemd/system/zookeeper.service
sudo systemctl enable zookeeper

echo "Starting Zookeeper..."
sudo systemctl start zookeeper

echo "Zookeeper status..."
sudo systemctl status zookeeper
