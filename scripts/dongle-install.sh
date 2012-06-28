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

# load install-core.sh
INSTALL_CORE="install-core.sh"
if [ ! -f ${INSTALL_CORE} ]; then
	echo "ABORT: install-core.sh is missing"
	exit
else
	. ${INSTALL_CORE}
fi

# refresh sources
sudo apt-get update

# makepasswd - used for dongle keyfile generation
# generates random passwords
MAKEPASSWD="makepasswd"
check_or_install ${MAKEPASSWD}

# for creating vfat filesystem
DOSFSTOOLS="dosfstools"
check_or_install ${DOSFSTOOLS}
