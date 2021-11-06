#!/bin/bash

# Run as root
if [[ "${UID}" -ne 0 ]]
then 
    echo 'Please run with sudo or as root' >&2
    exit 1
fi

# Display the man for script
usage() {
    echo "Usage: ${0} [-u USERNAME] [-dra]" >&2
    echo 'Disable a local user'
    echo ' -u USERNAME Specify the user that need to disable'
    echo ' -d          Delete account instead of disabling them'
    echo ' -r          Remove the home directory associated with the account(s)'
    echo ' -a          Creates an archive of the home directory to backup'
    exit 1 
}

# Check command success or not
check_success() {
    local MESSAGE="${@}"
    if [[ "${?}" -ne 0 ]]
    then
        echo "Failed to execute ${MESSAGE} command"
        exit 1
    fi
}

# Handle argument
if [[ "${#}" -lt 1 ]]
then 
    usage
fi

__USER=999
while getopts u:dra OPTION 
do
    case ${OPTION} in
        u) __USER="${OPTARG}";;
        d) DELETED='true';;
        r) REMOVE_HOME_DIR='true';;
        a) BACKUP='true';;
        ?) usage;;
    esac
done

# Check if the command valid or not
shift "$(( OPTIND - 1 ))"
if [[ "${#}" -gt 0 ]]
then
    usage
fi

# Do main job of the script
#
# Check of the User id is valid or not
if [[ "$(id -u ${__USER})" -lt 1000 ]]
then 
    echo "Cannot disable user id: ${__USER}" >&2
    exit 1
fi

__LOG="${__USER}: "
# Backup the home directory if requested
BACKUP_DIR='./backup_home_dir/'
if [[ "${BACKUP}" = 'true' ]]
then
    if [[ ! -d ${BACKUP_DIR} ]]
    then
        mkdir ${BACKUP_DIR}
        check_success 'mkdir'
    fi
    HOME_USER_DIR="/home/${__USER}"
    if [[ -d ${HOME_USER_DIR} ]]
    then 
        tar -zcf ${BACKUP_DIR}${__USER}.tgz ${HOME_USER_DIR}
        __LOG="${__LOG}- created backup home directory"
        check_success 'tar'
    fi
fi

# Remove or disable the local user 
if [[ "${DELETED}" = 'true' ]]
then 
    if [[ "${REMOVE_HOME_DIR}" = 'true' ]]
    then 
        userdel -r ${__USER}
        __LOG="${__LOG} - deleted - removed home directory"
    else
        userdel ${__USER}
        __LOG="${__LOG} deleted"
    fi
    check_success 'userdel'
else 
    chage -E 0 ${__USER}
    __LOG="${__LOG} disabled"
    check_success 'chage'
fi

# Display all action and exit
echo "${__LOG}"
exit 0






