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

# the core lib

# imports a file or aborts
function import_file_or_abort()
{
        if [ ! -f $1 ]; then
                echo "ABORT: $1 not found"
                exit
        else
                . $1
        fi
}

function print_msg()
{
	PREFIX="$1"
	MSG="$2"
	LOG_FILE="$3"
	echo "${PREFIX} ${MSG}" >> ${LOG_FILE}
}

function print_log()
{
	MSG="$1"
	LOG_FILE="$2"
	DATE=$(date)
	print_msg "LOG: ${DATE}: " "${MSG}" "${LOG_FILE}"
}

function print_err()
{
	MSG="$1"
	LOG_FILE="$2"
	DATE=$(date)
	print_msg "ERR: ${DATE}: " "${MSG}" "${LOG_FILE}"
}
