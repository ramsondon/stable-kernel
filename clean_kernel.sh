#!/bin/bash
#
# @author: Matthias Schmid
# @date: 2012/04/20
#
# cleans the kernel source code in folder KERNEL

# TODO: replace by reading system.h
CC=arm-linux-gnueabi-

# current directory
DIR=$PWD

# clean kernel
cd ${DIR}/KERNEL/
make ARCH=arm CROSS_COMPILE=${CC} distclean
