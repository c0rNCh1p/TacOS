#!/bin/bash
updateMandb(){
	echo -e "#\n# updating manual database\n#"
	sudo mandb 2>&1
}
updateSecconf(){
	echo -e "#\n# updating user security configs"
	gpg >"/dev/null" 2>&1 &
	sudo cp "/etc/pacman.d/gnupg/gpg.conf" "$HOME/.gnupg/"
	echo -e "#\n# created ~/.gnupg and updated gpg.conf"
	sleep 1
	echo "$HOME/.ssh/id_rsa" | ssh-keygen -q -t rsa -b 4096 -N "" >"/dev/null" 2>&1
	sudo cp "/etc/ssh/ssh_config" "$HOME/.ssh/"
 	touch "$HOME/.ssh/known_hosts"
 	echo -e "#\n# created ~/.ssh and updated ssh_config"
 	sleep 1
 	echo -e "#\n# generated default keypair in ~/.ssh"
}
updateFonts(){
	local FONTS
	FONTS=(
		"$FLAVOUR_HOME/fonts/chillstyle.ttf"
		"$FLAVOUR_HOME/fonts/nouveau_IBM_stretch.ttf"
		"$FLAVOUR_HOME/fonts/nouveau_IBM.ttf"
		"$FLAVOUR_HOME/fonts/phillysans.otf"
		"$FLAVOUR_HOME/fonts/square_one.ttf"
		"$FLAVOUR_HOME/fonts/xirod.ttf"
	)
	echo -e "#\n# updating font database\n#"
	for FONT in "${FONTS[@]}"; do
		font-manager -i "$FONT" >"/dev/null" 2>&1 &
		sleep 1
		font-manager -e "$FONT" >"/dev/null" 2>&1
	done
	sudo fc-cache -fv 2>&1
	sudo fc-cache -v "$LOCAL/share/fonts/" 2>&1
	sudo fc-cache -v "$FLAVOUR_HOME/fonts/" 2>&1
	sleep 1
	font-manager -u >"/dev/null" 2>&1 &
	killall -9 font-manager >"/dev/null" 2>&1 &
	clear
}
if [ -n "$1" ]; then "$1"
else
	updateMandb
	updateSecconf
	updateFonts
fi
