#!/bin/bash
#shellcheck disable=SC2034
#
#             _ \  _ \   _ \   __| _ _|  |     __|  _ \  __|  __|
#             __/    /  (   |  _|    |   |     _|   | |  _|   _|
#            _|   _|_\ \___/  _|   ___| ____| ___| ___/ ___| _|
#
################################################################################
# ~ /usr/share/archiso/config/releng/profiledef.sh
################################################################################
# ~ $BROWSER https://wiki.archlinux.org/title/Archiso
# ~ Bat /usr/share/doc/archiso/README.profile.rst
################################################################################
iso_name='tacOS'
iso_label='tacOS_v03.01.02'
iso_publisher='tacOS <https://github.com/c0rnch1p>'
iso_application='tacOS Live Disk Image'
iso_version='v03.01.02'
install_dir='arch'
buildmodes=('iso')
bootmodes=(
	'bios.syslinux.mbr'
	'bios.syslinux.eltorito'
	'uefi-ia32.grub.esp'
	'uefi-x64.grub.esp'
	'uefi-ia32.grub.eltorito'
	'uefi-x64.grub.eltorito'
)
arch='x86_64'
pacman_conf='pacman.conf'
airootfs_image_type='squashfs'
airootfs_image_tool_options=(-comp xz -Xbcj x86 -b 1M -Xdict-size 1M)
bootstrap_tarball_compression=(zstd -c -T0 --auto-threads=logical --long -19)
# Default file permissions: 644 (rw-rw-r--) 
# Default file permissions: 755 (rwxr-xr-x)
file_permissions=(
	['/etc/grub.d/40_custom']='0:0:755'
	['/etc/gshadow']='0:0:600'
	['/etc/polkit-1/rules.d']='0:0:750'
	['/etc/shadow']='0:0:600'
	['/etc/sudoers.d']='0:0:700'
	['/etc/wireguard']='0:0:700'
	['/etc/X11/xinit/xinitrc.d/80-xapp-gtk3-module.sh']='0:0:755'
	['/root']='0:0:700'
	['/root/.bashrc']='0:0:600'
	['/root/.gnupg']='0:0:700'
	['/usr/local/bin/arcolinux-snapper']='0:0:755'
)
