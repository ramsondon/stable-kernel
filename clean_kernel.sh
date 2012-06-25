#!/bin/bash
#
# @author: Matthias Schmid
# @email: ramsondon@gmail.com
# @date: 2012/04/20
#
# cleans the kernel source code in folder KERNEL

unset CC


SYS_CONFIG="system.sh"

if [ ! -f ${SYS_CONFIG} ]; then
	echo "${SYS_CONFIG} is missing"
	exit
else 
	. ${SYS_CONFIG}
fi

# current directory
DIR=$PWD

# clean kernel
cd ${DIR}/KERNEL/
make ARCH=arm CROSS_COMPILE=${CC} distclean
