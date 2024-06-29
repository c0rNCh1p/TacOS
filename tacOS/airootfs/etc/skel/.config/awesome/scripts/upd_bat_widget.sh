#!/bin/bash

FILES='/usr/share/lua/5.3/lain/widget/bat.lua'
SEARCH_PATTERN='local timeout     = args.timeout or 30'
REPLACE_PATTERN='local timeout     = args.timeout or 3'

# Iterate over each matching file
for FILE in $FILES; do
    if [ -f "$FILE" ]; then	grep -q "$SEARCH_PATTERN" "$FILE" &&
		sudo sed -i "s/$SEARCH_PATTERN/$REPLACE_PATTERN/" "$FILE" &&
		notify-send 'AwesomeWM' 'Timeout setting updated in bat.lua'
    else notify-send 'AwesomeWM' 'ERR: bat.lua file not found at $FILE'
    fi
done