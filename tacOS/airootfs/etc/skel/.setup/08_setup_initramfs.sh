#!/bin/bash
#shellcheck disable=SC2162
#shellcheck disable=SC2143
installreqsFunc() {
	local PACKAGES PKG BTCHSIZE BATCH
	PACKAGES=(
		"grub"
		"mkinitcpio"
	)
	BTCHSIZE=9
	echo -e "#\n# installing requirements\n#"
	for ((i = 0; i < "${#PACKAGES[@]}"; i += BTCHSIZE)); do
		BATCH=("${PACKAGES[@]:i:BTCHSIZE}")
		sudo pacman -S --noconfirm --needed "${BATCH[@]}" || {
			for PKG in "${BATCH[@]}"; do
				echo -e "#\n# ⚠ failed to install $PKG  ⚠\n#" |
				tee -a "$HOME/blderr.txt"
			done
		}
	done
	sudo pacman -Syu
	sudo pacman -Fy
	sleep 1
}
setupmknitcpioFunc() {
	local KERNELMTIME INITRAMFSMTIME ANS
	KERNELMTIME=$(stat -c %Y "/boot/vmlinuz-linux")
	INITRAMFSMTIME=$(stat -c %Y "/boot/initramfs-linux.img")
	if [ "$INITRAMFSMTIME" -gt "$KERNELMTIME" ]; then
		echo -e "#\n# ramdisk is up to date\n#"
		echo -e "# (c) cancel\n# (g) generate anyway\n#"
		read -p "# ▸ " ANS
		if [ "$ANS" == "c" ]; then
			return 0
		else
			echo -e "#\n# this will overwrite the existing ramdisk\n#"
			echo -e "#\n# continue?\n#"
			read -p "# ▸ " ANS
			if [[ "$ANS" =~ ^(1|y|ya|ye|ta|ok|pl|th).* ]]; then
				sudo mkinitcpio -P --generate "/boot/initramfs-linux.img"
			else return 0
			fi
		fi
	else
		echo -e "#\n# ramdisk older than kernel image"
		echo -e "#\n# generating new initramfs image\n#"
		echo -e "# this will overwrite the existing ramdisk\n#"
		echo -e "#\n# continue?\n#"
		read -p "# ▸ " ANS
		if [[ "$ANS" =~ ^(1|y|ya|ye|ta|ok|pl|th).* ]]; then
			sudo mkinitcpio -P --generate "/boot/initramfs-linux.img"
		else
			return 0
		fi
	fi
}
setupgrubFunc() {
	local TARGET TARGET GRUBARGS ANS
	TARGETS=(
		"arm-coreboot"
		"arm-efi"
		"arm-uboot"
		"arm64-efi"
		"i386-coreboot"
		"i386-efi"
		"i386-ieee1275"
		"i386-multiboot"
		"i386-pc"
		"i386-qemu"
		"i386-xen"
		"i386-xen_pvh"
		"ia64-efi"
		"loongarch64-efi"
		"mips-arc"
		"mips-qemu_mips"
		"mipsel-arc"
		"mipsel-loongson"
		"mipsel-qemu_mips"
		"powerpc-ieee1275"
		"riscv32-efi"
		"riscv64-efi"
		"sparc64-ieee1275"
		"x86_64-efi (default)"
		"x86_64-xen"
	)
	GRUBARGS=(--efi-directory="/boot/efi")
	if [ $(tree "/boot/efi" | grep "grub") ]; then
		while true; do
			echo -e "#\n# grub isnt installed in /boot/efi"
			echo -e "#\n# (l) list targets\n# (e) enter target"
			echo -e "# (d) use default\n# (c) cancel\n#"
			read -p "# ▸ " ANS
			if [ "$ANS" == "l" ]; then
				for TARGET in "${TARGETS[@]}"; do echo " $TARGET" | less
				done
			elif [ "$ANS" == "e" ]; then
				echo -e "#\n# enter target\n#"
				read -r -p "# ▸ " ANS
				for ARG in "${GRUBARGS[@]}"; do
					sudo grub-install --target="$ANS" "$ARG"
				done; break
			elif [ "$ANS" == "d" ]; then
				for ARG in "${GRUBARGS[@]}"; do
					sudo grub-install --target="x86_64-efi" "$ARG"
				done; break
			elif [ "$ANS" == "c" ]; then break
			fi
		done
		if ! test -f "/boot/grub/grub.cfg"; then 
			echo -e "#\n# this system doesnt have a grub config"
			echo -e "#\n# generating a new one at /boot/grub/grub.cfg"
			sudo grub-mkconfig -o "/boot/grub/grub.cfg"
			sudo update-grub
		fi
	fi
}
if [ -n "$1" ]; then "$1"
else
	installreqsFunc
	setupmknitcpioFunc
	setupgrubFunc
fi
