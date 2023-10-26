#!/bin/bash
#             _ \  _ \   _ \   __| _ _|  |     __|  _ \  __|  __| 
#             __/    /  (   |  _|    |   |     _|   |  | _|   _|  
#            _|   _|_\ \___/  _|   ___| ____| ___| ___/ ___| _|   
################################################################################
# ▸ /usr/share/archiso/config/releng/profiledef.sh
################################################################################
# ▸ $BROWSER 'https://wiki.archlinux.org/title/Archiso'
################################################################################
# 1 BUILD PARAMTETERS
################################################################################
#shellcheck disable=SC2034
iso_name="tacOS"
iso_label="tacOS-v02.01.02"
iso_publisher="tacOS <https://github.com/c0rNCh1p>"
iso_application="tacOS Live/Rescue CD"
iso_version="v02.01.02"
install_dir="arch"
buildmodes=("iso")
bootmodes=(
	"bios.syslinux.mbr"
	"bios.syslinux.eltorito"
	"uefi-ia32.grub.esp"
	"uefi-x64.grub.esp"
	"uefi-ia32.grub.eltorito"
	"uefi-x64.grub.eltorito"
)
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=(
	"-comp"
	"xz"
	"-Xbcj"
	"x86"
	"-b"
	"1M"
	"-Xdict-size"
	"1M"
)
file_permissions=(
  ["/root"]="0:0:700"
  ["/root/.bashrc"]="0:0:600"
  ["/etc/shadow"]="0:0:600"
  ["/etc/gshadow"]="0:0:600"
  ["/etc/sudoers.d"]="0:0:700"
  ["/etc/wireguard"]="0:0:700"
  ["/etc/polkit-1/rules.d"]="0:0:750"
  ["/etc/grub.d/40_custom"]="0:0:755"
  ["/usr/local/bin/arcolinux-snapper"]="0:0:755"
  ["/usr/local/bin/fix-pacman-database-and-keys"]="0:0:755"
  ["/usr/local/bin/arcolinux-graphical-target-mod"]="0:0:755"  
  ["/etc/X11/xinit/xinitrc.d/80-xapp-gtk3-module.sh"]="0:0:755"
)
################################################################################
