#!/bin/sh
# U-Boot compile Script for nanopi m1


### Installer de la tool-chain de cross compilation

sudo apt-get install crossbuild-essential-armhf
export PATH="${PATH}:/usr/bin"

### Récuperation de u-boot

git clone http://git.denx.de/u-boot.git
cd u-boot/
git checkout a705ebc81b7f91bbd0ef7c634284208342901149

### Génération du .config et compilation

make ARCH=arm CROSS_COMPILE="arm-linux-gnueabihf-" orangepi_one_defconfig
make ARCH=arm CROSS_COMPILE="arm-linux-gnueabihf-"

### On récupère le fichier a dd

#### FIXME
