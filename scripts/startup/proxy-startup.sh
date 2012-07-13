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

unset LOG_FILE

unset XM_STORAGE_DEVICE
unset XM_DONGLE_DEVICE
unset XM_DEVICE_MAPPER_NAME
unset XM_ENCRYPTED_DEVICE
unset XM_KEYSTORE_MOUNT_POINT
unset XM_KEY_FILE

LOG_FILE="/eproxy/boot.log"

# BeagleBoard-xM device variables
XM_STORAGE_DEVICE="/dev/sda"
XM_DONGLE_DEVICE="/dev/sdb"
XM_DEVICE_MAPPER_NAME="encryption-storage"
XM_ENCRYPTED_DEVICE="dev/mapper/${XM_DEVICE_MAPPER_NAME}"

XM_KEYSTORE_MOUNT_POINT="/mnt/keystore"
XM_KEY_FILE="${XM_KEYSTORE_MOUNT_POINT}/.dongle.key"



# ************************** PROXY BOOT SEQUENCE *******************************
# at this point the device mapper named encryption-storage must already exist

# print_msg
#
# @param $1 the log prefix
# @param $2 the message
# @param $3 the log file name
function print_msg()
{
        PREFIX="$1"
        MSG="$2"
        LOG_FILE="$3"
        echo "${PREFIX} ${MSG}" >> ${LOG_FILE}
}

# print_log
#
# @param $1 the message
# @param $2 the log file name
function print_log()
{
        MSG="$1"
        LOG_FILE="$2"
        DATE=$(date)
        print_msg "LOG: ${DATE}: " "${MSG}" "${LOG_FILE}"
}

# print_err
# 
# @param $1 the message
# @param $2 the log file name
function print_err()
{
        MSG="$1"
        LOG_FILE="$2"
        DATE=$(date)
        print_msg "ERR: ${DATE}: " "${MSG}" "${LOG_FILE}"
}

# write_log
# 
# @param $1 the message
function write_log()
{
	MSG="$1"
	print_log "${MSG}" "${LOG_FILE}" 
}

# write_err
#
# @param $1 the message
function write_err()
{
	MSG="$1"
	print_err "${MSG}" "${LOG_FILE}"
}

# is_device
#
# @param $1 device
function is_device()
{
        DEVICE=$1
        if [ ! -e ${DEVICE} ] ; then
                return 1
        fi
        return 0
}

# wait_for_mount
#
# @param $1 target directory
function wait_for_mount()
{
        DIR=$1
        while ! mount | grep ${DIR} > /dev/null ; do
                WAIT="for mount"
        done
}

# safe_mount
#
# waits until the device is mounted
#
# @param $1 device to mount
# @param $2 target directory
function safe_mount()
{
        DEVICE=$1
        DIR=$2
        # if dir is not mounted mount
        if ! mount | grep ${DIR} > /dev/null ; then
                write_log "mount ${DEVICE}"
                sudo mount ${DEVICE} ${DIR}
                wait_for_mount ${DIR}
        fi
}

# mount_dongle
#
function mount_dongle()
{
	write_log "checking dongle ${XM_DONGLE_DEVICE}"
	while ! is_device "${XM_DONGLE_DEVICE}" ; do
		DONGLE_ATTACHED="true"
	done
	if is_device "${XM_DONGLE_DEVICE}" ; then
		write_log "${XM_DONGLE_DEVICE} exists"	
		write_log "mounting dongle"
		safe_mount ${XM_DONGLE_DEVICE} ${XM_KEYSTORE_MOUNT_POINT}
		return 0
	fi
	write_err "${XM_DONGLE_DEVICE} does not exist"
	return 1
}

# is_luks_device
#
# @param $1 device
function is_luks_device()
{
        DEVICE=$1
	MSG=$(cryptsetup luksUUID ${DEVICE})
	write_log ${MSG}
	if cryptsetup luksUUID ${DEVICE} ; then
                return 0
        fi
        return 1
}

# open_luks_device
#
# @param $1 target device
# @param $2 mapping name
# @param $3 key file
function open_luks_device()
{
        DEVICE=$1               # /dev/sda
        DEV_MAPPER_NAME=$2      # encryption-storage
        KEYFILE=$3              # /mnt/keystore/.dongle.key
	write_log "open LUKS device ${DEVICE} ${DEV_MAPPER_NAME} with key: ${KEYFILE}"
        cryptsetup luksOpen ${DEVICE} ${DEV_MAPPER_NAME} --key-file=${KEYFILE}
}

# create_luks_device
#
function create_luks_device()
{
	DEVICE=$1
	write_log "LUKS formatting ${DEVICE}..."
	# LUKS format device 

# ATTENTION: the following three lines MUST NOT have an indent
# cryptsetup luksFormat ${DEVICE} --key-file=${XM_KEY_FILE} << EOF
# YES 
# EOF
# to automatically answer to the LUKS format prompt: YES
cryptsetup luksFormat ${DEVICE} --key-file=${XM_KEY_FILE} << EOF
YES 
EOF
	
	# open luks device
        open_luks_device ${XM_STORAGE_DEVICE} ${XM_DEVICE_MAPPER_NAME} ${XM_KEY_FILE}
	# create filesystem on mapped device
	mkfs.vfat ${XM_ENCRYPTED_DEVICE}
}

# start_mass_storage_driver
#
# @param $1 mapped target device file
function start_mass_storage_driver()
{
        DEVICE=$1
        DRIVER="g_mass_storage"

        # start mass storage module
        modprobe ${DRIVER} file=${DEVICE} stall=n
}


# ******************************************************************************
# ******************************** EXECUTE START SCRIPT ************************
# ******************************************************************************

write_log "booting encryption proxy"

# mount dongle
while ! mount_dongle ; do
	MOUNT_DONGLE_ACTION="not succeeded"
done

# check if device is luks formated with "cryptsetup luksUUID"
write_log "check luks device"
if ! is_luks_device ${XM_STORAGE_DEVICE} ; then
	write_log "${XM_STORAGE_DEVICE} is not a valid LUKS device"
	write_log "start LUKS formatting disk..."
	create_luks_device ${XM_STORAGE_DEVICE} ${XM_KEY_FILE}
else
	# open luks device
	open_luks_device ${XM_STORAGE_DEVICE} ${XM_DEVICE_MAPPER_NAME} ${XM_KEY_FILE}
fi


# starts usb otg gadget driver as a mass storage
write_log "starting mass storage driver at ${XM_ENCRYPTED_DEVICE}"
start_mass_storage_driver ${XM_ENCRYPTED_DEVICE}
