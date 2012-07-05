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

unset XM_DIR_BIN
unset XM_DIR_MAN


XM_DIR_BIN=/usr/bin
XM_DIR_MAN=/usr/share/man/man8

# copies lsof precompiled sources to sdcard
function lsof_copy()
{
	ROOTFS=$1
	echo "copying lsof binaries to ${XM_DIR_BIN}"
	rsync -avz ${PWD}/bin/* ${ROOTFS}${XM_DIR_BIN}

	echo "copying manual entries for lsof"
	rsync -avz ${PWD}/man/* ${ROOTFS}${XM_DIR_MAN}
}
