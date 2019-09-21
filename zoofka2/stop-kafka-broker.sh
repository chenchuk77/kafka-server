#!/bin/bash


docker ps | grep zoofka > /dev/null 2>&1 || {
    echo "zoofka is not running."
    exit 99
}

echo "stopping and removing existing zoofka containers..."
docker ps --filter name=zoofka* -aq | \
    xargs docker stop | \
    xargs docker rm
