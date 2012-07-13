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

# main build configuration script
unset MMC
unset SOURCES

# The Linux Source directory for building the kernel
#
# cd ~/
# get it via: git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
# uncomment the following line
## LINUX_GIT=~/linux-stable

# Set your mmc device
# You are pleased to set this variable to your correct device
# or use the --mmc option flag in your console.sh
# uncomment the following three lines
##MMC=/dev/sdc
##MMC1=${MMC}1
##MMC2=${MMC}2

# This varibale must be set for the binaries direcotry
# DO not adjust it as long you do not rename the directory
#
# include binaries are:
#			cryptsetup
#			lsof
#			mkdosfs
SOURCES="${DIR}/binaries"
