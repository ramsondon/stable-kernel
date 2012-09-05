Linux BeagleBoard-xM Encryption Proxy
=====================================

* @see http://elinux.org/BeagleBoardUbuntu#Ubuntu_11.10_.28Oneiric.29
* @see https://github.com/RobertCNelson/stable-kernel/

This Linux Version is for using your BeagleBoard as an encryption proxy for portable hard drives.

----------------------
### Kernel Version

3.2.xx-encryption-proxy


### Creating your 2.3.xx-encryption-proxy for BeagleBoard-xM

<ul>
<li>insert your mmc device to your host computer</li>

<li>check which device (e.g. /dev/sdc) is your mmc (e.g with dmesg)</li>

<li>copy config.sample.sh to config.sh
	<ul>
		<li>uncomment LINUX_GIT (offical linux sources) and modify path to your needs</li>
		<li>uncomment MMC and modify to the SDCARD device (e.g. /dev/sdc)</li>
	</ul>
</li>
<li>start console.sh and follow instructions
	<ul>
		<li>execute console with command install:all --mmc <device></li>
		<li>you can also build the encryption proxy step by step using the console.sh. required steps for a working encryption proxy are:
			<ul>
				<li>init:mmc</li>
				<li>build:kernel (at this time add USB OTG Gadget Support -> Mass Storage Gadget to menuconfig)</li>
<li>install:kernel</li>
<li>install:proxy</li>
			</ul>
		</li>
	</ul>
</li>
<li>after finishing all steps insert SDCARD to your BeagleBoard-xM</li>
<li>insert USB device into your Host computer and execute create-dongle.sh
	<ul>
		<li>if this does not work execute dongle-install.sh to install all dependencies need for the dongle creation and execute create-dongle.sh again.</li>
	</ul>
</li>
<li>insert Storage device into USB slot Host 1</li>
<li>insert precreated USB Dongle into USB slot Host 3</li>
<li>plug in your USB OTG cable into your BeagleBoard-xM and then into your Host computer</li>
<li>wait until your USB storage device plugged in USB slot Host 1 is being encrypted and your computer automatically mounts the new encrypted device.</li>
<li>have fun using it.</li>
<ul>

------------------------
Hint:
------------------------
remove the network driver in menuconfig while compiling the kernel for better and more stable boot performance