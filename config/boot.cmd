setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p1 rootwait panic=10 ${extra}
ext2load mmc 0 0x42000000 boot/uImage
ext2load mmc 0 0x43300000 boot/initrd.uboot
ext2load mmc 0 0x43000000 boot/board.dtb
bootm 0x42000000 0x43300000 0x43000000

