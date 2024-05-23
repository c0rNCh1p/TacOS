#!/bin/bash
#shellcheck disable=SC2002
DATE=$(date +'%d-%m-%y-%H')
CONFFILE="settings-dump-$DATE.ini"
CONFDIR="$HOME/.config/dconf/settings/"
gsettingsFunc(){
	gsettings set org.blueberry use-symbolic-icons false
	gsettings set org.gnome.desktop.background picture-uri-dark\
	'file:///usr/share/backgrounds/arcolinux-dual/dragon.jpg'
	gsettings set org.gnome.desktop.screensaver lock-enabled false
	gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
	gsettings set org.gnome.FontManager prefer-dark-theme true
	gsettings set org.gnome.FontManager enable-animations true
	gsettings set org.gnome.gedit.plugins.filebrowser open-at-first-doc false
	gsettings set org.gnome.gedit.plugins.time custom-format '%d/%m/%y'
	gsettings set org.gnome.gedit.preferences.editor display-right-margin true
	gsettings set org.gnome.gedit.preferences.editor highlight-current-line false
	#gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion'
	gsettings set org.gnome.gedit.preferences.editor tabs-size 4
	gsettings set org.gnome.gedit.preferences.editor wrap-last-split-mode 'char'
	gsettings set org.gnome.gedit.preferences.editor wrap-mode 'char'
	gsettings set org.gnome.gedit.preferences.ui bottom-panel-visible 'true'
	gsettings set org.gnome.gedit.preferences.ui statusbar-visible 'true'
	gsettings set org.gnome.gedit.state.window bottom-panel-active-page 'GeditTerminalPanel'
	gsettings set org.gnome.gedit.state.window side-panel-active-page 'GeditFileBrowserPanel'
	gsettings set org.gnome.meld highlight-syntax true
	gsettings set org.gnome.meld indent-width 4
	gsettings set org.gnome.meld prefer-dark-theme true
	gsettings set org.gnome.meld show-line-numbers true
	gsettings set org.nemo.extensions.nemo-terminal audible-bell false
	gsettings set org.nemo.extensions.nemo-terminal default-follow-mode 'None'
	gsettings set org.nemo.extensions.nemo-terminal default-visible true
	gsettings set org.nemo.extensions.nemo-terminal terminal-position 'bottom'
	gsettings set org.nemo.icon-view default-zoom-level 'large'
	gsettings set org.nemo.list-view default-zoom-level 'small'
	gsettings set org.nemo.preferences bulk-rename-tool 'b"bulky"'
	gsettings set org.nemo.preferences close-device-view-on-device-eject true
	gsettings set org.nemo.preferences date-format 'iso'
	gsettings set org.nemo.preferences default-folder-viewer 'list-view'
	gsettings set org.nemo.preferences inherit-show-thumbnails false
	gsettings set org.nemo.preferences show-bookmarks-in-to-menus false
	gsettings set org.nemo.preferences show-computer-icon-toolbar true
	gsettings set org.nemo.preferences show-directory-item-counts 'always'
	gsettings set org.nemo.preferences show-full-path-titles true
	gsettings set org.nemo.preferences show-home-icon-toolbar true
	gsettings set org.nemo.preferences show-image-thumbnails 'always'
	gsettings set org.nemo.preferences show-new-folder-icon-toolbar true
	gsettings set org.nemo.preferences show-open-in-terminal-toolbar true
	gsettings set org.nemo.preferences show-reload-icon-toolbar true
	gsettings set org.nemo.preferences show-show-thumbnails-toolbar true
	gsettings set org.nemo.preferences sort-favorites-first false
	gsettings set org.nemo.preferences swap-trash-delete true
	gsettings set org.nemo.preferences thumbnail-limit 2147483648
	gsettings set org.nemo.preferences tooltips-in-icon-view true
	gsettings set org.nemo.preferences tooltips-in-list-view true
	gsettings set org.nemo.preferences tooltips-show-birth-date true
	gsettings set org.nemo.preferences tooltips-show-file-type true
	gsettings set org.nemo.preferences tooltips-show-path true
	#gsettings set org.nemo.preferences treat-root-as-normal true
	gsettings set org.nemo.preferences.menu-config selection-menu-copy-to true
	gsettings set org.nemo.preferences.menu-config selection-menu-duplicate true
	gsettings set org.nemo.preferences.menu-config selection-menu-make-link true
	gsettings set org.nemo.preferences.menu-config selection-menu-move-to true
	gsettings set org.nemo.window-state sidebar-bookmark-breakpoint 0
	gsettings set org.nemo.window-state start-with-sidebar true
}
[ ! -d "$CONFDIR" ] && mkdir -p "$CONFDIR"
dconf reset -f / || rm -f "$HOME/.config/dconf/user"
gsettingsFunc >'/dev/null' 2>&1
dconf dump / >"$CONFFILE"
cat "$CONFFILE" | dconf load /
mv "$CONFFILE" "$CONFDIR"
sudo find "/home/$USER" -type f -empty -delete
unset CONFDIR CONFFILE DATE

