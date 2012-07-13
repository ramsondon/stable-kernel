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
#unset LIB_DIR
#unset LIB_CONFIG
#unset LIB_CORE
#unset LIB_CRYPT
#unset LIB_MOUNT
#unset LIB_STARTUP

unset LOG_FILE

#LIB_DIR="/eproxy/lib"
#LIB_CONFIG="${LIB_DIR}/config-lib.sh"
#LIB_CORE="${LIB_DIR}/lib-core.sh"
#LIB_CRYPT="${LIB_DIR}/lib-crypt.sh"
#LIB_MOUNT="${LIB_DIR}/lib-mount.sh"
#LIB_STARTUP="${LIB_DIR}/lib-startup.sh"

LOG_FILE="/eproxy/boot.log"

#include config-lib.sh
#. ${LIB_CONFIG}

# include lib-core.sh
#. ${LIB_CORE}

# include lib-startup.sh
#. ${LIB_STARTUP}

# include lib-mount.sh
#. ${LIB_MOUNT}

# include lib-crypt.sh
#. ${LIB_CRYPT}

# BeagleBoard-xM device variables
XM_STORAGE_DEVICE="/dev/sda"
XM_DONGLE_DEVICE="/dev/sdb"
XM_DEVICE_MAPPER_NAME="encryption-storage"
XM_ENCRYPTED_DEVICE="dev/mapper/${XM_DEVICE_MAPPER_NAME}"

XM_KEYSTORE_MOUNT_POINT="/mnt/keystore"
XM_KEY_FILE="${XM_KEYSTORE_MOUNT_POINT}/.dongle.key"
#XM_LIB_DIR="/eproxy"


# ************************** PROXY BOOT SEQUENCE *******************************
# at this point the device mapper named encryption-storage must already exist

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
                echo "mount ${DEVICE}"
                sudo mount ${DEVICE} ${DIR}
                wait_for_mount ${DIR}
        fi
}


function mount_dongle()
{
	write_log "checking dongle ${XM_DONGLE_DEVICE}"
	if is_device "${XM_DONGLE_DEVICE}" ; then
		write_log "${XM_DONGLE_DEVICE} exists"
	else
		write_err "${XM_DONGLE_DEVICE} does not exist"
		exit 0
	fi

	write_log "mounting dongle"
	safe_mount ${XM_DONGLE_DEVICE} ${XM_KEYSTORE_MOUNT_POINT}
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

function create_luks_device()
{
	write_log "in func create_luks_device"
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
	write_log "open LUKS device ${DEVICE} ${DEV_MAPPER_NAME} with key: ${KEYFILE}"
        cryptsetup luksOpen ${DEVICE} ${DEV_MAPPER_NAME} --key-file=${KEYFILE}
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


# ********************************************************************************
# **************************************** START SCRIPT **************************
# ********************************************************************************

write_log "booting encryption proxy"

# mount dongle
mount_dongle


# check if device is luks formated with "cryptsetup luksUUID"
write_log "check luks device"
if ! is_luks_device ${XM_STORAGE_DEVICE} ; then
	write_log "${XM_STORAGE_DEVICE} is not a valid LUKS device"
	write_log "start LUKS formatting disk..."
	create_luks_device ${XM_STORAGE_DEVICE} ${XM_KEY_FILE}
fi

# open luks device
write_log "creating temporary device mapper"
create_temporary_device_mapper ${XM_STORAGE_DEVICE} ${XM_DEVICE_MAPPER_NAME} ${XM_KEY_FILE}


# starts usb otg gadget driver as a mass storage
write_log "starting mass storage driver at ${XM_ENCRYPTED_DEVICE}"
start_mass_storage_driver ${XM_ENCRYPTED_DEVICE}

write_log "successfully booted all components"
