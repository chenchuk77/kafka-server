# Kafka and Zookeeper

FROM xqdocker/ubuntu-openjdk:jre-8
MAINTAINER chenchuk@gmail.com +972544434545

ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION 2.11
#ENV KAFKA_VERSION 0.10.1.0 # working
ENV KAFKA_VERSION 0.9.0.0
ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"

# Install Kafka, Zookeeper and other needed things
RUN apt-get update && \
    apt-get install -y zookeeper wget supervisor dnsutils && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    wget -q https://archive.apache.org/dist/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt && \
    rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz

RUN echo "maxClientCnxns=10000" >> /etc/zookeeper/conf/zoo.cfg

ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh

# Supervisor config
ADD supervisor/kafka.conf supervisor/zookeeper.conf /etc/supervisor/conf.d/

# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092

CMD ["supervisord", "-n"]
#CMD ["/bin/sleep", "3d"]


