#!/usr/bin/bash
vboxga_mount=/media/cdrom0
vboxga_dir=/tmp/vboxga
apt-get update -y
apt-get install build-essential linux-headers-$(uname -r) -y
if [[ ! -e $vboxga_mount ]]; then
    echo "You need to insert the Guest Additions CD before continuing. Aborting..."
    exit 1
fi
cp -R $vboxga_mount $vboxga_dir
$vboxga_dir/VBoxLinuxAdditions.run
rm -rf $vboxga_dir
reboot
