##
#### AwesomeWM Config
##
#### Overview
This AwesomeWM configuration aims to provide a fully functional and visually appealing
setup out of the box. Custom configs are included for autostart applications like Picom.
Shell scripts have been integrated with the Lua code for handling finicky systems like
Pulse. Additionally, it features an extensive set of custom launchers and other shortcuts
for window management, a nicely styled theme, and a variety of system menus and widgets.
#### Installation
This AwesomeWM configuration is part of a larger operating system created with Archiso.
The installation of dependencies and the configuration itself is handled automatically
during the OS installation. No manual installation steps are immediately required. If all
which is needed from this repo is the Awesome config, feel free to save and run this shell
script provided below, be sure to make it executable (chmod explained in main readme).
```sh
#!/bin/bash
# Please make sure AwesomeWM is installed on the current system
cd
git clone 'https://github.com/c0rNCh1p/tacOS.git' ||
git clone 'https://gitlab.com/c0rNCh1p/tacOS.git'
[ -d "$HOME/.config/awesome" ] && rm -rf "$HOME/.config/awesome"
if [ -d "$HOME/tacOS/tacOS/airootfs/etc/skel/.config/awesome" ]; then
	mv "$HOME/tacOS/tacOS/airootfs/etc/skel/.config/awesome" "$HOME/.config"
fi
rm -rf "$HOME/tacOS"
clear
```