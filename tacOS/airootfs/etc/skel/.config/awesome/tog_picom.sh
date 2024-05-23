#!/bin/bash
if pgrep -x 'picom' >'/dev/null'
then killall 'picom'
else picom -b --config "$HOME/.config/awesome/picom.conf"
fi
notify-send "Picom" "Picom was restarted"
