#!/usr/bin/bash
VBOXGA_MOUNT=/media/cdrom
apt-get update -y
apt-get upgrade -y 
apt-get install build-essential vim git linux-headers-$(uname -r) -y
if [[ ! -e $VBOXGA_MOUNT ]]; then
    mkdir $VBOXGA_MOUNT
    mount /dev/cdrom $VBOXGA_MOUNT
fi
$VBOXGA_MOUNT/VBoxLinuxAdditions.run
umount $VBOXGA_MOUNT && rm -rf $VBOXGA_MOUNT
reboot
