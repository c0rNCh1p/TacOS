##
#### General
##
#### Details
• Arch: x86_64  
• Size: 5.5G (ISO)  
• Type: Squashfs  
• Vers: v02.01.02
#### Weblinks
• Archiso: https://wiki.archlinux.org/title/Archiso  
• Arcolinux: https://arcolinux.com/  
• Awesome: https://awesomewm.org/  
• Pacman: https://wiki.archlinux.org/title/Pacman  
• X.org: https://www.x.org/wiki/
#### Description
These isos are based on Arcolinux, no credit is taken for the aesthetics as well as most
of the backend including the grub and calamares configs. Arch users can feel free to build
an iso with the script and take a look in a virtual machine or flash it to a usb and run
it live, the installer works as intended. Many thanks to those who developed the software
that made the project possible, for making it usable and for making the code open source.
##
#### Installation
##
#### Installing Arch
• Arch Wiki: https://wiki.archlinux.org/title/Installation_guide  
• Howtogeek: https://www.howtogeek.com/766168/how-to-install-arch-linux-on-a-pc/  
• Phoenixnap: https://phoenixnap.com/kb/arch-linux-install
#### Depends
• archiso: Tools for creating arch Linux iso images  
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
cd 'tacOS'
chmod 764 'build_iso.sh'
./'build_iso.sh'
````
#### Flashing
A script to make the flashing process easier is included in the scripts folder:
````shell
cd 'scripts'
chmod 764 'flash_iso.sh'
./'flash_iso.sh'
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
the kernel will ask for an input variable, this is just the timezone which is entered in
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
##
