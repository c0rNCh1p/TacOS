#!/bin/bash
#shellcheck disable=SC1091
#shellcheck disable=SC2143

if [ "$(tty)" == "/dev/tty1" ]; then
	cmdline_func() {
		local PARAM
		for PARAM in $(</proc/cmdline); do
			case "$PARAM" in
				SCRIPT=*) echo "${PARAM#*=}"; return 0;;
			esac
		done
	}
	SCRIPT="$(cmdline_func)"
	if [ -n "$SCRIPT" ]; then
		if [[ "$SCRIPT" =~ ^(http|https|ftp):// ]]; then
			printf '%s: waiting for network-online.target\n' "$0"
			until systemctl --quiet is-active network-online.target; do
				sleep 1
			done
			printf '%s: downloading %s\n' "$0" "$SCRIPT"
			curl "$SCRIPT" --location --retry-connrefused --retry 10 -s -o "/tmp/startup-params"
			RT=$?
		else
			cp "$SCRIPT" "/tmp/startup-params"
			RT=$?
		fi
		if [ "$RT" -eq 0 ]; then
			if ! test -x "/tmp/startup-params"; then
				chmod 764 "/tmp/startup-params"
			fi	
		fi
	fi
	unset SCRIPT
	unset RT
fi

mesg y >"/dev/null" 2>&1
unicode_start >"/dev/null" 2>&1

[ -f "$HOME/.anarchy/aliases" ] && . "$HOME/.anarchy/aliases"
[ -f "$HOME/.anarchy/cleanup" ] && . "$HOME/.anarchy/cleanup"
[ -f "$HOME/.anarchy/insulter" ] && . "$HOME/.anarchy/insulter"
[ -f "$HOME/.anarchy/variables" ] && . "$HOME/.anarchy/variables"
[ -f "$HOME/.local/bin/daemons" ] && . "$HOME/.local/bin/daemons"
[ -r "/usr/share/bash-completion/bash_completion" ] &&
. "/usr/share/bash-completion/bash_completion"

case "$TERM" in
	"alacritty" | "ansi" | "color-xterm" | "con"* | "cygwin" | "dtterm" | "dvtm"* | "Eterm" |\
	"eterm-color" |	"fbterm" | "gnome"* | "hurd" | "interix" | "jfbterm" | "konsole"* | "kterm" |\
	"linux"* | "mach"* | "mlterm" |	"putty"* | "rxvt"* | "st"* | "term"* | "vt100" | "xterm"*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"';;
	"screen"*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"';;
esac

if [ "$USECOLOR" == "true" ]; then
	if test -f "/etc/DIR_COLORS" && type -P dircolors >"/dev/null" 2>&1; then
		export LS_COLORS=""
		funkydirs() {
			"/usr/bin/dircolors" -b "/etc/DIR_COLORS" |\
			sed -e "s/LS_COLORS='//g" -e 's/export LS_COLORS//g' |\
			sed -e "s/.ucf-old=38;2;255;177;82;2:';/.ucf-old=38;2;255;177;82;2:/g" |\
			tr -d '[:space:]'
		}
		funkydirs > "$HOME/.dircolors"
		export LS_COLORS=$(cat "$HOME/.dircolors")
	fi
fi

if [[ "$EUID" == 0 || $(tty | grep '/dev/tty') ]]; then
	PS1='\[\e[01;31m\][\h\[\e[01;36m\] \W\[\e[01;31m\]]\$\[\e[00m\] '
else
	echo -e "$(tput bold)\e[38;2;162;226;2m$USER ⩜  $HOSTNAME"
	PS1='\[\e[38;2;162;226;2m\][\[\e[38;2;228;255;0;1m\]\W\[\e[38;2;162;226;2m\]]\$\[\e[00m\] '
fi
