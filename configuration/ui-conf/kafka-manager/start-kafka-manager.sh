#!/bin/bash

docker run -d -p 9000:9000 \
              -e "ZK_HOSTS=192.168.1.61:2181" \
              hlebalbau/kafka-manager:stable \
              -Dpidfile.path=/dev/null
