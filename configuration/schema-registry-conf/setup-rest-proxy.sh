#!/bin/bash

SCRIPT=$(realpath $0)
SETUP_DIR=$(dirname $SCRIPT)
UBUNTU_DIR=/home/ubuntu
INSTALL_DIR=${UBUNTU_DIR}/confluent

echo "Configuring REST Proxy instance..."
cp ${SETUP_DIR}/kafka-rest-lambda.properties ${INSTALL_DIR}/etc/kafka-rest

echo "Testing REST Proxy configuration..."
cd ${INSTALL_DIR}
bin/kafka-rest-start -daemon etc/kafka-rest/kafka-rest-lambda.properties
echo "Waiting 30 seconds for registration to complete..."
sleep 30
nc -vz localhost 8085
if [[ $? -eq 1 ]]; then
	echo "ERROR: Schema Registry configuration problem!"
	exit 1
fi

echo "Stopping REST Proxy instance..."
bin/kafka-rest-stop

echo "Configuring REST Proxy as a service..."
sudo cp ${SETUP_DIR}/kafka-rest.service /etc/systemd/system/kafka-rest.service
sudo chown root:root /etc/systemd/system/kafka-rest.service
sudo systemctl enable kafka-rest

echo "Starting REST Proxy service..."
sudo systemctl start kafka-rest

echo "REST Proxy service status..."
sudo systemctl status kafka-rest
