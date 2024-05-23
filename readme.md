##
#### General
##
#### Details
• Arch: x86_64  
• Size: 5.5G (ISO)  
• Type: Squashfs  
• Vers: v02.02.03
#### Weblinks
• Archiso: https://wiki.archlinux.org/title/Archiso  
• Arcolinux: https://arcolinux.com  
• Awesome: https://awesomewm.org  
• Pacman: https://wiki.archlinux.org/title/Pacman  
• X.org: https://www.x.org/wiki
#### Description
These ISOs are based on ArcoLinux, no credit is taken for the aesthetics as well as most
of the backend including the multiple bootloader and Calamares configs. Arch users can
feel free to build an ISO with the script and take a look in a virtual machine or flash it
to a usb and run it live, the installer works as intended. Thanks to those who developed
the software that made the project possible and for making the code open source.
##
#### Installation
##
#### Installing Arch
• Arch Wiki: https://wiki.archlinux.org/title/Installation_guide  
• Howtogeek: https://www.howtogeek.com/766168/how-to-install-arch-linux-on-a-pc  
• Phoenixnap: https://phoenixnap.com/kb/arch-linux-install
#### Depends
• archiso: Tools for creating arch Linux ISO images  
• pacman: Library based package manager with dependency support  
• reflector: Python script to retrieve and filter pacman mirror lists
#### Arch Linux
Open a terminal and clone this repo:
````shell
git clone 'https://github.com/c0rNCh1p/tacOS.git' ||
git clone 'https://gitlab.com/c0rNCh1p/tacOS.git'
````
Change to the build directory, make sure the script is executable and run it:
````shell
cd 'TacOS' && chmod 764 'build_iso.sh' && ./'build_iso.sh'
````
#### Flashing
A script to make the flashing process easier is included in the scripts folder:
````shell
cd 'scripts' && chmod 764 'flash_iso.sh' && ./'flash_iso.sh'
````
Be sure to unplug and reinsert the usb otherwise it wont be detected in the BIOS after its
ejected.
#### Booting
1. Reboot the machine.
2. Access the boot menu (UEFI, BIOS etc), requires pressing a specific key on powerup
(usually F12, F11, Esc, or Del), before anything else starts loading.
3. Go to the boot options tab, a list of available boot devices will be displayed.
4. Choose the one that corresponds to the live media (e.g. somebrand-USB or liveiso-DVD).
5. Go to the final tab, save the changes and reboot again.
##
#### Notes
##
#### No Symlinks
There are no symlinks in this repo, everything which would usually use a symlink during
the boot process of an operating system is done using a script or configured manually by
the user. As a result when booting into the live environment there is a point where the
the kernel may ask for an input variable, this is just the timezone which is entered in
the following format:
````shell
'Region/Zone'
````
Where region is the country and zone is the city or town.
#### No Login Manager
There is no login manager installed to the isos by default, nor is any extra support for
login managers included in the base filesystem. Upon booting into the live environment the
user is dropped into a tty and a welcome message is displayed. The message advises users
to run the setup scripts in '$HOME/.setup'. Some of the scripts require an active internet
connection, so if the machine isnt connected via ether just run:
````shell
nmtui
````
Establish the connection and then run the setup scripts.
#### No LTS
The Linux long term support packages arent included in the builds by default nor are they
supported in the bootloader configurations for GRUB, systemd-boot or syslinux configs. If
the LTS package is needed it can be added to the packagelists and whatever bootloader
config is in use. It can also just be installed and configured, for example with GRUB:
````shell
sudo pacman -S linux-lts linux-lts-headers && sudo grub-mkconfig -o '/boot/grub/grub.cfg'
````
Now the installed kernels should have default menuentries in the GRUB config.
#### No Netinstall
The Calamares configuration settings and modules included in the ISO are not intended for
installing the system over a connection and instead are optimized for offline usage.
Sometimes a completely offline installation is impossible, but being less dependant on the
network while using Calamares results in less headaches overall when installing and
testing weather in a virtual machine or on hardware.
##
