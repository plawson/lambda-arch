#!/bin/bash

SCRIPT=$(realpath $0)
SETUP_DIR=$(dirname $SCRIPT)
UBUNTU_DIR=/home/ubuntu
INSTALL_DIR=${UBUNTU_DIR}/hadoop

echo "Downloading Hadoop distribution..."
cd ${UBUNTU_DIR}
wget https://www-us.apache.org/dist/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz

echo "Extracting hadoop and installing package..."
tar xf hadoop-2.9.2.tar.gz
rm hadoop-2.9.2.tar.gz
ln -s hadoop-2.9.2 hadoop

echo "Configuring Hadoop datanode1/nodemanager1..."
cp ${SETUP_DIR}/core-site.xml ${INSTALL_DIR}/etc/hadoop
cp ${SETUP_DIR}/hadoop-env.sh ${INSTALL_DIR}/etc/hadoop
cp ${SETUP_DIR}/yarn-site.xml ${INSTALL_DIR}/etc/hadoop
cp ${SETUP_DIR}/hdfs-site.xml ${INSTALL_DIR}/etc/hadoop

echo "Creating datanode1 data directory..."
sudo mkdir -p /data/hdfs
sudo chown ubuntu:ubuntu /data/hdfs

