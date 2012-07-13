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

# console vars
unset VERSION
unset MMC
unset DEFAULT_MMC

# console version
VERSION=1.0

# script vars
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
	echo "building kernel..."
	cd ${DIR_KERNEL}
	/bin/bash ${SCRIPT_BUILD_KERNEL}
	echo "kernel built successfully"
}

function copy_kernel_to_sdcard()
{	
	echo "installing kernel..."
	cd ${DIR_KERNEL}
	/bin/bash ${SCRIPT_INSTALL_IMAGE}
	echo "kernel installed successfully"
}

function setup_sdcard()
{
	echo "creating sdcard image"
	cd ${DIR_UBUNTU}
	sudo /bin/bash ${SCRIPT_SETUP_SDCARD} --mmc ${MMC} --uboot beagle_xm
	echo "successfully created sdcard"
}

function setup_proxy()
{
	echo "installing proxy..."
	cd ${CURRENT_DIR}
	sudo /bin/bash ${SCRIPT_PROXY_INSTALL}
	echo "proxy installed successfully"
}


# **************************** console functionalities *************************

function echo_separator()
{
	echo "###############################################################################"
}

function echo_header()
{
	echo ""
	echo_separator
        echo "BeagleBoard-xM encryption proxy console v${VERSION}"
        echo "Copyright (c) 2012-2015 Matthias Schmid <ramsondon@gmail.com>"
	echo_separator
        echo ""
}

CMD_HELP="help"
CMD_INIT_MMC="init:mmc"
CMD_BUILD_KERNEL="build:kernel"
CMD_INSTALL_KERNEL="install:kernel"
CMD_INSTALL_PROXY="install:proxy"
CMD_INSTALL_ALL="install:all"
CMD_QUIT="quit"

OPTION_MMC="--mmc"


function echo_help()
{
        echo "This console is for creating your BeagleBoard-xM Encryption Proxy"
	echo ""
	echo "USAGE:"
	echo $'\t'"${0} <command> <options>"
	echo ""
	echo "PARAMETERS"
	echo $'\t'"<command>"
	echo $'\t\t'${CMD_HELP}$'\t\t'"prints help"
        echo $'\t\t'${CMD_INIT_MMC}$'\t'"setup sdcard with ubuntu 12.04"
        echo $'\t\t'${CMD_BUILD_KERNEL}$'\t'"builds 3.2.21-encryption-proxy kernel"

        echo $'\t\t'${CMD_INSTALL_KERNEL}$'\t'"copies 3.2.21-encryption-proxy kernel to sdcard"
        echo $'\t\t'${CMD_INSTALL_PROXY}$'\t'"installs required encryption software to sdcard"
	echo ""
	echo $'\t\t'${CMD_INSTALL_ALL}$'\t'"inits mmc, builds and installs kernel"
	echo $'\t\t\t\t'"3.2.21-encryption-proxy and all its dependencies"
	echo $'\t\t'${CMD_QUIT}
	echo ""
	echo $'\t'"<options>"
	echo $'\t\t'${OPTION_MMC} "<device>"$'\t'"the mmc device (e.g. /dev/sdc)"
}

# interpretes commands given to console
function interprete_command()
{
	case $1 in
		${CMD_HELP})
			echo_header
			echo_help
			return 0
		;;
		${CMD_INIT_MMC})
			setup_sdcard
			return 0
		;;
		${CMD_BUILD_KERNEL})
			build_kernel
			return 0
		;;
		${CMD_INSTALL_KERNEL})
			copy_kernel_to_sdcard
			return 0
		;;	
		${CMD_INSTALL_PROXY})
			setup_proxy
			return 0
		;;
		${CMD_INSTALL_ALL})
			setup_sdcard
			build_kernel
			copy_kernel_to_sdcard
			setup_proxy
			return 0
		;;
		${CMD_QUIT})
			exit 0
		;;	
	esac	
	return 1	
}

function interprete_option()
{
	unset MMC
	if [ $# -gt 1 ] ; then
		case $2 in
			${OPTION_MMC})
				if [ $# -gt 2 ] ; then
					MMC=$3
					return 0
				fi
				return 1
			;;
		esac
		return 1
	fi
	MMC=${DEFAULT_MMC}
	return 0
}

function echo_unknown_command()
{
	echo ""
	echo "UNKNOWN COMMAND: $*"
}

function echo_command_error()
{
	echo_header
	echo_help
	echo_unknown_command $*
}

# initial console application
function run_console()
{
	if ! interprete_option $* ; then
		echo_command_error $*
	else
		if ! interprete_command $* ] ; then
			echo_command_error $*
		fi
	fi
}

# ******************************************************************************
# ************************ start console application ***************************
# ******************************************************************************

# include generic build config
if [ ! -f ${GENERIC_CONFIG} ]; then
	echo "ABORT: ${GENERIC_CONFIG} not found"
	echo "Copy config.sample.sh to config.sh and modify it to your needs"
	exit 1
fi
. ${GENERIC_CONFIG}

# set default mmc card from config
DEFAULT_MMC=${MMC}

# run console
run_console $*
