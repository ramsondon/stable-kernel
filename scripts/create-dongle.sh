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


# This script creates the dongle keystore
#
# REQUIREMENTS:
# - makepasswd
# - dosfstools
#
# ISSUES:
# - implement encfs extension (where to pass the key for the dongle?)

# nr of script parameters
MIN_PARAMS=1

# mount point for normal device
KEYSTORE_DIR="${PWD}/keystore_mount_point"

# name of the dongle key file
KEY_FILE=".dongle.key"

if [ $# -lt $MIN_PARAMS ]; then
        echo "USAGE: $0 <device>"
        exit
fi

KEY_DEVICE=$1

# generate password
KEY=$(makepasswd --char=100)
echo "generated key: ${KEY}"

# create key file
echo "creating key file ${KEY_FILE}"
echo ${KEY} > ${KEY_FILE}

if [ ! -d ${KEYSTORE_DIR} ]; then
	mkdir -p ${KEYSTORE_DIR}	
fi

# unmount target device if mounted
if mount | grep ${KEY_DEVICE}>/dev/null; then
	echo "umount ${KEY_DEVICE}"
	sudo umount ${KEY_DEVICE}
fi

#erase all data and deploy filesystem
echo "creating filesystem"
sudo mkfs.vfat -I ${KEY_DEVICE}

echo "mounting ${KEY_DEVICE}" 
sudo mount ${KEY_DEVICE} ${KEYSTORE_DIR}

while ! mount | grep ${KEYSTORE_DIR} > /dev/null ; do
	# wait until mounted
	BAR="foo"
done

echo "copying ${KEY_FILE} on ${KEY_DEVICE}"
sudo cp ${KEY_FILE} ${KEYSTORE_DIR}

echo "cleaning up..."
# wait certain amount of time to clean up resources
sleep 1

# umount device
sudo umount ${KEY_DEVICE}
while mount | grep ${KEYSTORE_DIR} > /dev/null ; do
	# wait until umounted 
	BAR="foo"
done
sudo rm -rf ${KEYSTORE_DIR}
rm ${KEY_FILE}

echo "dongle successfully created"
