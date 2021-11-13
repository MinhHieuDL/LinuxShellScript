#!/bin/bash

# This script was used to execute a specific command in every system 

# A list of servers, one per line
SERVER_FILE='./servers'

# Display the usage
usage(){
    echo "Usage: ${0} [-f SERVER_LIST_FILE] [-nsv] [COMMAND]" >&2
    echo 'Execute COMMAND on every system included in SERVER_LIST_FILE' >&2
    echo " -f SERVER_LIST_FILE Specify the file containt server list. Default ${SERVER_FILE}" >&2
    echo ' -n                  Dry run mode. Display the COMMAND that would have been executed and execute it' >&2
    echo ' -s                  Execute the COMMAND using sudo on the remote server' >&2
    echo ' -v                  Verbose mode. Displays the server name before executing COMMAND' >&2
    exit 1 
}

# Option for ssh command
SSH_OPTIONS='-o ConnectTimeout=2'

# Make sure the script is not begin executed with super user priviledges
if [[ "${UID}" -eq 0 ]]
then 
    echo 'Do not execute this script as root. Use -s option instead' >&2
    usage
fi

# Handle argument
while getopts f:nsv OPTION
do  
    case ${OPTION} in
        f) SERVER_FILE="${OPTARG}";;
        n) DRY_RUN='true';;
        s) SUDO='sudo';;
        v) VERBOSE='true';;
        ?) usage;;
    esac
done

# Remove the options while leaving the remaining arguments
shift "$(( OPTIND - 1 ))"

# if the USER doesn't supply at least one argument, give them help
if [[ "${#}" -lt 1 ]]
then
    usage
fi

# Anything that remains on the command line is to be treated as a single command
COMMAND="${@}"

# Make sure the SERVER_FILE exists
if [[ ! -e "${SERVER_FILE}" ]]
then
    echo "Cannot open server list file ${SERVER_FILE}"
    exit 1
fi


# Expect the best, prepare for the worst
EXIT_STATUS='0'


# Loop through the SERVER_LIST
for SERVER in $(cat ${SERVER_FILE})
do 
    if [[ "${VERBOSE}" = 'true' ]]
    then
        echo "${SERVER}"
    fi

    SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}"

    # If it's a dry run, don't execute anything, just echo it
    if [[ "${DRY_RUN}" = 'true' ]]
    then
        echo "DRY_RUN: ${SSH_COMMAND}"
    else
        ${SSH_COMMAND}
        SSH_EXIT_STATUS="${?}"

        # Capture any non zero exit status from the SSH_COMMAND and report to the user
        if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]
        then
            EXIT_STATUS="${SSH_EXIT_STATUS}"
            echo "Execute command: ${COMMAND} on ${SERVER} failed" >&2
        fi
    fi
done

exit ${EXIT_STATUS}









