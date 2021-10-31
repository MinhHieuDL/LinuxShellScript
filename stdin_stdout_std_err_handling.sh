#!/bin/bash

# This script demonstrates I/O operation.

# Redirect STDOUT to a file
FILE="./log.txt"
head -n1 /etc/passwd > ${FILE}

# Redirect STDIN to a program
read LINE < ${FILE}
echo "Line contains: ${LINE}"

# Redirect STDOUT to a file, overwriting the file
head -n3 /etc/passwd > ${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}

# Redirect STDOUT to a file, append to the file
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}

# Redirect STDIN to a program, using FD 0
read LINE 0< ${FILE}
echo 
echo "Line contain: ${LINE}"

# Redirect STDOUT to a file, using FD 1
head -n3 /etc/passwd 1> ${FILE}
echo
echo "Content of ${FILE}"
cat ${FILE}

# Redirect STDERR to a file using FD 2
ERROR_FILE="./error.txt"
head -n3 /etc/passwd /fakefile  2> ${ERROR_FILE}
echo 
echo "Content of ${ERROR_FILE}"
cat ${ERROR_FILE}

# Redirect STDOUT & STDERR to a file 
head -n3 /etc/passwd /fakefile > ${FILE} 2>&1 
#another syntx to do this
#head -n3 /etc/passwd /fakefile &> ${FILE} 
echo 
echo "Content of ${FILE}"
cat ${FILE}

# Redirect STDOUT and STDERR though pipe
echo
head -n3 /etc/passwd /fakefile 2>&1 | cat -n
# another syntax to do this
#head -n3 /etc/passwd /fakefile |& cat -n

# Send output to  STDERR
echo "This is Error" 1>&2 

# Discard STDOUT
echo
echo "Discarding STDOUT"
head -n3 /etc/passwd /fakefile  > /dev/null

# Discard STDOUT
echo
echo "Discarding STDERR"
head -n3 /etc/passwd /fakefile  2> /dev/null

# Discard STDOUT & STDERR
echo
echo "Discarding STDOUT & STDERR"
head -n3 /etc/passwd /fakefile  > /dev/null 2>&1

# Clean up
rm ${FILE} ${ERROR_FILE} &> /dev/null



