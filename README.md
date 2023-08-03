
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kafka Unclean leader election
---

The incident type is related to an unclean leader election that has occurred in a Kafka Platform cluster. This is an indication of potential data loss and needs to be addressed urgently. It is important to disable unclean leader election in Broker settings if it was not intentional. The incident requires prompt attention to mitigate any potential data loss.

### Parameters
```shell
# Environment Variables

export KAFKA_LOGS="PLACEHOLDER"

export BROKER_SETTINGS="PLACEHOLDER"

export KAFKA_HOST="PLACEHOLDER"

export KAFKA_PORT="PLACEHOLDER"

export TOPIC_NAME="PLACEHOLDER"

export ZOOKEEPER_HOST="PLACEHOLDER"

```

## Debug

### Check for any errors in Kafka logs related to unclean leader election
```shell
grep -i "unclean leader election" ${KAFKA_LOGS}
```

### Check if the unclean leader election was intentional or not
```shell
cat ${BROKER_SETTINGS} | grep "unclean.leader.election.enable"
```

### Check the status of the Kafka brokers in the cluster
```shell
systemctl status kafka
```

### Check if the ZooKeeper ensemble is up and running
```shell
systemctl status zookeeper
```

### Verify if the Kafka cluster is reachable from the client application
```shell
telnet ${KAFKA_HOST} ${KAFKA_PORT}
```

### Check the Kafka topic partition status
```shell
kafka-topics --describe --topic ${TOPIC_NAME} --zookeeper ${ZOOKEEPER_HOST}
```

### Check the Kafka cluster health
```shell
kafka-run-class kafka.tools.JmxTool --jmx-url service:jmx:jmxmp://${KAFKA_HOST}:9999 --object-name kafka.controller:type=KafkaController --attributes OfflinePartitionsCount,ActiveControllerCount,OfflineReplicaCount
```

### An issue with the network connection between the Kafka broker and the ZooKeeper ensemble.
```shell
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

```

## Repair

### Disable unclean leader election in the Broker settings to prevent future occurrences.
```shell


#!/bin/bash

# Define the Broker settings file path

BROKER_SETTINGS="PLACEHOLDER"

# Find the line containing 'unclean.leader.election.enable' parameter

line_number=$(grep -n 'unclean.leader.election.enable' $BROKER_SETTINGS | cut -d':' -f1)

# Comment out the line if it exists

if [[ ! -z $line_number ]]; then

    sed -i "${line_number}s/^/# /" $BROKER_SETTINGS

    echo "Unclean leader election has been disabled in the Broker settings."

else

    echo "Unclean leader election is already disabled in the Broker settings."

fi

```

### Review the Kafka configuration and adjust it if necessary to prevent similar incidents from occurring in the future.
```shell

#!/bin/bash

# Set the Kafka configuration file path

KAFKA_CONFIG_PATH="PLACEHOLDER"

# Check if the Kafka configuration file exists

if [ ! -f "$KAFKA_CONFIG_PATH" ]; then

  echo "Kafka configuration file not found!"

  exit 1

fi

# Review the Kafka configuration file and adjust it if necessary

# For example, you can search for the following configuration settings and adjust them accordingly:

# - unclean.leader.election.enable=false

# - replica.fetch.max.bytes=1048576

# - replica.fetch.wait.max.ms=500

# - replica.high.watermark.checkpoint.interval.ms=5000

# - log.cleaner.enable=false

# - log.retention.hours=168

# - log.retention.bytes=1073741824

# Restart the Kafka service to apply the configuration changes

systemctl restart kafka

```