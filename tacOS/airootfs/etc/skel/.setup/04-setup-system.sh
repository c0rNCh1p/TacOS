#!/bin/bash
#shellcheck disable=SC2162
setntpFunc() {
	local ANS
	if ! timedatectl | grep "NTP service: active" >"/dev/null"; then
		echo -e "#\n# ntp is inactive\n#"
		echo -e "# turn it on?\n#"
		read -p "# ▸ " ANS
		[[ "$ANS" =~ ^(1|y|ya|ye|ta|ok|pl|th).* ]] && timedatectl set-ntp true
	fi
}
sethostnameFunc() {
	local ANS NEWNAME
	if hostnamectl | grep "$HOSTNAME" >"/dev/null"; then
		echo -e "#\n# hostname: $HOSTNAME\n#"
		echo -e "# configure hostname?\n#"
		read -p "# ▸ " ANS
		if [[ "$ANS" =~ ^(1|y|ya|ye|ta|ok|pl|th).* ]]; then
			echo -e "#\n# enter new hostname\n#"
			read -p "# ▸ " NEWNAME
			hostnamectl set-hostname "$NEWNAME"
			echo -e "#\n# hostname set to $NEWNAME"
		fi
	fi
}
setlocaleFunc() {
	local LOCALE ANS
	LOCALE=$(locale | grep LANG | sed 's/LANG=//g')
	getlocales() {
		tail -n495 "/etc/locale.gen" | sed 's/#//' | head -n489
	}
	echo -e "#\n# locale: $LOCALE\n#"
	echo -e "# configure locale?\n#"
	read -p "# ▸ " ANS
	if [[ "$ANS" =~ ^(1|y|ya|ye|ta|ok|pl|th).* ]]; then
		while true; do
			echo -e "#\n# (l) list\n# (r) refresh\n# (e) enter\n# (c) cancel\n#"
			read -p "# ▸ " ANS
			if [ "$ANS" == "l" ]; then
				getlocales | less
			elif [ "$ANS" == "r" ]; then
				sudo locale-gen; break
			elif [ "$ANS" == "e" ]; then
				echo -e "#\n# enter locale\n#"
				read -p "# ▸ " ANS
				if getlocales | grep -qw "$ANS"; then
					localectl set-locale LANG="$ANS" >"/dev/null" 2>&1
					if ! grep "$ANS" "/etc/locale.conf" >"/dev/null"; then
						echo "$ANS" >>"/etc/locale.conf"
					fi
					echo -e "#\n# locale set to $ANS"; break
				else
					echo -e "#\n# ⚠ invalid locale ⚠"
				fi
			elif [ "$ANS" == "c" ]; then break
			fi
		done
	fi
}
settimezoneFunc() {
	local TIMEZONE REGION ZONE ANS
	TIMEZONE=$(timedatectl | grep "zone" | sed 's/Time zone://g' | tr -s ' ')
	getregions() {
		ls -vCa "/usr/share/zoneinfo/"
	}
	getzones() {
		ls -vCa "/usr/share/zoneinfo/$REGION"
	}
	[ -d "/etc/localtime" ] && sudo rm -rf "/etc/localtime"
	echo -e "#\n# timezone: $TIMEZONE\n#"
	echo -e "# configure timezone?\n#"
	read -p "# ▸ " ANS
	if [[ "$ANS" =~ ^(1|y|ya|ye|ta|ok|pl|th).* ]]; then
		while true; do
			echo -e "#\n# (l) link /usr/share/zoneinfo/UTC"
			echo -e "# (e) enter region and zone manually\n# (c) cancel\n#"
			read -p "# ▸ " ANS
			if [ "$ANS" == "l" ]; then
				sudo ln -sf "/usr/share/zoneinfo/UTC" "/etc/localtime"
				echo -e "#\n# timezone set to UTC"; break
			elif [ "$ANS" == "e" ]; then
				while true; do
					echo -e "#\n# (l) regions\n# (e) enter region\n# (c) cancel\n#"
					read -p "# ▸ " ANS
					if [ "$ANS" == "l" ]; then
						getregions | less
					elif [ "$ANS" == "e" ]; then
						echo -e "#\n# enter region\n#"
						read -p "# ▸ " REGION
						if ! getregions | grep -qw "$REGION"; then
							echo -e "#\n# ⚠ invalid region ⚠"
						else break
						fi
					elif [ "$ANS" == "c" ]; then break
					fi
				done
				if [[ "$ANS" != "c" && -d "/usr/share/zoneinfo/$REGION" ]]; then
					while true; do
						echo -e "#\n# (l) zones"
						echo -e "# (e) enter zone\n# (c) cancel\n#"
						read -p "# ▸ " ANS
						if [ "$ANS" == "l" ]; then
							getzones | less
						elif [ "$ANS" == "e" ]; then
							echo -e "#\n# enter zone\n#"
							read -p "# ▸ " ZONE
							if ! getzones | grep -qw "$ZONE"; then
								echo -e "#\n# ⚠ invalid zone ⚠"
							else
								sudo ln -sf "/usr/share/zoneinfo/$REGION/$ZONE" "/etc/localtime"
								echo -e "#\n# timezone set to $REGION/$ZONE"; break
							fi
						elif [ "$ANS" == "c" ]; then break
						fi
					done
				else
					sudo ln -sf "/usr/share/zoneinfo/$REGION" "/etc/localtime"
					echo -e "#\n# timezone set to $REGION"
				fi
				break
			elif [ "$ANS" == "c" ]; then break
			fi
		done
	fi
}
setconsolefontFunc() {
	local CONSOLEFONT ANS
	CONSOLEFONT=$(grep "FONT=" "/etc/vconsole.conf" | sed 's/FONT=//g')
	getfonts() {
		tree "/usr/share/kbd/consolefonts" --noreport -F |\
		sed -e 's/README//g' -e 's/ERRORS//g' | sed -e '1d;44d;239d'
	}
	echo -e "#\n# console font: $CONSOLEFONT\n#"
	echo -e "# configure console font?\n#"
	read -p "# ▸ " ANS
	if [[ "$ANS" =~ ^(1|y|ya|ye|ta|ok|pl|th).* ]]; then
		while true; do
			echo -e "#\n# (l) list fonts\n# (e) enter font\n# (c) cancel\n#"
			read -p "# ▸ " ANS
			if [ "$ANS" == "l" ]; then getfonts | less
			elif [ "$ANS" == "e" ]; then
				echo -e "#\n# enter console font\n#"
				read -p "# ▸ " ANS
				if getfonts | grep "$ANS" >"/dev/null"; then
					setfont "$ANS" >"/dev/null" 2>&1
					sudo chown "$USER":"$USER" "/etc/vconsole.conf"
					sudo sed -i '/FONT=.*/d' "/etc/vconsole.conf"
					echo "FONT=$ANS" >>"/etc/vconsole.conf"
					sudo sed -i -e 's/.gz//g' -e 's/.psfu//g' -e 's/.psf//g' "/etc/vconsole.conf"
					sudo chown root:root "/etc/vconsole.conf"
					echo -e "#\n# console font set to $ANS" | sed -e 's/.gz//g' -e 's/.psfu//g' -e 's/.psf//g'
					persistFunc >"/dev/null" 2>&1; break
				fi
			elif [ "$ANS" == "c" ]; then break
			fi
		done
	fi
}
setkeymapFunc() {
	local KEYMAP ANS
	KEYMAP=$(localectl status | grep "VC Keymap" | sed 's/    VC Keymap://g')
	getkeymaps() {
		tree "/usr/share/kbd/keymaps" | sed "s/.map.gz//g"
	}
	echo -e "#\n# keymap: $KEYMAP\n#"
	echo -e "# configure keymap?\n#"
	read -p "# ▸ " ANS
	if [[ "$ANS" =~ ^(1|y|ya|ye|ta|ok|pl|th).* ]]; then
		while true; do
			echo -e "#\n# (l) list\n# (e) enter\n# (c) cancel\n#"
			read -p "# ▸ " ANS
			if [[ "$ANS" == "l" ]]; then getkeymaps | less
			elif [[ "$ANS" == "e" ]]; then
				echo -e "#\n# enter keymap\n#"
				read -p "# ▸ " ANS
				if getkeymaps | grep -q "$ANS"; then
					loadkeys "$ANS" >"/dev/null" 2>&1
					if ! grep "$ANS" "/etc/vconsole.conf"; then
						sudo chown "$USER":"$USER" "/etc/vconsole.conf"
						sudo sed -i "/KEYMAP=$KEYMAP/d" "/etc/vconsole.conf" >"/dev/null" 2>&1
						echo "KEYMAP=${ANS}" >>"/etc/vconsole.conf"
						sudo chown root:root "/etc/vconsole.conf"
						echo -e "#\n# keymap set to $ANS\n#"; break
					fi
					break
				else
					echo -e "#\n# ⚠ invalid keymap ⚠"
				fi
			elif [ "$ANS" == "c" ]; then break
			fi
		done
	fi
}
if [ -n "$1" ]; then "$1"
else
	setntpFunc
	sethostnameFunc
	setlocaleFunc
	settimezoneFunc
	setconsolefontFunc
	setkeymapFunc
fi
