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

echo "Configuring Hadoop master node..."
cp ${SETUP_DIR}/core-site.xml ${INSTALL_DIR}/etc/hadoop
cp ${SETUP_DIR}/slaves ${INSTALL_DIR}/etc/hadoop
cp ${SETUP_DIR}/hadoop-env.sh ${INSTALL_DIR}/etc/hadoop
cp ${SETUP_DIR}/yarn-site.xml ${INSTALL_DIR}/etc/hadoop
cp ${SETUP_DIR}/hdfs-site.xml ${INSTALL_DIR}/etc/hadoop

echo "Creating Namenode data directory..."
sudo mkdir -p /data/hdfs
sudo chown ubuntu:ubuntu /data/hdfs

echo "Formating namenode's data directory..."
cd ${INSTALL_DIR}
bin/hdfs namenode -format
ls /data/hdfs/current
if [[ $? -ne 0 ]];then
	echo "ERROR: Namenode format problem!"
	exit 1
fi


echo "Installing HDFS as a service..."
sudo cp ${SETUP_DIR}/hdfs.service /etc/systemd/system
sudo systemctl enable hdfs

echo "Starting HDFS service..."
sudo systemctl start hdfs
sleep 10
${INSTALL_DIR}/bin/hdfs dfsadmin -report

echo "Installing YARN as service..."
sudo cp ${SETUP_DIR}/yarn.service /etc/systemd/system
sudo systemctl enable yarn

echo "Starting YARN service..."
sudo systemctl start yarn
sleep 10
${INSTALL_DIR}/bin/yarn node -list -all

echo "Creating hdfs directories..."
cd ${INSTALL_DIR}
bin/hdfs dfs -mkdir /user
bin/hdfs dfs -chmod 777 /user
bin/hdfs dfs -mkdir /spark-logs
bin/hdfs dfs -chmod 777 /spark-logs
bin/hdfs dfs -mkdir -p /spark/checkpoint
bin/hdfs dfs -chmod 777 /spark/checkpoint
