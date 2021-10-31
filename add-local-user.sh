#!/bin/bash
#
# This script creates a new user on the local system

# Check if script was executed with superuser priviledges or not
ROOT_UID='0'

if [[ "${UID}" -ne "${ROOT_UID}" ]]
then 
 echo "Not permission - have to use root access to execute script"
 exit 1
fi

# Display the introduction to user
echo "Follow the instruction step by step to add new user"

# Ask for username (login)
read -p 'Enter the username to create: ' USER_NAME

# Ask for the real name (contents for the description field)
read -p 'Enter the person who this account for: ' REAL_NAME

# Add initial password
INITIAL_PASSWORD='admin123'

# Create the user with input information
useradd -c "${REAL_NAME}" -m ${USER_NAME}

# Check if the useradd executed success or not
if [[ "${?}" -ne 0 ]]
then
 echo 'Failed to add new local user - Contact with the admin for help'
 exit 1
fi

# Set the password
echo -e "${INITIAL_PASSWORD}\n${INITIAL_PASSWORD}" | passwd ${USER_NAME}
if [[ "${?}" -ne 0 ]]
then 
 echo 'The password for the account coud not be set'
 exit 1
fi

# Force password change on first login
passwd -e ${USER_NAME}

# Display the information of new local user
echo "New account for ${REAL_NAME} was created!!"
echo "Username: ${USER_NAME}"
echo "Password: ${INITIAL_PASSWORD}"
echo "Host: ${HOSTNAME}"

# Script run success
exit 0
