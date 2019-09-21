#!/bin/bash


docker build -t chenchuk/zoofka:1.0 .

docker ps | grep 2181 && {
  echo "container already running."
  exit 99
}


# run container daemon
# export SERVER_IP=192.168.2.78   ### TEST
if [[ -z "${SERVER_IP}" ]]; then
    echo "missing SERVER_IP."
    exit 99
fi
docker run -d -p 2181:2181 \
              -p 9092:9092 \
              --env ADVERTISED_HOST=${SERVER_IP} \
              --env ADVERTISED_PORT=9092 \
              --name zoofka-$(date +%s) chenchuk/zoofka:1.0
