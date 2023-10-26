#!/bin/bash
#shellcheck disable=SC1091
#shellcheck disable=SC2143

mesg y  &>'/dev/null'
unicode_start  &>'/dev/null'

readFiles(){
	highlight --out-format=ansi "$@" | bat
}

enterShot(){
	local PID
	(mpv --volume=30 --really-quiet "$HOME/.anarchy/shot.wav" &>'/dev/null' &&
		PID=$? && kill -9 $PID &>'/dev/null' &)
}

reload(){
	mpv --volume=40 --really-quiet "$HOME/.anarchy/reload.wav" &>'/dev/null'
	kill -9 $(echo "$$") #; kill -9 $(ps -o ppid= -p $$) # kill parent
}

psGrep(){
	command pgrep "$@" &>'/dev/null' &&
		echo 'USR          PID     SID     GID  CPU  MEM RTM      STT  CMD'
		ps --forest -eo user,pid,sid,pgid,%cpu,%mem,time,stat,comm | grep --color=always -i "$@"
}

[ -d "$HOME/.setup/" ] &&
	find "$HOME/.setup/" -type f ! -executable -exec chmod 764 {} + &>'/dev/null'
[ -d "$HOME/.local/bin" ] &&
	find "$HOME/.local/bin" -type f ! -executable -exec chmod 764 {} + &>'/dev/null'
[ -f "$HOME/.config/awesome/toggle_picom.sh" ] &&
	find "$HOME/.config/awesome/toggle_picom.sh" -type f ! -executable -exec chmod 764 {} + &>'/dev/null'
[ -f "$HOME/.config/awesome/toggle_pulse.sh" ] &&
	find "$HOME/.config/awesome/toggle_pulse.sh" -type f ! -executable -exec chmod 764 {} + &>'/dev/null'

if [[ -f '/sys/hypervisor/uuid' ]]; then
    HYPEVISUID=$(cat '/sys/hypervisor/uuid')
    if [[ "$HYPEVISUID" != "00000000-0000-0000-0000-000000000000" ]]; then
        sed -i "s/#'vboxservice'/'vboxservice'/" "$LOCAL/bin/daemons"
    fi
fi

[ -f "$HOME/.anarchy/aliases" ] && . "$HOME/.anarchy/aliases"
[ -f "$HOME/.anarchy/cleanup" ] && . "$HOME/.anarchy/cleanup"
[ -f "$HOME/.anarchy/daemons" ] && . "$HOME/.anarchy/daemons"
[ -f "$HOME/.anarchy/insulter" ] && . "$HOME/.anarchy/insulter"
[ -f "$HOME/.anarchy/mntmgr" ] && . "$HOME/.anarchy/mntmgr"
[ -f "$HOME/.anarchy/perso" ] && . "$HOME/.anarchy/perso"
[ -f "$HOME/.anarchy/variables" ] && . "$HOME/.anarchy/variables"
[ -r '/usr/share/bash-completion/bash_completion' ] && . '/usr/share/bash-completion/bash_completion'

if [ "$USECOLOR" == 'true' ]; then
	if test -f '/etc/DIR_COLORS' && type -P dircolors &>'/dev/null'; then
		export LS_COLORS=''
		funkydirs(){
			'/usr/bin/dircolors' -b '/etc/DIR_COLORS' |\
			sed -e "s/LS_COLORS='//g" -e 's/export LS_COLORS//g' |\
			sed -e "s/.ucf-old=38;2;255;177;82;2:';/.ucf-old=38;2;255;177;82;2:/g" | tr -d '[:space:]'
		}
		funkydirs > "$HOME/.dircolors"
		export LS_COLORS=$(cat "$HOME/.dircolors")
	fi
fi

case "$TERM" in
	'alacritty' | 'ansi' | 'color-xterm' | 'con'* | 'cygwin' | 'dtterm' | 'dvtm'* | 'Eterm' |\
	'eterm-color' |	'fbterm' | 'gnome'* | 'hurd' | 'interix' | 'jfbterm' | 'konsole'* | 'kterm' |\
	'linux'* | 'mach'* | 'mlterm' |	'putty'* | 'rxvt'* | 'st'* | 'term'* | 'vt100' | 'xterm'*)
		PROMPT_COMMAND='enterShot; echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"';;
	'screen'*)
		PROMPT_COMMAND='enterShot; echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"';;
esac

if [[ "$EUID" == 0 || $(tty | grep '/dev/tty') ]]; then
	PS1='\[\e[01;31m\][\h\[\e[01;36m\] \W\[\e[01;31m\]]\$\[\e[00m\] '
else
	echo -e "$(tput bold)\e[38;2;154;255;0;2m$USER ⩜  $HOSTNAME"
	PS1='\[\e[38;2;154;255;0;1m\][\[\e[38;2;255;255;60;1m\]\W\[\e[38;2;154;255;0;2m\]]\$\[\e[00m\] '
fi

if command grep -q 'live' '/etc/group'; then
	if [ $(tty) == '/dev/tty1' ]; then
		echo -e "\n| The graphical environment is launched with 'startx'"
		echo -e "| the installer can be run with 'calamares'\n|"
		echo -e "| If installing please go to the '\$HOME/.setup' folder"
		echo -e "| when finished and run ./'01_setup_all.sh'\n|"
		echo -e "| Before doing so, be sure too add the newly created"
		echo -e "| user to the sudoers file (root login required).\n|"
		echo -e "| For server users, just use the Arch install scripts"
		echo -e "| or do it the Arch way.\n|"
		echo -e '| Welcome to tacOS have fun!'
	fi
else
	sed -i -e '7s/^\(\s*\)#/\1/' -e '7s/^\(\s*\) /\1/' "$HOME/.setup/01_setup_all.sh" &>'/dev/null'
	sed -i -e '10s/^\(\s*\)#/\1/' -e '10s/^\(\s*\) /\1/' "$HOME/.setup/01_setup_all.sh" &>'/dev/null'
fi

