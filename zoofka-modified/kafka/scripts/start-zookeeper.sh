#!/bin/sh

# config zookeeper
echo "tickTime=2000"                > /etc/zookeeper/conf/zoo.cfg
echo "initLimit=10"                 >> /etc/zookeeper/conf/zoo.cfg
echo "syncLimit=5"                  >> /etc/zookeeper/conf/zoo.cfg
echo "dataDir=/var/lib/zookeeper"   >> /etc/zookeeper/conf/zoo.cfg
echo "clientPort=2181"              >> /etc/zookeeper/conf/zoo.cfg
echo "server.1=zoofka-1:2888:3888"  >> /etc/zookeeper/conf/zoo.cfg
echo "server.2=zoofka-2:2888:3888"  >> /etc/zookeeper/conf/zoo.cfg
echo "server.3=zoofka-3:2888:3888"  >> /etc/zookeeper/conf/zoo.cfg


echo "$ZOO_MY_ID" > /var/lib/zookeeper/myid
# start zookeeper
/usr/share/zookeeper/bin/zkServer.sh start-foreground
