#!/bin/bash

SCRIPT=$(realpath $0)
SETUP_DIR=$(dirname $SCRIPT)
INSTALL_DIR=${SETUP_DIR}/spark

echo "Downloading Spark distribution..."
cd ${SETUP_DIR}
wget https://www-us.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz

echo "Extracting spark and installing package..."
tar xf spark-2.4.0-bin-hadoop2.7.tgz
rm spark-2.4.0-bin-hadoop2.7.tgz-2.9.2.tar.gz
ln -s spark-2.4.0-bin-hadoop2.7 spark

echo "Configuring Spark..."
cp ${SETUP_DIR}/spark-defaults.conf ${INSTALL_DIR}/conf
cp ${SETUP_DIR}/spark-env.sh ${INSTALL_DIR}/conf

