#!/bin/bash
#
# fmkdisk.sh
#
# @author: Matthias Schmid
# @date: 2012/04/27
#
# This script formats a given device.
# PARAM: device/file

DEV=$1

if [ ! -e ${DEV} ]; then
	echo "the device ${DEV} does not exist"
	exit
fi

# TODO: confirm device selection, else exit
echo "Do you really want to format ${DEV}?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) 
		fdisk -lV

		# create filesystem VFAT
		echo "creating vfat filesystem on ${DEV}"
		mkfs -t vfat ${DEV}; break;;
        No ) exit;;
    esac
done



