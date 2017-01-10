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

```bash
sudo debootstrap --foreign --arch=armhf --include=less,vim,openssh-server,make,u-boot-tools,initramfs-tools,htop,linux-image-armmp-lpae stretch .
```

```bash
mkimage -A arm -O linux -T kernel -C none -a 0x42000000 -n "vmlinuz-4.8.0-2-armmp-lpae" -d vmlinuz-4.8.0-2-armmp-lpae uImage
mkimage -A arm -O linux -T ramdisk -C none -a 0x43300000 -n "initrd.uboot" -d initrd.uboot initrd.uboot
root@nanopim1-celian:~# cat /boot/boot.cmd 
setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p1 rootwait panic=10 ${extra}
ext2load mmc 0 0x42000000 boot/uImage
ext2load mmc 0 0x43300000 boot/initrd.uboot
ext2load mmc 0 0x43000000 boot/board.dtb
bootm 0x42000000 0x43300000 0x43000000
mkimage -C none -A arm -T script -d boot.cmd boot.scr
```
Boot
====

```bash
setenv extra init=/bin/bash
```

La carte étant flash avec une debian standard stretch, le mot de passe peut être changé en passant, via u-boot, directement par bash:

Interrompre le démarrage de u-boot et rentrer:

```bash
setenv extra init=/bin/bash
boot
```

Une fois le système lancé:

```bash
mount -o remount -w /
```
```bash
passwd
```

Vous pouvez alors finir le debootstrap:

```bash
/debootstrap/debootstrap --second-stage
...
I: Base system installed successfully.
```

Durant notre première tentative de boot, fsck n'était pas executé lors du boot.

Sur votre ordinateur, executez la ligne suivante:

```bash
sudo fsck /dev/sdc1 -y -v
...
Passe 2 : vérification de la structure des répertoires
Passe 3 : vérification de la connectivité des répertoires
Passe 4 : vérification des compteurs de référence
Passe 5 : vérification de l'information du sommaire de groupe

/dev/sdc1: ***** LE SYSTÈME DE FICHIERS A ÉTÉ MODIFIÉ *****

       16388 i-noeuds utilisés (0.42%, sur 3899392)
          28 fichiers non contigus (0.2%)
          20 répertoires non contigus (0.1%)
             nombre d'i-noeuds avec des blocs ind/dind/tind : 0/0/0
             Histogramme des profondeurs d'extents : 14606/13
      425265 blocs utilisés (2.73%, sur 15587072)
           0 bloc défectueux
           1 fichier de grande taille

       12804 fichiers normaux
        1814 répertoires
          12 fichiers de périphérique en mode caractère
          25 fichiers de périphérique en mode bloc
           0 fifo
           2 liens
        1724 liens symboliques (1724 liens symboliques rapides)
           0 socket
------------
       16381 fichiers
```

Modifier le fichier `/etc/fstab`:

```bash
root@pc-12:~# cat /etc/fstab 
"File System"         "Mount Point"   "Type"  "Option"                "Dump"  "Pass"
/dev/mmcblk0p1          /               ext4    errors=remount-ro       0       1
```

Redemarrer la carte

Gestion du Réseau
=================

