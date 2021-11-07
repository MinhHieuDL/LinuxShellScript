#!/bin/bash

# function log {
log() {
    # This function sends a message to syslog and to stdout if VERBOSE is true
    
    # local VERBOSE="${1}"
    # shift
    local MESSAGE="${@}"
    # if [[ "${VERBOSE}" = 'true' ]]
    # then
        echo "${MESSAGE}"
    # fi
    logger -t "$(basename ${0})" "${MESSAGE}"
}

backup_file() {
    # This function creates a backup of a file. Returns non-zero status on error.
    local FILE="${1}"

    # Make sure the file exists
    if [[ -f "${FILE}" ]]
    then
        local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
        log "Backing up ${FILE} to ${BACKUP_FILE}"

        # The exit status of the function will be the exit status of the cp command
        cp -p ${FILE} ${BACKUP_FILE}
    else
        # The file does not exists, so return a non-zero exit status
        return 1
    fi
}

backup_file '/etc/passwd'

# Make a decision based on the exit status of the function
if [[ "${?}" -eq '0' ]]
then 
    log 'File backup succeeded!'
else
    log 'File backup failed!'
    exit 1
fi