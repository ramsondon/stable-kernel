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


# installs all dependencies for the proxy and makes fixups to run clean.
unset ROOTFS

DIR=$PWD

# include proxy config-lib.sh
CONFIG_LIB="${DIR}/scripts/lib/config-lib.sh"
. ${CONFIG_LIB}

# include lib-core.sh
. ${LIB_CORE}

# include config.sh
import_file_or_abort config.sh
# include lib-mount.sh
import_file_or_abort ${LIB_MOUNT}

SCRIPT_RC_LOCAL="${DIR}/scripts/startup/rc.local"
#CRIPT_RC_LOCAL="${DIR}/scripts/startup/S99eproxy"
SCRIPT_STARTUP="${DIR}/scripts/startup/proxy-startup.sh"

CRYPTSETUP="${SOURCES}/cryptsetup"
MKFS="${SOURCES}/mkfs"
LSOF="${SOURCES}/lsof"

# installs dependencies of cryptsetup
# more less copies precomiled sources to ROOTFS
function install_cryptsetup()
{
        ROOTFS=$1
	echo "installing cryptsetup..."
        cd ${CRYPTSETUP}
        . copy.sh

        cryptsetup_copy ${ROOTFS}
        cd ${DIR}
}

# installs dependencies of mkfs.vfat
# more less copies precompiled sources to ROOTFS
function install_mkfs_vfat()
{
        ROOTFS=$1
	echo "installing mkfs vfat"
        cd ${MKFS}
        . copy.sh

        mkfs_copy ${ROOTFS}
        cd ${DIR}
}

# install precompiled sources of lsof to ROOTFS
function install_lsof()
{
	ROOTFS=$1
	echo "installing lsof"
	cd ${LSOF}
	. copy.sh
	
	lsof_copy ${ROOTFS}
	cd ${DIR}
}

# create /lib/eproxy/lib
function create_lib_dir()
{
	echo "creating directory structures"
	mkdir -p ${ROOTFS}${XM_LIB_DIR}/lib
}

function install_startup_scripts()
{
	#create_lib_dir

	# copy startup scripts
	echo "copying ${SCRIPT_STARTUP} to ${XM_LIB_DIR}"
	cp ${SCRIPT_STARTUP} ${ROOTFS}${XM_LIB_DIR}

	# copy scripts/lib to /lib/eproxy/lib
	#echo "copying ${LIB_DIR}/* to ${XM_LIB_DIR}"
	#cp  ${LIB_DIR}/* ${ROOTFS}${XM_LIB_DIR}/lib

	# copy rc.local to /etc/rc.local
	echo "copying rc.local to /etc/rc.local"
	cp ${SCRIPT_RC_LOCAL} ${ROOTFS}/etc/rc.local 
	
	# copy S99eproxy to /etc/rcS.d
	#cp ${SCRIPT_RC_LOCAL} ${ROOTFS}/etc/init.d/eproxy
	#chmod +x ${ROOTFS}/etc/init.d/eproxy
	#local DIR=${PWD}
	#cd ${ROOTFS}/etc/rcS.d
	#ln -s ../init.d/eproxy S99eproxy
	#cd ${DIR}
}

function on_before_post_install()
{
	if [ ! -d ${TEMPDIR} ]; then
        	mkdir -p ${TEMPDIR}
	fi

	echo "unmounting devices ${MMC1} and ${MMC2}..."
	try_umount_device ${MMC1}
	try_umount_device ${MMC2}

	# mount rootfs
	safe_mount ${MMC2} ${TEMPDIR}

	# create mount point for keystore
	echo "creating mount point for keystore"
	if [ ! -d ${ROOTFS}${XM_KEYSTORE_MOUNT_POINT} ]; then
		mkdir -p ${ROOTFS}${XM_KEYSTORE_MOUNT_POINT}
	fi
}

function on_post_install()
{
	# FIXME: insert /dev/sdb /mnt/keystore into mtab
	# At this time Start up script does the mount
	# MTAB="${ROOTFS}/etc/mtab"
	# MTAB_ENTRY="${XM_DONGLE_DEVICE} ${XM_KEYSTORE_MOUNT_POINT} vfat rw 0 0"
	# echo ${MTAB_ENTRY} >> ${MTAB}

	# copy precompiled sources
	install_cryptsetup ${ROOTFS}
	install_mkfs_vfat ${ROOTFS}
	install_lsof ${ROOTFS}

	# copy startup scripts
	install_startup_scripts
}

function check_install()
{
	#if [ ! -d ${ROOTFS}${} ] ; then	
	#fi
	echo "checking installation..."
}

# umounts device and cleans up temporary directories
function on_after_post_install()
{
	check_install
	
	# cd to current directory to unmount device and
	# remove temporary mount point
	cd ${CURRENT_DIR}

	# umount temp dir
	safe_umount ${MMC2} ${TEMPDIR}

	# clean up
	echo "removing ${TEMPDIR}"
	rm -rf ${TEMPDIR}
}


# enable autologin
# edit: 	sudo /etc/init/tty1.conf
# replace line: exec /sbin/getty -8 38400 tty1
# by: 		exec /sbin/rungetty --autologin USERNAME tty1

# TODO: replace line code


# disable sudo password prompt
# this is totally insecure for the system but still... let's do it!
# https://help.ubuntu.com/community/RootSudo#Remove_Password_Prompt_For_sudo
# edit: 	sudo /etc/sudoers or sudo visudo
# append line: 	<username> ALL=NOPASSWD: ALL

# TODO: append line to file code

unset TEMPDIR
TEMPDIR="${DIR}/tmp"
ROOTFS=${TEMPDIR}

on_before_post_install
on_post_install
on_after_post_install
