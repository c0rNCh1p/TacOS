echo -e "#\n# setting up pacman-key\n#"
sudo pacman-key --init
sudo pacman-key --populate archlinux
echo -e "#\n# setting up mirrors\n#"
sudo reflector --age 6 --latest 20 --sort score --protocol https --save "/etc/pacman.d/mirrorlist"
sudo pacman -Syu
sudo pacman -Fy
if ! command -v yay &>"/dev/null"; then
	echo -e "# yay not installed\n# installing it now\n#"
	git clone "https://aur.archlinux.org/yay.git"
	cd yay || exit 1
	sudo makepkg -si --noconfirm
	cd ..
	sudo rm -rf yay
fi
echo -e "#\n# generating yay database and \n# enabling development packages\n#"
yay -Y --gendb
yay -Y --devel --save
echo -e "\n# setting batchinstall and combined upgrade\n#"
yay -Y --batchinstall --save
yay -Y --combinedupgrade --save
echo -e "# setup complete\n#"
