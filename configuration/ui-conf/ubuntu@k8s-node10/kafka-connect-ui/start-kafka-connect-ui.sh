#!/bin/bash

docker run -d -p 8003:8000 \
           -e "CONNECT_URL=http://192.168.1.60:8083,http://192.168.1.60:8084,http://192.168.1.60:8085" \
           landoop/kafka-connect-ui
