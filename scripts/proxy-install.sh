#!/bin/bash

# @file:   proxy-install.sh
# @author: Matthias Schmid
# @email:  ramsondon@gmail.com
# @date:   2012/06/22

# installs all dependencies for the proxy and makes fixups to run clean.

INSTALL_DEPENDENCIES="deps.sh"

if [ ! -f ${INSTALL_DEPENDENCIES} ]; then
	echo "ERROR: ${INSTALL_DEPENDENCIES} not found."
	exit;
else
	. ${INSTALL_DEPENDENCIES}
fi

# enable autologin
# edit: 	sudo /etc/init/tty1.conf
# replace line: exec /sbin/getty 38400 tty1
# by: 		exec /sbin/rungetty --autologin USERNAME tty1

# TODO: replace line code


# disable sudo password prompt
# this is totally insecure for the system but still... let's do it!
# https://help.ubuntu.com/community/RootSudo#Remove_Password_Prompt_For_sudo
# edit: 	sudo /etc/sudoers or sudo visudo
# append line: 	<username> ALL=NOPASSWD: ALL

# TODO: append line to file code


# start usb otg gadget driver
# edit:		.bashrc
# append line:	sudo modprobe g_mass_storage <device>

# TODO: append line to .bashrc of autologin user
