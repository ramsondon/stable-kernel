#!/bin/bash

# bonnie-core.sh
#
# author: Matthias Schmid
# email: ramsondon@gmail.com
# date: 21.06.2012



# Bonnie++ Test file for block devices.

# shared config vars
unset ${DIRECTORY_UNDER_TEST}
unset ${OUTPUT_FILE}

# config specific vars
unset ${TEST_NAME}
unset ${NR_OF_TESTS}
unset ${SIZE}

# current directory
DIR=$PWD

# minimum params for script
MIN_PARAMS=1

# load shared configuration
SHARED_CONFIG="bonnie-shared.sh"

if [ ! -f ${SHARED_CONFIG} ]; then
        echo "${SHARED_CONFIG} is missing"
        exit
else
        . ${SHARED_CONFIG}
fi
if [ $# -lt $MIN_PARAMS ]; then
	echo "USAGE: $0 <config file>"
	exit
fi

CONFIG=$1

if [ ! -f ${CONFIG} ]; then
	echo "ERROR: configuration File could not be loaded"
	exit
else 
	. ${CONFIG}
	# check variables
	
fi

COMMAND="sudo bonnie++ -d ${DIRECTORY_UNDER_TEST} -u 0 -s size${SIZE} -m \"${TEST_NAME}\" -q 1>>${OUTPUT_FILE} 2>>/dev/null"

COUNTER=0
while [ $COUNTER -lt ${NR_OF_TESTS} ]; do
	echo "${i}: test ${DIRECTORY_UNDER_TEST}; ${SIZE}MB; write to ${OUTPUT_FILE}"
	eval ${COMMAND}
	let COUNTER=COUNTER+1
done


# CREATE HTML
# remove previous html file
rm ${OUTPUT_FILE}

# create html file from csv output
bon_csv2html ${OUTPUT_FILE} >> "${OUTPUT_FILE}.html"

