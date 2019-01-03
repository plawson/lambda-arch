#!/bin/bash

SCRIPT=$(realpath $0)
SETUP_DIR=$(dirname $SCRIPT)
UBUNTU_DIR=/home/ubuntu
INSTALL_DIR=${UBUNTU_DIR}/hadoop

echo "Downloading Hadoop distribution..."
co ${UBUNTU_DIR}
wget https://www-us.apache.org/dist/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz

echo "Extracting hadoop and installing package..."
tar xf hadoop-2.9.2.tar.gz
rm hadoop-2.9.2.tar.gz
ln -s hadoop-2.9.2 hadoop

echo "Configuring Hadoop master node..."
$ cp ${SETUP_DIR}/core-site.xml ${INSTALL_DIR}/etc/hadoop
$ cp ${SETUP_DIR}/slaves ${INSTALL_DIR}/etc/hadoop
$ cp ${SETUP_DIR}/hadoop-env.sh ${INSTALL_DIR}/etc/hadoop
$ cp ${SETUP_DIR}/yarn-site.xml ${INSTALL_DIR}/etc/hadoop
