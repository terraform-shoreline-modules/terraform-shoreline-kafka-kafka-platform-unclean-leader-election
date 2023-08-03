

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