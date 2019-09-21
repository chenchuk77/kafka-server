#!/bin/bash

# This is a wrapper for a multiversion kafka cluster.
#
#

VERSION=$1
SERVER_IP=$2

function echo_usage {
    echo "usage:"
    echo "./start-kafka-cluster.sh {version} [ip]"
    echo ""
    echo "example:"
    echo "./start-kafka-cluster.sh 0.9.0.0  192.168.2.77"
    echo "./start-kafka-cluster.sh 2.3.0    192.168.2.77"
    echo "./start-kafka-cluster.sh 2.3.0"
    exit 99
}

if [[ -z "${SERVER_IP}" ]]; then
    SERVER_IP=$(ifconfig| grep 192.168.2  | awk '{print $2}' | cut -d ":" -f2)
    echo "server ip not provided, assuming ${SERVER_IP}"
fi
export SERVER_IP


if [[ -z "${VERSION}" ]]; then echo_usage; fi
if [[ ! "${VERSION}" = "0.9.0.0" ]] && [[ ! "${VERSION}" = "2.3.0" ]];then echo_usage ; fi


# version 0.9.0.0 is based on single broker (zoofka)
if [[ "${VERSION}" = "0.9.0.0" ]]; then
    . /opt/kafka-server/zoofka2/start-kafka-broker.sh
    exit 0
fi


# version 2.3.0 is based on docker-compose 3-brokers cluster
if [[ "${VERSION}" = "2.3.0" ]]; then
    FILENAME="docker-compose-2.12-2.3.0.yml"
    echo "preparing docker-compose with: ${FILENAME}"
    cp  ${FILENAME} docker-compose.yml
    sleep 3s

    # run cluster of 3 zookeepers and 3 kafka servers, send all logs to file
    make up | tee kafka-cluster-logs.log
fi



## in another terminal u can filter logs to get single broker logs
#. kafka-functions.sh
#kafka-logs zoo1_1
#kafka-logs zoo2_1
#kafka-logs zoo2_1
#
#kafka-logs kafka1_1
#kafka-logs kafka2_1
#kafka-logs kafka3_1
