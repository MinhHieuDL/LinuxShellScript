#!/bin/bash

# Run as root
if [[ "${UID}" -ne 0 ]]
then 
    echo 'Please run with sudo or as root' >&2
    exit 1
fi

# Assum the first argument is the user to delete
USER="${1}"

# Delete the user
userdel ${USER}

# Make sure the user got deleted
if [[ "${?}" -ne 0 ]]
then 
    echo "The account ${USER} was not deleted" >&2
    exit 1
fi 

# Diplay the information
echo "The account ${USER} was deleted"
exit 0