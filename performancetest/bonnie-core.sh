#!/bin/bash
#
# Copyright (c) 2012-2015 Matthias Schmid <ramsondon@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

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

