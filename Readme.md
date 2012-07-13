Linux BeagleBoard-xM Encryption Proxy
=====================================

* @see http://elinux.org/BeagleBoardUbuntu#Ubuntu_11.10_.28Oneiric.29
* @see https://github.com/RobertCNelson/stable-kernel/

This preconfigured Kernel is for using your BeagleBoard as an encryption proxy for portable hard drives.

----------------------
### Kernel Version

3.2.21-encryption-proxy


### Creating your 2.3.21-encryption-proxy for BeagleBoard-xM


1. insert your mmc device to your host computer
2. check which device (e.g. /dev/sdc) is your mmc (e.g with dmesg)
3. copy config.sample.sh to config.sh
	3.1 uncomment LINUX_GIT (offical linux sources) and modify path to your needs
	3.2 uncomment MMC and modify to the SDCARD device (e.g. /dev/sdc)
4. start console.sh and follow instructions
	4.1 execute console with command install:all --mmc <device>
	you can also build the encryption proxy step by step using the console.sh


