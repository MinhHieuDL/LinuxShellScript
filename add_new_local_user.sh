#!/bin/bash
#
# This script created new user account on local system with some update
# with previous version

# Enforces that it be executed with superuser(root)
ROOT_UID='0'
if [[ "${UID}" -ne "${ROOT_UID}" ]]
then
    echo 'Please run with sudo or as root'
    exit 1
fi

# Check if user supply username or not
if [[ "${#}" -lt 1 ]]
then 
    echo "Usage: ${0} USER_NAME [COMMENT] ..."
    echo "Create an account on the local system with the name of USER_NAME and a comments field of COMMENT"
    exit 1
fi

# Uses the first argument provided on the command line as the username
USER_NAME="${1}"

# Uses the remaining arguments on the command line as the comment for the account
shift
COMMENT="${@}"

# Automatically generate the password
PASSWORD="$(date +%s)"

# create account
if [[ -z "${COMMENT}" ]]
then
    echo "add user without -c option"
    useradd -m "${USER_NAME}"
else
    echo "add user with -c option"
    useradd -c "${COMMENT}" -m "${USER_NAME}"
fi

# check if the user_add command success or not
if [[ "${?}" -ne 0 ]]
then
    echo "Failed to create new account for ${USER_NAME}"
    exit 1
fi

# create password for new account
echo -e "${PASSWORD}\n${PASSWORD}" | passwd ${USER_NAME}
if [[ "${?}" -ne 0 ]]
then 
 echo 'The password for the account coud not be set'
 exit 1
fi

# Force password change on first login
passwd -e ${USER_NAME}

# Diplay information
echo 'New account was created!'
echo "Username: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo "Host: ${HOSTNAME}"

# Script run success
exit 0