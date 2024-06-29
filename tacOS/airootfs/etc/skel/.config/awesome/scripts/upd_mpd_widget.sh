#!/bin/bash

FIFO='/tmp/mpd.fifo'
MPD_HOST='127.0.0.1'
MPD_PORT='6600'
INTERVAL=5 # Set check timeout to 5

# Check if audio is playing in browser
is_audio_playing(){
	pactl list sink-inputs | grep -q "application.name = \"Vivaldi\""
}

update_widget_file(){
	# Get the browser window title
	BROWSER_WINDOW=$(xdotool search --onlyvisible --class vivaldi | head -n 1)
	BROWSER_TITLE=$(xdotool getwindowname "$BROWSER_WINDOW")
	# Parse info, assumes title format is Artist - Title - YouTube'
	ARTIST=$(echo "$BROWSER_TITLE" | sed -n 's/ - YouTube$//;s/ - /|/;s/|.*//p')
	TITLE=$(echo "$BROWSER_TITLE" | sed -n 's/ - YouTube$//;s/.* - //p')
	# Handle metadata extraction errors
	[[ -z "$TITLE" || -z "$ARTIST" ]] && echo 'Failed to extract metadata' && return 1
	# Update metadata file for widget
	echo "$ARTIST - $TITLE" >"$HOME/.config/awesome/scripts/mpd_current.txt"
}

# Monitor and update periodically
while true; do
	if is_audio_playing; then update_widget_file
	else echo '-' >"$HOME/.config/awesome/scripts/mpd_current.txt"
	fi; sleep "$INTERVAL"
done