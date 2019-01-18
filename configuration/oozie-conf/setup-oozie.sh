#!/bin/bash -e

SCRIPT=$(realpath $0)
SETUP_DIR=$(dirname $SCRIPT)
UBUNTU_DIR=/home/ubuntu
INSTALL_DIR=${UBUNTU_DIR}/confluent


echo "Downloading Oozie distribution..."
cd ${UBUNTU_DIR}
wget https://www-eu.apache.org/dist/oozie/5.1.0/oozie-5.1.0.tar.gz
tar xf oozie-5.1.0.tar.gz
rm oozie-5.1.0.tar.gz
ln -s oozie-5.1.0 oozie
sudo apt install -y maven
