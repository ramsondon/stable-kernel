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

# current directory
DIR=${PWD}
DIR_UBUNTU="${DIR}/ubuntu-12.04-r3-minimal-armhf"
DIR_KERNEL="${DIR}/linux"

SCRIPT_INSTALL_IMAGE="install_image.sh"
SCRIPT_SETUP_SDCARD="setup_sdcard.sh"


function build_kernel()
{
	# TODO: implement
}

function copy_kernel_to_sdcard()
{
	# TODO: implement
	# use install_image.sh
}

function setup_proxy()
{
	# TODO: implement modify
	# setup startup script, etc.
}

function setup_sdcard()
{
	# TODO: implement
	bash ${DIR_UBUNTU}${SCRIPT_SETUP_SDCARD}
}


# start creating sdcard image
echo "creating sdcard image"
setup_sdcard
echo "building kernel"
build_kernel
echo "installing new kernel to sdcard"
copy_kernel_to_sdcard
echo "setting up proxy"
setup_proxy

