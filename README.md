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

```bash
make ARCH=arm CROSS_COMPILE="arm-linux-gnueabihf-" orangepi_one_defconfig
make ARCH=arm CROSS_COMPILE="arm-linux-gnueabihf-"
```

Fichier à récuperer: u-boot-sunxi-with-spl.bin

```bash
sudo dd if=u-boot-sunxi-with-spl.bin of=/dev/sdc bs=1k seek=8
```

Installation Debian Stretch
===========================










Boot
====
```bash
setenv extra init=/bin/bash
```
```bash
mount -o remount -w /
```
```bash
passwd
```

Changer le pass

```bash
/debootstrap/debootstrap --second-stage
...
I: Base system installed successfully.
```

Redemarrer la carte

```bash
root@pc-12:~# cat /etc/fstab 
"File System"         "Mount Point"   "Type"  "Option"                "Dump"  "Pass"
/dev/mmcblk0p1          /               ext4    errors=remount-ro       0       1
```
