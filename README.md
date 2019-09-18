# Kafka with docker-compose

Three broker Kafka cluster and three node Zookeeper ensemble running in Docker with docker-compose.
The zookeeper containers is especially configured for LMS purposes

## Overview

Based on @eliaslevy's work on a Zookeeper cluster in Kubernetes [here](https://github.com/eliaslevy/docker-zookeeper), and @wurstmeister's Kafka docker-compose [here](https://github.com/wurstmeister/kafka-docker).
Kafka requires unique `host:port` combinations, and can try assign its own broker IDs, but the issue with it assigning its own broker IDs is that they aren't persistent across container restarts. It would probably be better to hardcode `KAFKA_BROKER_ID` for each instance for now, or you get "Leader Not Available" issues.

I made this while experimenting with setting up Kafka in Kubernetes. I have included the Kubernetes config files and instructions for setting up a multi-broker Kafka cluster and Zookeeper ensemble [here](https://github.com/zoidbergwill/docker-compose-kafka/kubernetes/).

## Usage

To start the Zookeeper ensemble and Kafka cluster, assuming you have docker-compose (>= 1.6) installed:

1. install/upgrade docker-compose
    ```
    $ docker-compose --version
    $ sudo apt-get remove docker-compose
    $ sudo rm /usr/local/bin/docker-compose 
    $ VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
    $ DESTINATION=/usr/local/bin/docker-compose
    $ sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
    $ sudo chmod 755 $DESTINATION
    $ docker-compose --version
    ```
    
2. create a zookeeper image that support ZOO_MAX_CNXNS for lms-allinone
    ```
    /kafka-server/zoo-unlimited $ docker build -t zoo-unlimited .
    ```
    
3. run start script with the specified version (ip is optional, default to current IP)
    ```
    /kafka-server/zoo-unlimited $ cd ..
    /kafka-server/ $ ./start-kafka-cluster.sh 230
    ```
    
