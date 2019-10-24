# Kafka-Server
## Multi-version Multi-broker Kafka cluster (dev)
Three broker Kafka cluster and three node Zookeeper ensemble running in Docker with docker-compose.
The zookeeper containers is especially configured for LMS purposes

## Overview
This project supports 2 optional cluster configuration:
1. Kafka 2.3.0
Based on @eliaslevy's work on a Zookeeper cluster in Kubernetes [here](https://github.com/eliaslevy/docker-zookeeper), and @wurstmeister's Kafka docker-compose [here](https://github.com/wurstmeister/kafka-docker).
Kafka requires unique `host:port` combinations, and can try assign its own broker IDs, but the issue with it assigning its own broker IDs is that they aren't persistent across container restarts. It would probably be better to hardcode `KAFKA_BROKER_ID` for each instance for now, or you get "Leader Not Available" issues.

2. Kafka 0.9.0.1
To support this old image i had to create a new image called zoofka. the image is built from zookeeper and kafka on the same image.

## Prerequsites
1. install docker
    ```
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    $ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    $ sudo apt-get update
    $ sudo apt-get install -y docker-ce
    $ sudo systemctl status docker
    $ sudo usermod -aG docker ${USER}
    ```
    
2. install/upgrade docker-compose
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
    
3. create a zookeeper image that support ZOO_MAX_CNXNS for lms-allinone
    ```
    cd zoo-unlimited
    /kafka-server/zoo-unlimited$ docker build -t zoo-unlimited .
    ```
## Running the kafka-server cluster
run start script with the specified version (ip is optional, default to current IP)
```
/kafka-server/zoo-unlimited $ cd ..
/kafka-server/ $ ./start-kafka-cluster.sh 2.3.0
```
    
## TODO:
1. check Zoofka installation


