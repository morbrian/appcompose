#!/bin/bash

BASE=dev/proxy
CONTAINER=app-proxy

docker run -d --name ${CONTAINER} -p 443:18443 -p 80:18080 -i -t ${BASE}


