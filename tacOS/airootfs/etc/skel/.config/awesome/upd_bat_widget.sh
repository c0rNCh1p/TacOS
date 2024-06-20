#!/bin/bash

WIDGET_FILE="$HOME/.config/awesome/lain/widget/bat.lua"
TARGET_FILE="$HOME/.config/awesome/lain/widget/bat.lua"

if [ -f "$WIDGET_FILE" ]; then
    cp "$WIDGET_FILE" "$TARGET_FILE"
    notify-send 'Success' "Custom bat.lua file copied to $TARGET_FILE"
else notify-send 'Error' "Custom bat.lua file not found at $WIDGET_FILE"
fi