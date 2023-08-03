#!/bin/bash

# Set variables

KAFKA_BROKER="PLACEHOLDER"

ZOOKEEPER_ENSEMBLE="PLACEHOLDER"

# Check network connection

ping -c 3 $KAFKA_BROKER > /dev/null 2>&1

if [ $? -eq 0 ]; then

  echo "Kafka broker is reachable."

else

  echo "Kafka broker is unreachable. There may be an issue with the network connection."

fi

ping -c 3 $ZOOKEEPER_ENSEMBLE > /dev/null 2>&1

if [ $? -eq 0 ]; then

  echo "ZooKeeper ensemble is reachable."

else

  echo "ZooKeeper ensemble is unreachable. There may be an issue with the network connection."

fi