#!/bin/bash
#
# remove-encryption-storage.sh
#
# @author: Matthias Schmid
# @date: 2012/04/20
#
# Removes the encryption-storage boot script from rc
# must be executed as sudo or su

DIR=$PWD

if [ -e ${DIR}/config.sh ]; then

	# read configuration
	. config.sh

	if [ !"${BOOT_FILE}" -o !"${INSTALL_DIR}" -o ! -e ${DIR}/${BOOT_FILE} ]; then
		echo "ERROR: configuration variables not set or bootfile not exisiting"
	else
		echo "uninstalling ${BOOT_FILE} from rc"
		# remove the script
		update-rc.d -f ${BOOT_FILE} remove
		echo "removing ${BOOT_FILE} from ${INSTALL_DIR}"
		rm ${INSTALL_DIR}${BOOT_FILE}
	fi
else 
	echo "ERROR: Missing configuration file config.sh"
fi
