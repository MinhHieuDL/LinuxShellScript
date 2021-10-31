#!/bin/bash

# A random number as a password
PASSWORD="${RANDOM}"
echo "${PASSWORD}"

# Three ramdom numbers together
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"

# Use the current date/time as the basic for the password
PASSWORD=$(date +%s)
echo "${PASSWORD}"

# A better password
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "${PASSWORD}"

# Append a special character to password
SPECIAL_CHAR=$(echo '!@#$%^&*()_+=' | fold -w1 | shuf | head -c1)
echo "${PASSWORD}${SPECIAL_CHAR}"
