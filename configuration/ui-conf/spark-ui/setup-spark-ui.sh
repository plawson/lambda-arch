#!/bin/bash

SCRIPT=$(realpath $0)
SETUP_DIR=$(dirname $SCRIPT)
INSTALL_DIR=${SETUP_DIR}/spark

echo "Installing Spark UI as a service..."
sudo cp  ${SETUP_DIR}/spark-ui.service /etc/systemd/system
sudo sudo systemctl enable spark-ui

echo "Starting Spark UI..."
sudo systemctl start spark-ui
sudo systemctl status spark-ui
