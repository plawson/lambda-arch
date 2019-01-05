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

echo "Configuring Connect Cluster instances..."
mkdir ${UBUNTU_DIR}/community-plugins
cp -r ${SETUP_DIR}/kafka-connect-twitter ${UBUNTU_DIR}/community-plugins
cp ${SETUP_DIR}/connect-distributed-lambda-1.properties ${INSTALL_DIR}/etc/kafka
cp ${SETUP_DIR}/connect-distributed-lambda-2.properties ${INSTALL_DIR}/etc/kafka
cp ${SETUP_DIR}/connect-distributed-lambda-3.properties ${INSTALL_DIR}/etc/kafka
cp ${SETUP_DIR}/start-connect-cluster.sh ${UBUNTU_DIR}

echo "Starting Connect Cluster, waiting 60 seconds for initial startup..."
cd ${UBUNTU_DIR}/
./start-connect-cluster.sh
sleep 60
nc -vz localhost 8083
nc -vz localhost 8084
nc -vz localhost 8085
