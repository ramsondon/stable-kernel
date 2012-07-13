Linux BeagleBoard-xM Encryption Proxy
=====================================

* @see http://elinux.org/BeagleBoardUbuntu#Ubuntu_11.10_.28Oneiric.29
* @see https://github.com/RobertCNelson/stable-kernel/

This preconfigured Kernel is for using your BeagleBoard as an encryption proxy for portable hard drives.

----------------------
### Kernel Version

3.2.21-encryption-proxy


### Creating your 2.3.21-encryption-proxy for BeagleBoard-xM


#### 1. insert your mmc device to your host computer
#### 2. check which device (e.g. /dev/sdc) is your mmc (e.g with dmesg)
#### 3. copy config.sample.sh to config.sh
##### 3.1 uncomment LINUX_GIT (offical linux sources) and modify path to your needs
##### 3.2 uncomment MMC and modify to the SDCARD device (e.g. /dev/sdc)
#### 4. start console.sh and follow instructions
##### 4.1   execute console with command install:all --mmc <device>
###### 4.1.1 you can also build the encryption proxy step by step using the console.sh. required steps for a working encryption proxy are:
####### 4.1.1.1 init:mmc
####### 4.1.1.2 build:kernel (at this time add USB OTG Support -> Mass Storage to menuconfig)
####### 4.1.1.3 install:kernel
####### 4.1.1.4 install:proxy
#### 5. after finishing all steps insert SDCARD to your BeagleBoard-xM
#### 6. insert USB device into your Host computer and execute create-dongle.sh
##### 6.1 if this does not work execute dongle-install.sh to install all dependencies need for the dongle creation and execute create-dongle.sh again. 
#### 7. insert Storage device into USB slot Host 1
#### 8. insert precreated USB Dongle into USB slot Host 3
#### 9. plug in your USB OTG cable into your BeagleBoard-xM and then into your Host computer
#### 10. wait until your USB storage device plugged in USB slot Host 1 is being encrypted and your computer automatically mounts the new encrypted device.
#### 11. have fun using it.
