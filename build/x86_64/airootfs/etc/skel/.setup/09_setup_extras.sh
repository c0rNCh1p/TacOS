#!/bin/bash
LOGFILE="$HOME/extras.log"
! test -e "$LOGFILE" && touch "$LOGFILE"

ALIENURL='https://sourceforge.net/projects/alien-pkg-convert/files/release/alien_8.95.tar.xz'
DUMMYURL='https://github.com/c0rNCh1p/dummy.git'
EGGROLLURL='https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest'
FABLAURL='https://github.com/openAVproductions/openAV-Fabla2.git'
GH0STYURL='https://github.com/c0rNCh1p/gh0sty.git'
MINIMAPURL='https://github.com/johnfactotum/gedit-restore-minimap.git'
SCUTTLEURL='https://github.com/c0rNCh1p/scuttle.git'

nottyOrNoice(){
	local NAUGHTYORNICE BTCHSIZE BATCH
	NAUGHTYORNICE=(
		'hexyl'
		'highlight'
		'hydra'
		'tor'
		'torsocks'
		'virtualbox-guest-utils'
		'wget'
		'wireshark-cli'
	)
	BTCHSIZE=9
	echo -e '|\n|~ Installing a doorknob\n|'
	for ((i=0; i < "${#NAUGHTYORNICE[@]}"; i += BTCHSIZE)); do
		BATCH=("${NAUGHTYORNICE[@]:i:BTCHSIZE}")
		sudo pacman -S --noconfirm --needed "${BATCH[@]}" || {
			for PKG in "${BATCH[@]}"; do
				echo -e "|\n|~ ⚠ Failed to install $PKG  ⚠\n|" | tee -a "$LOGFILE"
			done
		}
	done
	sudo pacman -Syu; sudo pacman -Fy; sleep 1
}

bldAURPkgs(){
	local AURPKGS BTCHSIZE BATCH
	AURPKGS=(
		'aview'
		'awesome-freedesktop-git'
		'awesome-themes-git'
		'bgrm-git'
		'deadbeef-plugin-statusnotifier-git'
		'die-plugins'
		'epson-inkjet-printer-escpr'
		'epson-inkjet-printer-escpr2'
		'gedit-dark-variant'
		'gedit-open-uri-context-menu-git'
		'lain-git'
		'material-black-colors-theme'
		'nemo-compare'
		'rig'
		'sl'
		'steamcmd'
		'unfatarians-studio'
	)
	BTCHSIZE=9
	echo -e "|\n|~ Installing AUR packages: ${#AURPKGS[@]}\n|"
	for ((i=0; i < "${#AURPKGS[@]}"; i += BTCHSIZE)); do
		BATCH=("${AURPKGS[@]:i:BTCHSIZE}")
		yay -S --noconfirm --needed --mflags --skipinteg "${BATCH[@]}" || {
			for PKG in "${BATCH[@]}"; do
				echo -e "|\n|~ ⚠ Failed to install $PKG  ⚠\n|" | tee -a "$LOGFILE"
			done
		}
	done
	yay; yay -Fy; sleep 1
}

bldDummy(){
	pullDummy(){
		git clone "$DUMMYURL"
		cd 'dummy' || return 1
		make install
	}
	echo -e '|\n|~ Building Dummy\n|'
	cd "$DATA" || cd "$HOME/.local/share/" || return 1
	if [ ! -d "$HOME/.local/share/dummy" ]; then pullDummy
	elif [ -d "$HOME/.local/share/dummy" ]; then sudo rm -r 'dummy'; pullDummy
	fi; cd || return 1
}

bldGh0sty(){
	pullGh0sty(){
		git clone "$GH0STYURL"
		cd 'gh0sty' || return 1
		chmod 764 'install.sh'
		./'install.sh'
	}	
	echo -e '|\n|~ Building Gh0sty\n|'
	cd "$DATA" || cd "$HOME/.local/share/" || return 1
	if [ ! -d "$HOME/.local/share/gh0sty" ]; then pullGh0sty
	elif [ -d "$HOME/.local/share/dummy" ]; then sudo rm -r 'gh0sty'; pullGh0sty
	fi; cd || return 1
}

bldScuttle(){
	pullScuttle(){
		git clone "$SCUTTLEURL"
		cd 'scuttle' || return 1
		chmod 764 'install.sh'
		./'install.sh'
	}
	echo -e '|\n|~ Building Scuttle\n|'
	cd "$DATA" || cd "$HOME/.local/share/" || return 1
	if [ ! -d "$HOME/.local/share/scuttle" ]; then pullScuttle
	elif [ -d "$HOME/.local/share/dummy" ]; then sudo rm -r 'scuttle'; pullScuttle
	fi; cd || return 1
}

