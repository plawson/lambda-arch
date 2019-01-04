#!/bin/bash

#docker run --rm -p 8002:8000 \
docker run -d -p 8002:8000 \
           -e "SCHEMAREGISTRY_URL=http://192.168.1.59:8081" \
           landoop/schema-registry-ui
