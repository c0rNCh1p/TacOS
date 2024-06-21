#!/bin/bash
#shellcheck disable=SC1091, SC2143
#100x
#                               _ )    \     __|  |  |  _ \   __|
#                               _ \   _ \  \__ \  __ |    /  (
#                              ___/ _/  _\ ____/ _| _| _|_\ \___|
#
#===================================================================================================
# - $HOME/.bashrc
#===================================================================================================
# - man -P 'less +79 +/INVOCATION' 'bash(1)'
# - $BROWSER https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
#===================================================================================================
# - [1] Initialize Shell
#===================================================================================================
mesg y  &>'/dev/null'
unicode_start  &>'/dev/null'

# Check if using a hypervisor and run vboxservice
ANARCHY="$HOME/.anarchy"
if [[ -f '/sys/hypervisor/uuid' ]]; then
    HYPEVISUID=$(cat '/sys/hypervisor/uuid')
    if [[ "$HYPEVISUID" != "00000000-0000-0000-0000-000000000000" ]]; then
        sed -i "s/#'vboxservice'/'vboxservice'/" "$ANARCHY/daemons"
    fi
fi

# Source files
ANARCHY_FILES=(
    "$ANARCHY/aliases" "$ANARCHY/cleanup" \
    "$ANARCHY/daemons" "$ANARCHY/insulter" \
    "$ANARCHY/mntmgr" "$ANARCHY/perso" \
    "$ANARCHY/speeddial" "$ANARCHY/variables" \
    '/usr/share/bash-completion/bash_completion'
)

for FILE in "${ANARCHY_FILES[@]}"; do
    if [ -f "$FILE" ]; then
        . "$FILE"
    fi
done

# Make scripts executable
[ -d "$HOME/.local/bin" ] &&
    find "$HOME/.local/bin" -type f ! -executable -exec chmod 764 {} + &>'/dev/null'
[ -f "$AWESOME_HOME/tog_*.sh" ] &&
    find "$AWESOME_HOME/" -name "tog_*.sh" -type f ! -executable -exec chmod 764 {} + &>'/dev/null'

# Enable terminal color support and customization
if [ "$USECOLOR" == 'true' ]; then
    if test -f '/etc/DIR_COLORS' && type -P dircolors &>'/dev/null'; then
        export LS_COLORS=''
        funkydirs(){
            '/usr/bin/dircolors' -b '/etc/DIR_COLORS' |\
            sed -e "s/LS_COLORS='//g" -e 's/export LS_COLORS//g' |\
            sed -e "s/.ucf-old=38;2;255;177;82;2:';/.ucf-old=38;2;255;177;82;2:/g" |\
            tr -d '[:space:]'
        }
        funkydirs > "$HOME/.dircolors"
        LS_COLORS=$(cat "$HOME/.dircolors")
    fi
fi

# Set the prompt command based on the terminal type
case "$TERM" in
    'alacritty' | 'ansi' | 'color-xterm' | 'con'* | 'cygwin' | 'dtterm' | 'dvtm'* | 'Eterm' |\
    'eterm-color' | 'fbterm' | 'gnome'* | 'hurd' | 'interix' | 'jfbterm' | 'konsole'* | 'kterm' |\
    'linux'* | 'mach'* | 'mlterm' | 'putty'* | 'rxvt'* | 'st'* | 'term'* | 'vt100' | 'xterm'*)
        PROMPT_COMMAND='nter_shot; echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"';;
    'screen'*)
        PROMPT_COMMAND='nter_shot; echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"';;
esac

# Set the prompt style based on user or root
if [[ "$EUID" == 0 || $(tty | grep '/dev/tty') ]]; then
    PS1='\[\e[01;31m\][\h\[\e[01;36m\] \W\[\e[01;31m\]]\$\[\e[00m\] '
else
    echo -e "$(tput bold)\e[38;2;162;226;2m$USER ⩜  $HOSTNAME"
    PS1='\[\e[38;2;162;226;2m\][\[\e[38;2;228;255;0;1m\]\W\[\e[38;2;162;226;2m\]]\$\[\e[00m\] '
fi

if command grep -q 'live' '/etc/group'; then
    if [ "$(tty)" == '/dev/tty1' ]; then
        echo -e "\n| The graphical environment is launched with 'startx'"
        echo -e "| after refreshing the shell with 'bash'. The installer"
        echo -e "| can be run with 'calamares'.\n|"
        echo -e "| If installing please run $HOME/.local/bin/01_run_all\n|"
        echo -e "| Before doing so, be sure to add the newly created"
        echo -e "| user to the sudoers file (root login required).\n|"
        echo -e '| Welcome to TacOS have fun!'
    fi
else
    sed -i -e '6s/^\(\s*\)#/\1/' -e '6s/^\(\s*\) /\1/' "$BIN/01_run_all" &>'/dev/null'
    sed -i -e '10s/^\(\s*\)#/\1/' -e '10s/^\(\s*\) /\1/' "$BIN/01_run_all" &>'/dev/null'
fi
#===================================================================================================
# - [2] Useful Functions
#===================================================================================================
nter_shot(){
    local PID
    (mpv --volume=30 --really-quiet "$ANARCHY/shot.wav" &>'/dev/null' &&
        PID=$? && kill -9 $PID &>'/dev/null' &)
}

reload(){
    mpv --volume=40 --really-quiet "$ANARCHY/reload.wav" &>'/dev/null'
    kill -9 "$(echo $$)" # kill parent
}

psgrep(){
    command pgrep "$@" &>'/dev/null' &&
        echo 'USR          PID     SID     GID  CPU  MEM RTM      STT  CMD'
        ps --forest -eo user,pid,sid,pgid,%cpu,%mem,time,stat,comm | grep --color=always -i "$@"
}