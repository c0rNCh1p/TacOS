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
script provided below, be sure to make it executable (chmod explained in main readme):
```sh
#!/bin/bash
read -rep 'Is AwesomeWM installed?' ANS
[[ "$ANS" =~ ^(0|n|na|no|nu|al).* ]] &&
	echo 'Please install it before running this script'; exit 0
cd || exit 1 &>'/dev/null'
git clone 'https://github.com/c0rnch1p/tacOS.git' ||
git clone 'https://gitlab.com/c0rnch1p/tacOS.git'
[ -d "$HOME/.config/awesome" ] && rm -rf "$HOME/.config/awesome"
[ -d "$HOME/tacOS/tacOS/airootfs/etc/skel/.config/awesome" ] &&
	mv "$HOME/tacOS/tacOS/airootfs/etc/skel/.config/awesome" "$HOME/.config"
rm -rf "$HOME/tacOS" & clear
```
#### Basic Usage
##### Hotkeys
AwesomeWM comes with a built-in hotkeys popup that can be accessed with `Super + s`. This
will display all the available shortcuts in the current setup.

### Weather Widget Configuration
To configure the weather widget, provide the API key and city ID in the `openweather.conf` file.

Example:
```ini
api_key=insert_api_key_here
city_id=insert_city_id_here
```

Replace `insert_api_key_here` and `insert_city_id_here` with the actual OpenWeatherMap API key and the city ID for the location.