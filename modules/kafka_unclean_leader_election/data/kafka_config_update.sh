

#!/bin/bash



# Set the path to the Kafka configuration file

KAFKA_CONFIG=${KAFKA_CONFIGURATION_FILE}



# Set the value that `unclean.leader.election.enable` should be set to

NEW_VALUE=false



# Loop through each broker and update its configuration file

for BROKER in ${LIST_OF_BROKER_IPS}

do

    ssh $BROKER "sed -i 's/unclean.leader.election.enable=.*/unclean.leader.election.enable=$NEW_VALUE/' $KAFKA_CONFIG"

    ssh $BROKER "systemctl restart kafka"

done