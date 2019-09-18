#!/bin/bash

# function to simplify kafka commands
# source this file into your shell
# ie:
# ~ source ./kafka-functions.sh

function kafka-version {
    docker exec -ti $(docker ps |  grep kafka1_1 | awk '{print $1}') \
       /bin/bash -c "ls /opt/kafka/libs | grep kafka_ | head -n1"
}

function kafka-produce {
    if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        echo "usage: kafka-produce {topic} {count}"
        return
    fi
    docker exec -ti $(docker ps |  grep kafka1_1 | awk '{print $1}') \
       /bin/bash -c "/opt/kafka/bin/kafka-verifiable-producer.sh \
               --topic $1 --max-messages $2 --broker-list localhost:9092"
}

function kafka-list-topics {
docker exec -ti $(docker ps |  grep kafka1_1 | awk '{print $1}') \
   /bin/bash -c "/opt/kafka/bin/kafka-topics.sh --list --zookeeper \$KAFKA_ZOOKEEPER_CONNECT"
}

function kafka-list-consumer-groups {
docker exec -ti $(docker ps |  grep kafka1_1 | awk '{print $1}') \
   /bin/bash -c "/opt/kafka/bin/kafka-consumer-groups.sh --list --zookeeper \$KAFKA_ZOOKEEPER_CONNECT" || \
    { echo "command failed providing --zookeeper arg, trying --bootstrap-server..."
        docker exec -ti $(docker ps |  grep kafka1_1 | awk '{print $1}') \
           /bin/bash -c "/opt/kafka/bin/kafka-consumer-groups.sh --list --bootstrap-server localhost:9092"
    }
}

function kafka-describe-consumer-groups {
    # if cgroup supplied
    cgroup=$1
    docker exec -ti $(docker ps |  grep kafka1_1 | awk '{print $1}') \
       /bin/bash -c "/opt/kafka/bin/kafka-consumer-groups.sh --describe --group ${cgroup} --bootstrap-server localhost:9092"
}


function kafka-describe-mult-consumer-groups {
    # if cgroup supplied
    if [[ ! -z "$1" ]]; then
        cgroup=$1
        docker exec -ti $(docker ps |  grep kafka1_1 | awk '{print $1}') \
           /bin/bash -c "/opt/kafka/bin/kafka-consumer-groups.sh --describe --group ${cgroup} --zookeeper \$KAFKA_ZOOKEEPER_CONNECT" || \
    { echo "command failed providing --zookeeper arg, trying --bootstrap-server..."
        docker exec -ti $(docker ps |  grep kafka1_1 | awk '{print $1}') \
           /bin/bash -c "/opt/kafka/bin/kafka-consumer-groups.sh --describe --group ${cgroup} --bootstrap-server localhost:9092"
    }

   # if none provided, loop all TODO: fix error when invoke with no params
    else
        for cgroup in $(kafka-list-consumer-groups); do
        echo $cgroup
        docker exec -ti $(docker ps |  grep kafka1_1 | awk '{print $1}') \
               /bin/bash -c "/opt/kafka/bin/kafka-consumer-groups.sh --describe --group ${cgroup} --zookeeper \$KAFKA_ZOOKEEPER_CONNECT"
        sleep 3s
        done
    fi
}
function kafka-describe-topic {
    if [[ -z "$1" ]] ; then
        echo "usage: kafka-describe-topic {name}"
        return
    fi
    docker exec -ti $(docker ps |  grep kafka1_1 | awk '{print $1}') \
       /bin/bash -c "
           /opt/kafka/bin/kafka-topics.sh --describe --zookeeper \$KAFKA_ZOOKEEPER_CONNECT \
               --topic $1"
}

function kafka-remove-topic {
    if [[ -z "$1" ]] ; then
        echo "usage: kafka-remove-topic {name}"
        return
    fi
    docker exec -ti $(docker ps |  grep kafka1_1 | awk '{print $1}') \
       /bin/bash -c "
           /opt/kafka/bin/kafka-topics.sh --delete --zookeeper \$KAFKA_ZOOKEEPER_CONNECT \
               --topic $1"
}



function kafka-create-topic {
    if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] ; then
        echo "usage: kafka-create-topic {name} {replication factor} {partitions}"
        return
    fi
    docker exec -ti $(docker ps |  grep kafka1_1 | awk '{print $1}') \
       /bin/bash -c "
           /opt/kafka/bin/kafka-topics.sh --create --zookeeper \$KAFKA_ZOOKEEPER_CONNECT \
               --topic $1 --replication-factor $2 --partitions $3"
}

function kafka-set-partitions {
    if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        echo "usage: kafka-set-partitions {name} {partitions}"
        return
    fi
    docker exec -ti $(docker ps |  grep kafka1_1 | awk '{print $1}') \
       /bin/bash -c "
           /opt/kafka/bin/kafka-topics.sh --alter --zookeeper \$KAFKA_ZOOKEEPER_CONNECT \
               --topic $1 --partitions $2"
}

function kafka-logs  {
    if [[ -z "$1" ]]; then
        echo "usage: kafka-logs {component}"
        echo "ie: kafka-logs zoo1_1"
        return
    fi
    tail -f kafka-cluster-logs.log | grep -i $1

}

