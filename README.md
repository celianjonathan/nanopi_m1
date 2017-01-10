NanoPi M1
=========

Documentation
=============

http://wiki.friendlyarm.com/wiki/index.php/NanoPi_M1

Matériel
========

- NanoPi M1
- Sandisk MicroSDHC Ultra 64Go Classe 10

U-boot
======

http://git.denx.de/?p=u-boot.git;a=summary

make ARCH=arm CROSS_COMPILE="arm-linux-gnueabihf-" orangepi_one_defconfig
make ARCH=arm CROSS_COMPILE="arm-linux-gnueabihf-"

Fichier à récuperer: u-boot-sunxi-with-spl.bin

sudo dd if=u-boot-sunxi-with-spl.bin of=/dev/sdc bs=1k seek=8

Installation Debian Stretch
===========================










Boot
====

setenv extra init=/bin/bash

mount -o remount -w /

passwd

Changer le pass

/debootstrap/debootstrap --second-stage

...

I: Base system installed successfully.

Redemarrer la carte

root@pc-12:~# cat /etc/fstab 
# "File System"  "Mount Point"  "Type"  "Option"   "Dump"   "Pass"
/dev/mmblk0p1 /               ext4    errors=remount-ro 0       1

