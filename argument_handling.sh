#!/bin/bash

# This script describe how to handle the arguments(which was give for script by user) of the script  

# Display what user typed on the command line

echo "You ececuted this command: ${0}" 

# Display the path and filename of the script
echo "You used $(dirname ${0}) as the path to the $(basename ${0}) script"

# Tell them how many arguments they passed in
# (Inside the script they are parameters, outside they are arguments.)
NUM_OF_PAR="${#}"
echo "You supplied ${NUM_OF_PAR} argument(s) on the command line"

# Generate and display a password for each parameter.
for USER_NAME in "${@}"
do 
    PASSWORD=$(date +%s%N | sha256sum | head -c48)
    echo "${USER_NAME}:${PASSWORD}"
done