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

# lib-crypt.sh

CRYPT_TABLE="/etc/crypttab"

# creates a persistent device mapper
function create_device_mapper()
{
	MAPPING_NAME=$1	# encryption-storage
	DEVICE=$2	# /dev/sda
	KEY_FILE=$3	# /mnt/keystore/.dongle.key

	TABLE_ENTRY="${MAPPING_NAME} ${DEVICE}    ${KEY_FILE}"
	sudo rm ${CRYPT_TABLE}
	sudo echo ${TABLE_ENTRY} > ${CRYPT_TABLE}
}

# create_temporary_device_mapper
#
# @param $1 target device
# @param $2 mapping name
# @param $3 key file
function create_temporary_device_mapper()
{
        DEVICE=$1               # /dev/sda
        DEV_MAPPER_NAME=$2      # encryption-storage
        KEYFILE=$3              # /mnt/keystore/.dongle.key

        cryptsetup luksOpen ${DEVICE} ${DEV_MAPPER_NAME} --key-file=${KEYFILE}
}

# is_luks_device
#
# @param $1 device
function is_luks_device()
{
	DEVICE=$1
	if cryptsetup luksUUID ${DEVICE} ; then
		return 0
	fi
	return 1
}

