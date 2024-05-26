#!/bin/bash
#shellcheck disable=SC2143
gkdFunc() {
	local GKDARGS="--daemonize --components=pkcs11,secrets,ssh"
	)
	if ! pgrep -f gnome-keyring-daemon >"/dev/null" 2>&1; then
		gnome-keyring-daemon --start "$GKDARGS"
	else
		gnome-keyring-daemon --replace "$GKDARGS"
	fi
}
checkDaemons() {
	if [[ $(journalctl -xe | grep dbus | grep failed >"/dev/null") ]]; then
		if ! systemctl is-active --quiet dbus; then
			sudo systemctl reload-or-restart dbus
		else
			sudo systemctl start dbus
		fi
	fi
	if [[ $(journalctl -xe | grep bluez | grep failed >"/dev/null") ]]; then
		if ! systemctl is-active --quiet bluez; then
			sudo systemctl reload-or-restart bluez
		else
			sudo systemctl start bluez
		fi
	fi
	if [[ $(journalctl -xe | grep homed | grep failed >"/dev/null") ]]; then
		if ! systemctl is-active --quiet systemd-homed; then
			sudo systemctl reload-or-restart systemd-homed
		else
			sudo systemctl start bluez
		fi
	fi
}
finalFunc() {
	sudo systemctl reset-failed
	sudo systemctl daemon-reload
	echo -e "#\n# if the issue still isnt resolved"
	echo -e "#\n# try reloading the desktop session"
	echo -e "#\n# if the issue persists try rebooting"
	echo -e "#\n if none of that works try reinstalling\n#"
}
if [ -n "$1" ]; then "$1"
else
	checkDaemons >"/dev/null" 2>&1
	gkdFunc >"/dev/null" 2>&1
	finalFunc
fi
