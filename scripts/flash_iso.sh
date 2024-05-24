#!/bin/bash

DEFDIR='../iso_out'

compinit(){
	compmain(){
		local COMPREPLY
		COMPREPLY=$(compgen -W "$2" -- "${COMP_WORDS[COMP_CWORD]}")
	}
	complete -F compmain read
}
compinit

selectdrive(){
	compinit
	while true; do
		if [ -z "$DEVICE" ]; then
			echo -e '\nAvailable drives'
			lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep 'disk' | sed 's/^/▸ \/dev\//'
		fi
		echo -e '\nEnter drive name\n'
		read -rep '~ ' DEVICE
		if [ -e "$DEVICE" ]; then break
		else
			echo -e '\nInvalid device name'
		fi
	done
}

writeiso(){
	compinit
	sudo umount "$DEVICE"* &>'/dev/null'
	echo -e '\nOverwrite all existing data on the drive (y/n)\n'
	read -p '~ ' ANS
	if [ "$ANS" == 'y' ]; then echo
		if sudo dd if="$ISOFILE" | pv -s $(stat -c%s "$ISOFILE") -w 80 -N 'Flashing iso' | sudo dd of="$DEVICE"; then
			echo -e "\n$ISOFILE flashed to $DEVICE, ejecting now"
			if sudo eject "$DEVICE" &>'/dev/null'; then echo -e '\nDevice ejected'
			else echo -e '\n⚠ Cant eject device ⚠'
				exit 1
			fi
		else echo -e "\nError flashing $ISOFILE to $DEVICE"
			exit 1
		fi
	elif [ "$ANS" == 'n' ]; then echo -e '\nOperation cancelled'
	fi
}

if ! command -v pv &>'/dev/null'; then
	echo -e '\nPv isnt installed, installing it now\n'
	if ! sudo pacman -S pv --noconfirm; then
		echo -e '\nFailed to install Pv with pacman, installing it manually from repository\n'
		PKGURL='https://geo.mirror.pkgbuild.com/extra/os/x86_64/pv-1.8.9-1-x86_64.pkg.tar.zst'
		FLNM="$HOME/Downloads/pv-1.8.9-1-x86_64.pkg.tar.zst"
		wget -c -P "$HOME/Downloads" "$PKGURL"
		sudo pacman -U "$FLNM" --noconfirm
	fi
fi

echo -e '\nEnter the iso path'
echo -e "eg. $DEFDIR\n"
read -rep '~ ' ISODIR

if [ ! -d "$ISODIR" ]; then
	echo -e "\nError: ISO directory '$ISODIR' does not exist"
	exit 1
fi

ISOFILE=$(find "$ISODIR" -maxdepth 1 -type f -name *'.iso' -print -quit)
if [ -z "$ISOFILE" ]; then
	echo -e '\nCant find iso file'
	exit 1
fi

selectdrive && writeiso

unset CMP DEFDIR ISODIR ISOFILE DEVICE ANS
