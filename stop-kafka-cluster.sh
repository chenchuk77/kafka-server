#!/bin/bash

function echo_usage {
    echo "usage:"
    echo "./stop-kafka-cluster.sh"
    exit 99
}

make reset

docker ps --filter name=zoofka* -aq | \
    xargs docker stop | \
    xargs docker rm
