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

# lib-mount.sh

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

# wait_for_umount
#
# @param $1 target directory
function wait_for_umount()
{
	DIR=$1
	while mount | grep ${DIR} > /dev/null ; do
		WAIT="for mount"
	done
}

# wait_until_not_busy
#
# @param $1 device
function wait_until_not_busy()
{
	DEVICE=$1
	while lsof | grep ${DEVICE} > /dev/null ; do
		WAIT="until device is not busy"
	done
}

# try_umount_device
#
# umounts a device if mounted 
#
# @param $1 device to umount
function try_umount_device()
{
	DEVICE=$1
	if mount | grep ${DEVICE} > /dev/null ; then
		wait_until_not_busy
		echo "umount ${DEVICE}"
		sudo umount ${DEVICE}
	fi 
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

# safe_umount
#
# umounts a device and waits till umounted
# 
# @param $1 device to umount
# @param $2 target directory
function safe_umount()
{
	DEVICE=$1
	DIR=$2
	# if dir is mounted umount
	if mount | grep ${DEVICE} > /dev/null ; then
		wait_until_not_busy ${DEVICE}
		echo "umount ${DEVICE}"
		sudo umount ${DEVICE}
		wait_for_umount ${DIR}
	fi
}
