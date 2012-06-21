#!/bin/bash
#
# install-encryption-storage.sh
#
# @author: Matthias Schmid
# @date: 2012/04/20
#
# this file installs the rc.encryption-storage.sh to rc for being started
# at kernel boot up
# start this file as sudo

DIR=$PWD

# boot up script
. config.sh

echo ${DIR}

if [ ! "${UNKNOWN_VAR}" ]; then
	echo "unknown var not found"
fi 

if [ ! "${BOOT_FILE}" -o ! "${UNKNOWN_VAR}" -o ! -e ${DIR}/${BOOT_FILE} ]; then
	echo "no .foo.sh available"
fi

# installation directory for boot scripts
INSTALL_PATH=/etc/init.d/

# install the boot up script for encryption storage
#cp ${BOOT_FILE} ${INSTALL_PATH}${BOOT_FILE}
#update-rc.d ${BOOT_FILE} defaults
echo ${BOOT_FILE}

