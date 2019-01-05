#!/bin/bash

docker run -d -p 8003:8000 \
           -e "CONNECT_URL=http://192.168.1.60:8083;connect-cluster-lambda" \
           landoop/kafka-connect-ui
