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

# This script makes your ubuntu encryption proxy sdcard.
unset GENERIC_CONFIG

unset CURRENT_DIR

unset DIR_UBUNTU
unset DIR_KERNEL
unset DIR_SCRIPTS

unset SCRIPT_BUILD_KERNEL
unset SCRIPT_INSTALL_IMAGE
unset SCRIPT_SETUP_SDCARD
unset SCRIPT_PROXY_INSTALL


GENERIC_CONFIG="config.sh"

# current directory
CURRENT_DIR=$PWD
DIR_UBUNTU="${CURRENT_DIR}/ubuntu-12.04-r3-minimal-armhf"
DIR_KERNEL="${CURRENT_DIR}/linux"
DIR_SCRIPTS="${CURRENT_DIR}/scripts"

SCRIPT_BUILD_KERNEL="build_kernel.sh"
SCRIPT_INSTALL_IMAGE="${DIR_KERNEL}/tools/install_image.sh"
SCRIPT_SETUP_SDCARD="${DIR_UBUNTU}/setup_sdcard.sh"
SCRIPT_PROXY_INSTALL="proxy-install.sh"


function build_kernel()
{
	cd ${DIR_KERNEL}
	sudo /bin/bash ${SCRIPT_BUILD_KERNEL}
}

function copy_kernel_to_sdcard()
{	
	cd ${DIR_KERNEL}
	sudo /bin/bash ${SCRIPT_INSTALL_IMAGE}
}

function setup_sdcard()
{
	cd ${DIR_UBUNTU}
	sudo /bin/bash ${SCRIPT_SETUP_SDCARD} --mmc ${MMC} --uboot beagle_xm
}

function setup_proxy()
{
	cd ${CURRENT_DIR}
	sudo /bin/bash ${SCRIPT_PROXY_INSTALL}
}

# ******************************************************************************
# ********************** start creating sdcard image ***************************
# ******************************************************************************

# include generic build config
if [ ! -f ${GENERIC_CONFIG} ]; then
	echo "ABORT: ${GENERIC_CONFIG} not found"
	exit -1
fi
. ${GENERIC_CONFIG}

echo "creating sdcard image"
setup_sdcard # working
echo "successfully created sdcard"

echo "building kernel"
build_kernel # working
echo "successfully built kernel"
 
echo "installing new kernel to sdcard"
copy_kernel_to_sdcard # working
echo "successfully copied new kernel"

echo "setting up proxy"
setup_proxy # working
echo "FINISHED: encryption proxy ready to use."
