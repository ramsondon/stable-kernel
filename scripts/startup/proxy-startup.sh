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

# This is the startup script for the encryption proxy.

# encryption proxy library path
unset LIB_DIR
unset LIB_CONFIG
unset LIB_CORE
unset LIB_CRYPT
unset LIB_MOUNT
unset LIB_STARTUP

unset LOG_FILE

LIB_DIR="/eproxy/lib"
LIB_CONFIG="${LIB_DIR}/config-lib.sh"
LIB_CORE="${LIB_DIR}/lib-core.sh"
LIB_CRYPT="${LIB_DIR}/lib-crypt.sh"
LIB_MOUNT="${LIB_DIR}/lib-mount.sh"
LIB_STARTUP="${LIB_DIR}/lib-startup.sh"

LOG_FILE="/eproxy/boot.log"

#include config-lib.sh
. ${LIB_CONFIG}

# include lib-core.sh
. ${LIB_CORE}

# include lib-startup.sh
. ${LIB_STARTUP}

# include lib-mount.sh
. ${LIB_MOUNT}

# include lib-crypt.sh
. ${LIB_CRYPT}

# ************************** PROXY BOOT SEQUENCE *******************************
# at this point the device mapper named encryption-storage must already exist
function write_log()
{
	MSG="$1"
	print_log "${MSG}" "${LOG_FILE}" 
}

function write_err()
{
	MSG="$1"
	print_err "${MSG}" "${LOG_FILE}"
}


function mount_dongle()
{
	write_log "checking dongle ${XM_DONGLE_DEVICE}"
	#echo "checking dongle ${XM_DONGLE_DEVICE}" >> ${LOG_FILE}
	if is_device_or_exit ${XM_DONGLE_DEVICE} ; then
		write_log "${XM_DONGLE_DEVICE} exists"
		#echo "${XM_DONGLE_DEVICE} exists" >> ${LOG_FILE}
	else
		write_err "${XM_DONGLE_DEVICE} does not exist"
		#echo "${XM_DONGLE_DEVICE} does not exist" >> ${LOG_FILE}
		exit 0
	fi

	write_log "mounting dongle"
	#echo "mounting dongle" >> ${LOG_FILE}
	safe_mount ${XM_DONGLE_DEVICE} ${XM_KEYSTORE_MOUNT_POINT}
}

write_log "booting encryption proxy"
#echo "booting encryption proxy" >> ${LOG_FILE}
# mount dongle
mount_dongle


# check if device is luks formated with "cryptsetup luksUUID"
write_log "check luks device"
#echo "check luks device" >> ${LOG_FILE}
if ! is_luks_device ${XM_STORAGE_DEVICE} ; then
	write_log "${XM_STORAGE_DEVICE} is not a valid LUKS device"
fi


# open luks device
write_log "creating temporary device mapper"
#echo "creating temporary device mapper" >> ${LOG_FILE}
create_temporary_device_mapper ${XM_STORAGE_DEVICE} ${XM_DEVICE_MAPPER_NAME} ${XM_KEY_FILE}


# starts usb otg gadget driver as a mass storage
write_log "starting mass storage driver at ${ENCRYPTED_DEVICE}"
#echo "starting mass storage driver at ${ENCRYPTED_DEVICE}" >> ${LOG_FILE}
start_mass_storage_driver ${ENCRYPTED_DEVICE}

#echo "successfully booted all components" >> ${LOG_FILE}
write_log "successfully booted all components"
