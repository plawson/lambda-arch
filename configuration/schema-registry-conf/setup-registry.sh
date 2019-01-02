#!/bin/bash

SCRIPT=$(realpath $0)
SETUP_DIR=$(dirname $SCRIPT)
UBUNTU_DIR=/home/ubuntu
INSTALL_DIR=${UBUNTU_DIR}/confluent

echo "Downloading Confluent Platform community package..."
cd ${UBUNTU_DIR}
wget http://packages.confluent.io/archive/5.1/confluent-community-5.1.0-2.11.tar.gz

echo "Extracting and installing Confluent Platform community package..."
tar xf confluent-community-5.1.0-2.11.tar.gz
rm confluent-community-5.1.0-2.11.tar.gz
ln -s confluent-5.1.0 confluent

echo "Configuring single Schema Registry instance..."
cp ${SETUP_DIR}/schema-registry-lambda.properties ${INSTALL_DIR}/etc/schema-registry

echo "Testing Schema Registry configuration..."
cd ${INSTALL_DIR}
bin/schema-registry-start -daemon etc/schema-registry/schema-registry-lambda.properties
echo "Waiting 60 seconds for registration to complete..."
sleep 60
nc -vz localhost 8081
if [[ $? -eq 1 ]]; then
	echo "ERROR: Schema Registry configuration problem!"
	exit 1
fi

echo "Stopping Schema Registry instance..."
bin/schema-registry-stop

echo "Configuring Schema Registry as a service..."
sudo cp ${SETUP_DIR}/schema-registry.service /etc/systemd/system/schema-registry.service
sudo chown root:root /etc/systemd/system/schema-registry.service
sudo systemctl enable schema-registry

echo "Starting Schema Registry service..."
sudo systemctl start schema-registry

echo "Schema Registry service status..."
sudo systemctl status schema-registry
