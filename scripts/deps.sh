#!/bin/bash

# @file:   deps.sh
# @author: Matthias Schmid
# @email:  ramsondon@gmail.com
# @date:   2012/06/22

# this script updates and installs all necessary sources for the encryption-proxy

# Update Sources

sudo apt-get udpate
sudo apt-get install dist-upgrade

# Autologin: http://wiki.ubuntuusers.de/Autologin
# install rungetty

sudo apt-get install rungetty


# Auto-mounting: 
# http://wiki.ubuntuusers.de/Daten_verschl%C3%BCsseln#luks

sudo apt-get install libpam-mount

# Cryptsetup
# http://wiki.centos.org/HowTos/EncryptedFilesystem

sudo apt-get install cryptsetup

# loop aes
# https://www.shell-tips.com/2008/07/13/using-losetup-and-dd-to-secure-sensitive-data-encrypted-block-device/

sudo apt-get install loop-aes-utils


