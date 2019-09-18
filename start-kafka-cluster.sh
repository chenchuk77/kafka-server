#!/bin/bash

# This is a wrapper for a multiversion kafka cluster.
#
#

VERSION=$1

function echo_usage {
    echo "usage:"
    echo "./start-kafka-cluster.sh {version}"
    echo ""
    echo "example:"
    echo "./start-kafka-cluster.sh 0901"
    echo "./start-kafka-cluster.sh 230"
    echo "./start-kafka-cluster.sh {version}"
    exit 99
}

if [[ -z "${VERSION}" ]]; then echo_usage; fi
if [[ ! "${VERSION}" = "0901" ]] && [[ ! "${VERSION}" = "230" ]];then echo_usage ; fi
if [[ "${VERSION}" = "0901" ]]; then FILENAME="docker-compose-2.11-0.9.0.1.yml"   ; fi
if [[ "${VERSION}" = "230" ]];  then FILENAME="docker-compose-2.12-2.3.0.yml"     ; fi

echo "preparing docker-compose with: ${FILENAME}"
cp  ${FILENAME} docker-compose.yml
sleep 3s

# run cluster of 3 zookeepers and 3 kafka servers, send all logs to file
make up | tee kafka-cluster-logs.log

# in another terminal u can filter logs to get single broker logs
kafka-logs zoo1_1
kafka-logs zoo2_1
kafka-logs zoo2_1

kafka-logs kafka1_1
kafka-logs kafka2_1
kafka-logs kafka3_1
