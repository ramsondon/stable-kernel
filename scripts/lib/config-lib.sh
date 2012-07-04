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

# The shared configuration file for installing and booting the encryption proxy

unset XM_TARGET_DEVICE
unset XM_DONGLE_DEVICE
unset XM_DEVICE_MAPPER_NAME
unset XM_ENCRYPTED_DEVICE

unset XM_KEY_FILE
unset XM_KEYSTORE_MOUNT_POINT
unset XM_LIB_DIR

unset LIB_DIR
unset LIB_CORE
unset LIB_CRYPT
unset LIB_INSTALL
unset LIB_MOUNT
unset LIB_STARTUP

# libraries
LIB_DIR="${PWD}/scripts/lib"
LIB_CORE="${LIB_DIR}/lib-core.sh"
LIB_CRYPTE="${LIB_DIR}/lib-crypt.sh"
LIB_INSTALL="${LIB_DIR}/lib-install.sh"
LIB_MOUNT="${LIB_DIR}/lib-mount.sh"
LIB_STARTUP="${LIB_DIR}/lib-startup.sh"


# BeagleBoard-xM device variables
XM_STORAGE_DEVICE="/dev/sda"
XM_DONGLE_DEVICE="/dev/sdb"
XM_DEVICE_MAPPER_NAME="encryption-storage"
XM_ENCRYPTED_DEVICE="dev/mapper/${DEVICE_MAPPER_NAME}"

XM_KEY_FILE=".dongle.key"
XM_KEYSTORE_MOUNT_POINT="/mnt/keystore"
XM_LIB_DIR="/lib/eproxy"
