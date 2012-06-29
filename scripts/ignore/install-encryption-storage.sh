#!/bin/bash
#
# install-encryption-storage.sh
#
# @author: Matthias Schmid
# @date: 2012/04/20
#
# this file installs the rc.encryption-storage.sh to rc for being started
# at kernel boot up
# must be executed as sudo or su

DIR=$PWD

if [ -e {$DIR}/config.sh ]; then
	
	# read configuration
	. config.sh

	# check if all variables are set
	if [ !"${BOOT_FILE}" -o !"${INSTALL_DIR}" -o ! -e ${DIR}/${BOOT_FILE} ]; then
		echo "ERROR: configuration variables not set or bootfile not existing"
	else
		echo "copying ${BOOT_FILE} to ${INSTALL_DIR}"
		# install the boot up script for encryption storage
		cp ${BOOT_FILE} ${INSTALL_DIR}/${BOOT_FILE}

		echo "update rc to start ${BOOT_FILE} at system startup"
		update-rc.d ${BOOT_FILE} defaults
	fi
else
	echo "ERROR: Missing configuration file config.sh"
fi
