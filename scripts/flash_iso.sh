#!/bin/bash

compInit() {
	compMain() {
		local COMPREPLY
		COMPREPLY=$(compgen -W "$2" -- "${COMP_WORDS[COMP_CWORD]}")
	}
	complete -F compMain read
}
compInit

selectdrive() {
	compInit
	while true; do
		if [ -z "$DEVICE" ]; then
			echo -e '\nAvailable drives\n'
			lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep 'disk' | sed 's/^/▸ \/dev\//'
		fi
		echo -e '\nEnter drive name\n'
		read -rep '▸ ' DEVICE
		if [ -e "$DEVICE" ]; then break
		else
			echo -e '\nInvalid device name\n'
		fi
	done
}

if ! command -v pv &>'/dev/null'; then
    echo -e "\nPv isn't installed\nInstalling it now\n"
    if ! sudo pacman -S pv --noconfirm; then
        echo -e "\nFailed to install Pv with pacman\nInstalling it manually from the repository\n"
        PKGURL="https://geo.mirror.pkgbuild.com/extra/os/x86_64/pv-1.8.0-1-x86_64.pkg.tar.zst"
        FLNM="$HOME/Downloads/pv-1.8.0-1-x86_64.pkg.tar.zst"
        wget -c -P "$HOME/Downloads" "$PKGURL"
        sudo pacman -U "$FLNM" --noconfirm
    fi
fi

DEFDIR="$HOME/iso_out"
echo -e '\nEnter the iso path'
echo -e "eg. $DEFDIR\n"
read -rep '▸ ' ISODIR

ISOFILE=$(find "$ISODIR" -maxdepth 1 -type f -name *'.iso' -print -quit)
if [ -z "$ISOFILE" ]; then
	echo -e '\nCant find iso file\n'; exit 1
fi

selectdrive
sudo umount "$DEVICE"* &>'/dev/null'
echo -e '\nOverwrite all existing data on the drive (y/n)\n'
read -p '▸ ' ANS
if [ "$ANS" == 'y' ]; then echo
	if sudo dd if="$ISOFILE" | pv -s $(stat -c%s "$ISOFILE") -w 80 -N "Flashing iso" | sudo dd of="$DEVICE"; then
		echo -e "\n$ISOFILE flashed to $DEVICE\nEjecting now to complete write process\n"
		if sudo eject "$DEVICE" &>'/dev/null'; then echo -e 'Device ejected\n'
		else echo -e '⚠ cant eject device ⚠\n'; exit 1
		fi
	else echo -e '\nError flashing $ISOFILE to $DEVICE\n'; exit 1
	fi
elif [ "$ANS" == 'n' ]; then echo -e '\nOperation cancelled\n'
fi
unset CMP DEFDIR ISODIR ISOFILE DEVICE ANS
