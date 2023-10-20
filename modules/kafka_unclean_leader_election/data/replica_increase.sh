bash

#!/bin/bash



# Define variables

topic=${TOPIC_NAME}

partition=${PARTITION_NUMBER}

replicas=${NEW_REPLICA_COUNT}



# Increase the number of replicas for the partition

echo "Increasing the number of replicas for partition $partition to $replicas..."

kafka-topics --zookeeper ${ZOOKEEPER_CONNECT_STRING} --alter --topic $topic --partitions $partition --replication-factor $replicas



# Verify that the replica count has been increased

echo "Verifying that the replica count has been increased..."

kafka-topics --zookeeper ${ZOOKEEPER_CONNECT_STRING} --describe --topic $topic | grep -w "Partition:$partition" | grep -w "Replicas:$replicas"

if [ $? -eq 0 ]

then

    echo "Replica count for partition $partition has been increased to $replicas."

else

    echo "Failed to increase replica count for partition $partition."

fi