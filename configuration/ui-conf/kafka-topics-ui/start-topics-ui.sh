#!/bin/bash
#docker run --rm -it -p 8001:8000 \
docker run -d -p 8001:8000 \
               -e "KAFKA_REST_PROXY_URL=http://192.168.1.59:8085" \
               -e "PROXY=true" \
               landoop/kafka-topics-ui
