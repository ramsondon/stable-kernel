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


