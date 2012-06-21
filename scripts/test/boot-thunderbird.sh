#!/bin/bash
#
# encryption-startup.sh
#
# @author: Matthias Schmid
# @date: 2012/04/20
#
# This file starts the g_mass_storage module with ${DEVICE} 
# as mass storage device.
# The mass storage device has to be inserted before kernel starts up.
# 
# Install:
#	chmod +x encryption-startup.sh
#	cp encryption-startup.sh /etc/init.d
#	update-rc.d encryption-startup.sh

# for additional info call man update-rc.d


# device to be mapped at system startup
#DEVICE=/dev/sda

# encryption-storage gadget driver
#DRIVER=g_mass_storage

# install driver
# TODO: check if sudo is required
#modprobe ${DRIVER} file=${DEVICE}
thunderbird
