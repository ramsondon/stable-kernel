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
