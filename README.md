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

Formatage
---------

/!\ NE PAS MONTER LA CARTE SD /!\

```bash
sudo parted /dev/sdd
rm 1
mkpart primary ext4 2MB 63,9GB
```

http://git.denx.de/?p=u-boot.git;a=summary

Voir chez linaro pour les compilateurs cross.

```bash
make ARCH=arm CROSS_COMPILE="arm-linux-gnueabihf-" orangepi_one_defconfig
make ARCH=arm CROSS_COMPILE="arm-linux-gnueabihf-"
```

Fichier à récuperer: u-boot-sunxi-with-spl.bin

```bash
sudo dd if=u-boot-sunxi-with-spl.bin of=/dev/sdc bs=1k seek=8
```

Vérifier si u-boot démarre.

Installation Debian Stretch
===========================

```bash
sudo mkfs.ext4 /dev/sdc1
```

Monter la carte sd.

```bash
cd cle
sudo mkdir proc
sudo mount -t proc proc proc
```

```bash
sudo debootstrap --foreign --arch=armhf --include=less,vim,openssh-server,make,u-boot-tools,initramfs-tools,htop,linux-image-armmp-lpae stretch .
```

```bash
sudo cp /usr/bin/qemu-arm-static usr/bin/
sudo chroot .
```

Vous pouvez alors finir le debootstrap:

```bash
/debootstrap/debootstrap --second-stage
```

//FIXME virer les includes

La première fois le kernel ne sera présent donc relancer une deuxième fois, la troisième fois sera lancée au moment du boot de la board.

```bash
...
I: Base system installed successfully.
```

//FIXME Sipliter en 2 parties

Pour un u-boot qui supporte zImage:

```bash
ln -s vmlinuz-4.8.0-2-armmp-lpae zImage
ln -s initrd.img-4.8.0-2-armmp-lpae initrd
```

Pour un u-boot qui ne supporte pas zImage:

```bash
mkimage -A arm -O linux -T kernel -C none -a 0x42000000 -n "vmlinuz-4.8.0-2-armmp-lpae" -d vmlinuz-4.8.0-2-armmp-lpae uImage
mkimage -A arm -O linux -T ramdisk -C none -a 0x43300000 -n "initrd.uboot" -d initrd.uboot initrd.uboot
```

Créer le fichier `boot.cmd` situé dans `\boot` (Version uImage)

```bash
cat /boot/boot.cmd
setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p1 rootwait panic=10 ${extra}
ext2load mmc 0 0x42000000 boot/uImage
ext2load mmc 0 0x43000000 boot/board.dtb
ext2load mmc 0 0x43300000 boot/initrd.uboot
bootm 0x42000000 0x43300000 0x43000000
```

Créer le fichier `boot.cmd` situé dans `\boot` (Version zImage)

```bash
cat /boot/boot.cmd
setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p1 rootwait panic=10 ${extra}
ext4load mmc 0 0x42000000 boot/zImage
ext4load mmc 0 0x43000000 boot/board.dtb
ext4load mmc 0 0x43300000 boot/initrd
bootz 0x42000000 0x43300000:${filesize} 0x43000000
```

```bash
mkimage -C none -A arm -T script -d boot.cmd boot.scr
```

DTB
---

Le dtb se situe dans `/usr/lib/linux-image-4.8.0-2-armmp-lpae/usr/lib/linux-image-4.8.0-2-armmp-lpae`
Le fichier `sun8i-h3-orangepi-one.dtb` est à placer dans /boot. On l'a nommé `board.dtb` (lien symbolique good).

On arrive alors au dossier boot suivant:

```bash
I have no name!@pc-12:/boot# l
total 21916
drwxr-xr-x  2 root root     4096 Jan 10 15:39 .
drwxr-xr-x 22 root root     4096 Jan 10 15:31 ..
-rw-r--r--  1 root root  2959421 Jan  4 19:39 System.map-4.8.0-2-armmp-lpae
lrwxrwxrwx  1 root root       65 Jan 10 15:39 board.dtb -> /usr/lib/linux-image-4.8.0-2-armmp-lpae/sun8i-h3-orangepi-one.dtb
-rw-r--r--  1 root root      250 Jan 10 15:37 boot.cmd
-rw-r--r--  1 root root      322 Jan 10 15:38 boot.scr
-rw-r--r--  1 root root   186724 Jan  4 19:39 config-4.8.0-2-armmp-lpae
lrwxrwxrwx  1 root root       29 Jan 10 15:35 initrd -> initrd.img-4.8.0-2-armmp-lpae
-rw-r--r--  1 root root 15518010 Jan 10 15:34 initrd.img-4.8.0-2-armmp-lpae
-rw-r--r--  1 root root  3751128 Jan  4 19:39 vmlinuz-4.8.0-2-armmp-lpae
lrwxrwxrwx  1 root root       26 Jan 10 15:35 zImage -> vmlinuz-4.8.0-2-armmp-lpae
```

Boot
====

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

Relancer la 3ième fois le debootstrap:

```bash
/debootstrap/debootstrap --second-stage
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

