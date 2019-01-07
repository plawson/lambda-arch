#!/bin/bash

SCRIPT=$(realpath $0)
SETUP_DIR=$(dirname $SCRIPT)
UBUNTU_DIR=/home/ubuntu
INSTALL_DIR=/etc/cassandra

echo "Stopping default Cassandra installation..."
sudo systemctl stop cassandra
sudo systemctl status cassandra

echo "Create Cassandra's storage directories..."
sudo mkdir -p /data/cassandra/hints
sudo mkdir -p /data/cassandra/data
sudo mkdir -p /data/cassandra/commitlog
sudo mkdir -p /data/cassandra/saved_caches

echo "Installing Cassandra's config file..."
sudo mv ${INSTALL_DIR}/cassandra.yaml ${INSTALL_DIR}/cassandra.yaml.orig
sudo cp ${SETUP_DIR}/cassandra.yaml ${INSTALL_DIR}/cassandra.yaml

echo "Starting Cassandra service..."
sudo systemctl start cassandra
sudo systemctl status cassandra