bldFabla(){
	pullFabla(){
		git clone "$FABLAURL"
		cd 'openAV-Fabla2/' || return 1
		mkdir build; cd build || return 1
		cmake ..; make -j4
		sudo make install
	}
	echo -e '|\n|~ Building fabla2\n|'
	cd "$DATA" || cd "$HOME/.local/share/" || return 1
	if [[ ! -d "$FABLA_HOME" || -d "$HOME/.local/share/openAV-Fabla2" ]]; then pullFabla
	elif [[ -d "$FABLA_HOME" || -d "$HOME/.local/share/openAV-Fabla2" ]]; then
		cd "$FABLA_HOME" || cd "$HOME/.local/share/openAV-Fabla2" || return 1
		if [[ $(git diff 'origin/master') ]]; then 
			cd .. || return 1
			sudo rm -r 'openAV-Fabla2'; pullFabla
		fi
	fi; cd || return 1
}

bldGeditMinimap(){
	echo -e '|\n|~ Building Gedit Minimap\n|'
	cd "$DATA" || cd "$HOME/.local/share/" || return 1
	if [[ ! -d "$GEDIT_HOME/plugins" || -d "$HOME/.local/share/gedit/plugins" ]]; then 
		mkdir -p "$GEDIT_HOME/plugins" || mkdir -p "$HOME/.local/share/gedit/plugins"
	fi
	if [[ ! -d "$GEDIT_HOME/plugins/restore-minimap" || -d "$HOME/.local/share/gedit/plugins/restore-minimap" ]]; then
		cd "$GEDIT_HOME/plugins" || "$HOME/.local/share/gedit/plugins/restore-minimap" || return 1
		git clone "$MINIMAPURL" restore-minimap
	elif [[ -d "$GEDIT_HOME/plugins/restore-minimap" || -d "$HOME/.local/share/gedit/plugins/restore-minimap" ]]; then 
		cd "$GEDIT_HOME/plugins/restore-minimap" || "$HOME/.local/share/gedit/plugins/restore-minimap" || return 1
		if [[ $(git diff 'origin/master') ]]; then
			cd .. || return 1
			sudo rm -r 'restore-minimap'
			git clone "$MINIMAPURL" restore-minimap
		fi
	fi; cd || return 1
}

bldAlien(){
	pullAlien(){
		wget "$ALIENURL"
		tar -xvJf 'alien'*'.tar.xz'
		sudo rm 'alien'*'.tar.xz'
	}
	makeAlien(){
		cd "$ALIEN_HOME" || return 1
		perl 'Makefile.PL'; make
		sudo make install
		sudo cp '/bin/site_perl/alien' '/bin/alien'
	}
	echo -e '|\n|~ Building Alien Converter\n|'
	cd "$DATA" || cd "$HOME/.local/share/" || return 1
	if [ ! -d "$ALIEN_HOME" ]; then pullAlien; mv 'alien'* 'alien'; makeAlien
	elif [ -d "$ALIEN_HOME" ]; then pullAlien
		if [[ $(diff "$ALIEN_HOME" 'alien'*) ]]; then 
			sudo rm -r 'alien'; mv 'alien'* 'alien'; makeAlien
		else sudo rm -r alien*
		fi
	fi; cd || return 1
}

bldGloriousEggroll(){
	#set -euo pipefail
	echo -e '|\n|~ Building Glorious Eggroll\n|'
	if [[ ! -d '/tmp/proton-ge-custom' ]]; then
		rm -rf '/tmp/proton-ge-custom'
		mkdir -p '/tmp/proton-ge-custom'
	fi
	cd '/tmp/proton-ge-custom' || return 1
	curl -sLOJ "$(curl -s $EGGROLLURL | grep browser_download_url | cut -d\" -f4 | grep .tar.gz)"
	curl -sLOJ "$(curl -s $EGGROLLURL | grep browser_download_url | cut -d\" -f4 | grep .sha512sum)"
	sha512sum -c ./*'.sha512sum'
	mkdir -p "$HOME/.steam/root/compatibilitytools.d"
	tar -xf 'GE-Proton'*'.tar.gz' -C "$HOME/.steam/root/compatibilitytools.d/"
	echo 'All done :)'
}

sudo mv "$LOGFILE" '/var/log'
if [ -n "$1" ]; then "$1"
else
	nottyOrNoice
	bldAURPkgs
	bldDummy
	bldGh0sty
	bldScuttle
	bldFabla
	bldGeditMinimap
	bldAlien
	#bldGloriousEggroll
fi

unset ALIENURL DUMMYURL EGGROLLURL FABLAURL GH0STYURL LOGFILE MINIMAPURL SCUTTLEURL
