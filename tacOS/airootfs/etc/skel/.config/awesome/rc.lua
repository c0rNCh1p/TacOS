--[[ 100x
                             \  \ \      / __|   __|   _ \    \  |  __|
                            _ \  \ \ \  /  _|  \__ \  (   |  |\/ |  _|
                          _/  _\  \_/\_/  ___| ____/ \___/  _|  _| ___|

====================================================================================================

 Files:
 - Filepath: $HOME/.config/awesome/rc.lua
 - Licence: $HOME/.config/awesome/licence

====================================================================================================

 Resources:
 - API Module Docs: $BROWSER https://awesomewm.org/doc/api
 - API Script Docs: $BROWSER https://awesomewm.org/apidoc
 - Arch Wiki: $BROWSER https://wiki.archlinux.org/title/Awesome
 - Awesome Freedesktop Repo: $BROWSER https://github.com/lcpz/awesome-desktop
 - Awesome Lain Repo: $BROWSER https://github.com/lcpz/lain
 - Awesome Repo: $BROWSER https://github.com/awesomeWM/awesome
 - Awesome Streetturtle Repo: https://github.com/streetturtle/awesome-wm-widgets
 - Awesome Vicious Repo: $BROWSER https://github.com/vicious-widgets/vicious

====================================================================================================

 References:
 - Awesome-client Manpage: man -P 'less +3 +/DESCRIPTION' 'awesomerc(5)'
 - Awesome Manpage: man -P 'less +9 +/DESCRIPTION' 'awesome(1)'
 - Awesomerc Manpage: man -P 'less +3 +/SYNOPSIS' 'awesomerc(5)'

--================================================================================================]]
-- [1] Setup
--==================================================================================================

-- Libraries
local awful=require('awful', 'awful.util', 'awful.autofocus')
local beautiful=require('beautiful')
local desktop=require('desktop')
local dpi=require('beautiful.xresources').apply_dpi
local gears=require('gears')
local hotkeys_popup=require('awful.hotkeys_popup').widget
--local hotkeys_popup=require('awful.hotkeys_popup.keys') -- Default layout
local menubar=require('menubar')
local naughty=require('naughty')
local lain=require('lain')
local wibox=require('wibox')

-- Environment
local theme_file='/tacos.lua'
local home=os.getenv('HOME')
local config_dir=os.getenv('CONFIG') or home .. '/.config'
local awesome_dir=os.getenv('AWESOME_HOME') or config_dir .. '/awesome'
local configs_dir=awesome_dir .. '/configs'
local desktop_dir=awesome_dir .. '/desktop'
local scripts_dir=awesome_dir .. '/scripts'
local theme_dir=awesome_dir .. '/themes'
local icons_dir=theme_dir .. '/icons'
local lain_dir=awesome_dir .. '/lain'
local lain_layout_dir=lain_dir .. '/layout'
local lain_util_dir=lain_dir .. '/util'
local lain_widget_dir=lain_dir .. '/widget'
local lain_widget_contrib_dir=lain_widget_dir .. '/contrib'

-- Startup Errors
if awesome.startup_errors then naughty.notify({
	preset=naughty.config.presets.critical,
	title='Startup Error',
	text=awesome.startup_errors})
end

-- Runtime Errors
do local in_error=false
	awesome.connect_signal('debug::error', function(err)
		if in_error then return end
		in_error=true naughty.notify({
			preset=naughty.config.presets.critical,
			title='Runtime Error', text=tostring(err)})
		in_error=false
	end)
end

-- Key Variables
local alt='Mod1'
local ctl='Control'
local mod='Mod4'

-- Preset Clients
local browser=os.getenv('BROWSER') or 'firefox'
local editorgui=os.getenv('GRAPHICAL') or 'geany'
local filemanager=os.getenv('FILEMANAGER') or 'nemo'
local mailclient=os.getenv('MAILCLIENT') or 'thunderbird'
local securemsg=os.getenv('SECUREMSG') or 'telegram-desktop'
local terminal=os.getenv('TERMINAL') or 'terminator'

-- Basic Styling
local themes={'tacos'}
local num=themes[1]
local themedir=string.format('%s/.config/awesome/themes', home)
local iconsdir=string.format('%s/.config/awesome/themes/icons', home)
local choice=string.format('%s/%s.lua', themedir, num)
awful.spawn.with_shell('$HOME/.config/awesome/scripts/upd_bat_widget.sh')
awful.util.tagnames={' 1  ',  ' 2  ',  ' 3  ',  ' 4  ',  ' 5  ',  ' 6  ',  ' 7  ',  ' 8  ',  ' 9  '}
awful.util.terminal=terminal
beautiful.init(choice)
beautiful.font='Nimbus Mono PS Bold 9.5'
--beautiful.wallpaper='/path/wallpaper'
beautiful.notification_font='Nimbus Mono PS Bold 9.5'
naughty.config.defaults['icon_size']=100

-- Adjust Brightness
local brightness=1.0
local function adjustBrightness(inc)
	brightness=math.min(1.0, math.max(0.1, brightness+(inc*0.1)))
	awful.spawn.with_shell('xrandr --output HDMI-1 --brightness ' .. tostring(brightness))
	awful.spawn.with_shell('xrandr --output eDP-1 --brightness ' .. tostring(brightness))
end

--==================================================================================================
-- [2] Client Behaviour
--==================================================================================================

-- Window Layouts
awful.layout.layouts={
	--awful.layout.suit.corner.ne,
	--awful.layout.suit.corner.nw,
	--awful.layout.suit.corner.se,
	--awful.layout.suit.corner.sw,
	--lain.layout.cascade,
	--lain.layout.cascade.tile,
	--lain.layout.centerwork,
	--lain.layout.centerwork.horizontal,
	--lain.layout.termfair,
	--lain.layout.termfair.center
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.floating,
	awful.layout.suit.magnifier,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.tile,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.top,
}

-- Layout Specifics
--awful.layout.suit.tile.left.mirror=true
lain.layout.cascade.tile.extra_padding=dpi(5)
lain.layout.cascade.tile.ncol=2
lain.layout.cascade.tile.nmaster=5
lain.layout.cascade.tile.offset_x=dpi(2)
lain.layout.cascade.tile.offset_y=dpi(32)
lain.layout.termfair.center.ncol=1
lain.layout.termfair.center.nmaster=3
lain.layout.termfair.ncol=1
lain.layout.termfair.nmaster=3


-- Taglist Behaviour
awful.util.taglist_buttons=gears.table.join(
	awful.button({ }, 1, function(t) t:view_only() end), awful.button({mod}, 1,
	function(t) if client.focus then client.focus:move_to_tag(t) end end),
	awful.button({ }, 3, awful.tag.viewtoggle), awful.button({mod}, 3,
	function(t) if client.focus then client.focus:toggle_tag(t) end end),
	awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Tasklist Behaviour
awful.util.tasklist_buttons=gears.table.join(
	awful.button({ }, 1, function(c)
		if c == client.focus then c.minimized=true
		else c.minimized=false
			if not c:isvisible() and c.first_tag then c.first_tag:view_only() end
			client.focus=c c:raise()
		end
	end),
	awful.button({ }, 3, function() local instance=nil return
		function() if instance and instance.wibox.visible
			then instance:hide() instance=nil
			else instance=awful.menu.clients({theme={width=dpi(250)}})
			end
		end
	end),
	awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
	awful.button({ }, 5, function() awful.client.focus.byidx(-1) end)
)

-- Quake Terminal
dropdown=lain.util.quake({
  app='wezterm start',
  argname='--class %s',
  name='shittydropdown',
  height=0.5,
  followtag=true,
  visible=false
})

-- Awesome Menu
menu_icons={
	['Terminal']=iconsdir .. '/terminal.png',
	['Hotkeys']=iconsdir .. '/hotkeys.png',
	['Display']=iconsdir .. '/display.png',
	['Theme']=iconsdir .. '/theme.png',
	['Applications']=iconsdir .. '/applications.png',
	['Reload']=iconsdir .. '/logout.png',
	['Suspend']=iconsdir .. '/suspend.png',
	['Reboot']=iconsdir .. '/reboot.png',
	['Shutdown']=iconsdir .. '/shutdown.png'
}

-- Awesome Menu Behaviour
main_menu=awful.menu({
	items={
		{'Terminal', terminal, menu_icons['Terminal']},
		{'Hotkeys', function() return false, hotkeys_popup.show_help end, menu_icons['Hotkeys']},
		{'Display', 'arandr', menu_icons['Display']},
		{'Theme', 'lxappearance', menu_icons['Theme']},
		{'Applications',
			function()
				local c=client.focus
				if c then c.minimized=true end
				awful.spawn.easy_async(string.format('rofi -no-config -no-lazy-grab -show drun \
				-modi drun -theme ~/.config/awesome/configs/rofi.rasi',
				beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus),
				function() if c then c.minimized=false end end)
			end, menu_icons['Applications']},
		{'Reload', function() awesome.restart() end, menu_icons['Reload']},
		{'Suspend', 'systemctl suspend', menu_icons['Suspend']},
		{'Reboot', 'systemctl reboot', menu_icons['Reboot']},
		{'Shutdown', 'systemctl poweroff', menu_icons['Shutdown']}}}
)

-- Initialize Awesome Menu
menu_launcher=awful.widget.launcher({
	menu=main_menu,
	image=beautiful.awesome_icon,
})

-- Initialize System Tray (defined in theme.lua)
awful.screen.connect_for_each_screen(function(s)
	beautiful.at_screen_connect(s)
	s.systray=wibox.widget.systray()
	s.systray.visible=true
end)

--==================================================================================================
-- [3] Key Bindings
--==================================================================================================

-- Mouse Buttons for Top Menu
root.buttons(gears.table.join(
	awful.button({ }, 3, function() main_menu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev))
)

-- Global Key Bindings
globalkeys=gears.table.join(
	awful.key({mod}, 's', hotkeys_popup.show_help,
	{description='| Show Shortcuts\n', group='01 General'}),
	awful.key({alt, ctl}, 'r', awesome.restart,
	{description='| Reload Awesome\n', group='01 General'}),
	awful.key({mod}, 'x', function()
		awful.prompt.run{prompt='Lua Code: ',
		textbox=awful.screen.focused().promptbox.widget,
		exe_callback=awful.util.eval,
		history_path=awful.util.get_cache_dir() .. '/history_eval'}
	end,
	{description='| Lua Code Prompt\n', group='01 General'}),
	awful.key({mod}, 'F12', function() dropdown:toggle() end,
	{description='| Quake Terminal\n', group='01 General'}),
	awful.key({ctl, alt}, 'x', awesome.quit,
	{description='| Quit Awesome\n', group='01 General'}),
	awful.key({alt, 'Shift'}, 'p', function()
		awful.spawn.with_shell('flameshot gui')
	end,
	{description='| Area Select Screenshot	   \n', group='01 General'}),
	awful.key({mod, alt}, 'p', function()
		awful.spawn.with_shell('flameshot full')
	end,
	{description='| Whole Area Screenshot\n', group='01 General'}),
	awful.key({mod, alt}, 'Up', function()
		adjustBrightness(1)
	end,
	{description='| Increase Brightness\n', group='01 General'}),
	awful.key({mod, alt}, 'Down', function()
		adjustBrightness(-1)
	end,
	{description='| Decrease Brightness\n', group='01 General'}),
	awful.key({mod, 'Shift'}, 'F1', function()
		awful.spawn.with_shell("$HOME/.config/awesome/scripts/tog_picom.sh")
	end,
	{description='| Toggle Picom\n', group='01 General'}),
	awful.key({mod}, 'F5', function()
		awful.util.spawn('deadbeef --random')
	end,
	{description='| Deadbeef Random\n', group='01 General'}),
	awful.key({mod}, 'F7', function()
		awful.util.spawn('deadbeef --play-pause')
	end,
	{description='| Deadbeef Play Pause\n', group='01 General'}),
	awful.key({mod}, 'F8', function()
		awful.util.spawn('deadbeef --next')
	end,
	{description='| Deadbeef Next\n', group='01 General'}),
	awful.key({mod}, 'F6', function()
		awful.util.spawn('deadbeef --prev')
	end,
	{description='| Deadbeef Previous\n', group='01 General'}),
	awful.key({mod, alt}, 'k', function()
		awful.util.spawn('knotes')
	end,
	{description='| Take Notes (Knotes)\n', group='01 General'}),
	awful.key({mod, alt}, 'o', function()
		awful.util.spawn('obsidian')
	end,
	{description='| Take Notes (Obsidian)\n', group='01 General'}),
	awful.key({mod, alt}, 'e', function()
		awful.util.spawn('gedit --new-window')
	end,
	{description='| Take Notes (Gedit)\n', group='01 General'}),
	awful.key({mod, 'Shift'}, 'F2', function()
		awful.spawn.with_shell("$HOME/.config/awesome/tog_pulse.sh")
	end,
	{description='| Toggle Pulse\n', group='01 General'}),
	awful.key({mod}, 'w', function() main_menu:show() end,
	{description='| Main Menu\n', group='02 Menus'}),
	awful.key({mod}, 'z', function()
		awful.spawn(string.format("dmenu_run -i -nb '#000000' -nf '#c1e874' -sb '#2d454e'\
		-sf '#a9ff00' -fn NouveauIBM:pixelsize=16",
		beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
	end,
	{description='| Dmenu Prompt\n', group='02 Menus'}),
	awful.key({mod}, 'r', function()
		local c=client.focus
		if c then c.minimized=true end
		awful.spawn.easy_async(string.format('rofi -no-config -no-lazy-grab -show drun \
		-modi drun -theme ~/.config/awesome/configs/rofi.rasi',
		beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus),
		function() if c then c.minimized=false end end)
	end,
	{description='| Global Menu\n', group='02 Menus'}),
	awful.key({mod, alt}, 'd', function() awful.util.spawn('rofi -show drun') end,
	{description='| Rofi Prompt\n', group='02 Menus'}),
	awful.key({alt, mod}, 'r', function() awful.util.spawn('rofi-theme-selector') end,
	{description='| Rofi Theme Select\n', group='02 Menus'}),
	awful.key({mod}, 'p', function() menubar.utils.terminal=terminal menubar.show() end,
	{description='| Quick Run Menu\n', group='02 Menus'}),
	awful.key({mod}, 'Left', awful.tag.viewprev,
	{description='| Switch Workspace Left\n', group='05 Workspaces'}),
	awful.key({mod}, 'Right', awful.tag.viewnext,
	{description='| Switch Workspace Right\n', group='05 Workspaces'}),
	awful.key({mod}, 'Escape', awful.tag.history.restore,
	{description='| Previous Workspace\n\n', group='05 Workspaces'}),
	awful.key({mod, alt}, 'n', function() lain.util.add_tag() end,
	{description='| Add Workspace (Reload to Del)\n', group='05 Workspaces'}),
	awful.key({mod}, 'Tab', function()
		awful.client.focus.history.previous()
		if client.focus then client.focus:raise() end
	end,
	{description='| Cycle Focus Clients\n\n\n',
	group='03 Client'}),
	awful.key({mod}, 'j', function()
		awful.client.focus.global_bydirection('down')
		if client.focus then client.focus:raise() end
	end,
	{description='| Focus Clients from Bottom\n', group='03 Client'}),
	awful.key({mod}, 'k', function()
		awful.client.focus.global_bydirection('up')
		if client.focus then client.focus:raise() end
	end,
	{description='| Focus Clients from Top\n', group='03 Client'}),
	awful.key({mod}, 'h', function()
		awful.client.focus.global_bydirection('left')
		if client.focus then client.focus:raise() end
	end,
	{description='| Focus Clients from Left\n', group='03 Client'}),
	awful.key({mod}, 'l', function()
		awful.client.focus.global_bydirection('right')
		if client.focus then client.focus:raise() end
	end,
	{description='| Focus Clients from Right\n', group='03 Client'}),
	awful.key({mod, 'Shift'}, 'n', function()
		local c=awful.client.restore() if c then client.focus=c c:raise() end
	end,
	{description='| Restore Minimized Clients	   \n', group='03 Client'}),
	awful.key({mod, 'Shift'}, 'j', function()
		awful.client.swap.byidx(1)
	end,
	{description='| Swap Tiled Window Left\n', group='03 Client'}),
	awful.key({mod, 'Shift'}, 'k', function()
		awful.client.swap.byidx(-1)
	end,
	{description='| Swap Tiled Window Right\n', group='03 Client'}),
	awful.key({mod, 'Shift'}, 'h', function()
		awful.screen.focus_relative(1)
	end,
	{description='| Focus Next Tiled Window\n', group='03 Client'}),
	awful.key({mod, 'Shift'}, 'l', function()
		awful.screen.focus_relative(-1)
	end,
	{description='| Focus Last Tiled Window\n', group='03 Client'}),
	awful.key({alt, 'Shift'}, 'j', function()
		awful.tag.incmwfact(-0.05)
	end,
	{description='| Decrease Tile Width\n', group='03 Client'}),
	awful.key({alt, 'Shift'}, 'k', function()
		awful.tag.incmwfact(0.05)
	end,
	{description='| Increase Tile Width\n', group='03 Client'}),
	awful.key({mod}, 'Return', function()
		awful.util.spawn(terminal)
	end,
	{description='| Launch Terminal\n', group='04 Launchers'}),
	awful.key({mod}, 'i', function()
		awful.spawn.with_shell('inkscape')
	end,
	{description='| Launch Vector Editor\n', group='04 Launchers'}),
	awful.key({mod}, 'b', function()
		awful.util.spawn(browser)
	end,
	{description='| Launch Browser (Firefox)\n', group='04 Launchers'}),
	awful.key({mod}, 'e', function()
		awful.spawn.with_shell('geany --new-instance')
	end,
	{description='| Launch Graphical Editor\n', group='04 Launchers'}),
	awful.key({mod}, 'v', function()
		awful.spawn.with_shell('virtualbox')
	end,
	{description='| Launch Video Editor\n\n\n\n\n\n\n\n', group='04 Launchers'}),
	awful.key({mod, 'Shift'}, 'v', function()
		awful.spawn.with_shell('kdenlive')
	end,
	{description='| Launch Virtual Machine\n', group='04 Launchers'}),
	awful.key({mod}, 'f', function()
		awful.util.spawn(filemanager)
	end,
	{description='| Launch File Manager\n', group='04 Launchers'}),
	awful.key({mod}, 'F2', function()
		awful.spawn.with_shell('pavucontrol-qt')
	end,
	{description='| Launch Volume Control\n', group='04 Launchers'}),
	awful.key({mod}, 'F3', function()
		awful.spawn.with_shell('cadence --minimised &')
	end,
	{description='| Launch Audio Mixer\n', group='04 Launchers'}),
	awful.key({mod}, 'F4', function()
		awful.spawn.with_shell('nm-connection-editor')
	end,
	{description='| Launch Network Editor\n', group='04 Launchers'}),
	awful.key({mod}, 'F9', function()
		awful.util.spawn(mailclient)
	end,
	{description='| Launch Mail Client\n', group='04 Launchers'}),
	awful.key({mod}, 'F10', function()
		awful.spawn.with_shell('lxappearance')
	end,
	{description='| Launch Theme Client\n', group='04 Launchers'}),
	awful.key({mod}, 'F11', function()
		awful.spawn.with_shell('arandr')
	end,
	{description='| Launch Display Manager\n', group='04 Launchers'}),
	awful.key({mod}, 'F1', function()
		awful.spawn.with_shell('deadbeef')
	end,
	{description='| Launch Audio Client\n', group='04 Launchers'}),
	awful.key({mod}, 'g', function()
		awful.util.spawn('gimp')
	end,
	{description='| Launch Image Editor\n', group='04 Launchers'}),
	awful.key({mod}, 'o', function()
		awful.spawn.with_shell('loffice')
	end,
	{description='| Launch Office Client\n', group='04 Launchers'}),
	awful.key({mod}, 'c', function()
		awful.spawn.with_shell('galculator')
	end,
	{description='| Launch Calculator\n', group='04 Launchers'}),
	awful.key({mod, 'Shift'}, 'o', function()
		awful.spawn.with_shell('obs')
	end,
	{description='| Launch Desktop Recorder\n', group='04 Launchers'}),
	awful.key({mod, 'Shift'}, 'r', function()
		awful.spawn.with_shell('reaper -nosplash')
	end,
	{description='| Launch DAW (REAPER)\n', group='04 Launchers'}),
	awful.key({mod}, 'a', function()
		awful.spawn.with_shell('ardour8 -n')
	end,
	{description='| Launch DAW (Ardour)\n', group='04 Launchers'}),
	awful.key({mod}, 'd', function()
		awful.spawn.with_shell('Discord')
	end,
	{description='| Launch Video Chat\n', group='04 Launchers'}),
	awful.key({mod, 'Shift'}, 'p', function()
		awful.util.spawn(securemsg)
	end,
	{description='| Launch Private Messager   \n', group='04 Launchers'}),
	awful.key({mod, 'Shift'}, 's', function()
		awful.spawn.with_shell('steam-native')
	end,
	{description='| Launch Game Client\n', group='04 Launchers'}),
	awful.key({mod, 'Shift'}, 'b', function()
		awful.spawn.with_shell('blender')
	end,
	{description='| Launch 3D Editor\n', group='04 Launchers'}),
	awful.key({mod}, 't', function()
		awful.util.spawn('vivaldi-bin')
	end,
	{description='| Launch Browser (Vivaldi)\n', group='04 Launchers'}),
	awful.key({alt, ctl}, '=', function()
		for s in screen do
			s.wibox.visible=not s.wibox.visible
			if s.bottomwibox then s.bottomwibox.visible=not s.bottomwibox.visible end
		end
	end,
	{description='| Toggle Wibox Visibility\n', group='06 Layout'}),
	awful.key({alt, ctl}, '-', function()
		awful.screen.focused().systray.visible=not awful.screen.focused().systray.visible
	end,
	{description='| Toggle Systray Visibility\n', group='06 Layout'}),
	awful.key({alt, ctl}, 'h', function() lain.util.useless_gaps_resize(7) end,
	{description='| Increment Useless Gaps\n', group='06 Layout'}),
	awful.key({alt, ctl}, 'l', function() lain.util.useless_gaps_resize(-7) end,
	{description='| Decrement Useless Gaps\n', group='06 Layout'}),
	awful.key({alt, ctl}, 'j', function() awful.tag.incnmaster(1, nil, true) end,
	{description='| Increment Master Clients\n', group='06 Layout'}),
	awful.key({alt, ctl}, 'k', function() awful.tag.incnmaster(-1, nil, true) end,
	{description='| Decrement Master Clients\n', group='06 Layout'}),
	awful.key({mod}, 'space', function() awful.layout.inc(1) end,
	{description='| Select Next Layout\n', group='06 Layout'}),
	awful.key({mod, 'Shift'}, 'space', function() awful.layout.inc(-1) end,
	{description='| Select Previous Layout\n', group='06 Layout'})
)

-- Client Key Bindings
clientkeys=gears.table.join(
	awful.key({mod}, 'n', function(c) c.minimized=true end,
	{description='| Minimize Window\n', group='03 Client'}),
	awful.key({mod}, 'm', function(c) c.maximized=not c.maximized c:raise() end,
	{description='| Maximize Window\n', group='03 Client'}),
	awful.key({mod}, 'q', function(c) c:kill() end,
	{description='| Kill Windows\n', group='03 Client'}),
	awful.key({mod, 'Shift'}, 'm', lain.util.magnify_client,
	{description='| Magnify Focused Window\n', group='03 Client'}),
	awful.key({alt, 'Shift'}, 'space', awful.client.floating.toggle,
	{description='| Toggle Floating State\n', group='03 Client'}),
	awful.key({alt, 'Shift'}, 't', function(c) c.ontop=not c.ontop end,
	{description='| Toggle Sticky State\n', group='03 Client'}),
	awful.key({alt, 'Shift'}, 'm', function(c) c.fullscreen=not c.fullscreen c:raise() end,
	{description='| Toggle Fullscreen State\n', group='03 Client'})
)

-- Tag Selection
for i=1, 9 do local descr_view, descr_toggle, descr_move, descr_toggle_focus
	if i == 1 or i == 9 then
		descr_view={description='| Switch to Workspace\n', group='05 Workspaces'}
		descr_toggle={description='| Show Main Client from Workspace\n', group='05 Workspaces'}
		descr_move={description='| Throw Client to Workspace\n', group='05 Workspaces'}
		descr_toggle_focus={description='| Follow Client to Workspace\n', group='05 Workspaces'}
	end
	globalkeys=gears.table.join(globalkeys,
		awful.key({mod}, '#' .. i+9, function()
			screen=awful.screen.focused() local tag=screen.tags[i]
			if tag then tag:view_only() end
		end,
	descr_view),
	awful.key({alt, 'Shift'}, '#' .. i+9, function()
		screen=awful.screen.focused()
		local tag=screen.tags[i] if tag then awful.tag.viewtoggle(tag) end
	end,
	descr_toggle),
	awful.key({alt, ctl}, '#' .. i+9, function()
		if client.focus then local tag=client.focus.screen.tags[i]
			if tag then client.focus:move_to_tag(tag) tag:view_only() end
		end
	end,
	descr_move),
	awful.key({alt, mod}, '#' .. i+ 9, function()
		if client.focus then local tag=client.focus.screen.tags[i]
			if tag then client.focus:toggle_tag(tag) end
		end
	end, descr_toggle_focus))
end

-- Client Mouse Buttons
clientbuttons=gears.table.join(
	awful.button({ }, 1, function (c)
		c:emit_signal('request::activate', 'mouse_click', {raise=true})
	end),
	awful.button({mod}, 1, function(c)
		c:emit_signal('request::activate', 'mouse_click', {raise=true})
		awful.mouse.client.move(c)
	end),
	awful.button({mod}, 3, function(c)
		c:emit_signal('request::activate', 'mouse_click', {raise=true})
		awful.mouse.client.resize(c)
	end)
)

-- Initialize As Root Keys
root.keys(globalkeys)

--==================================================================================================
-- [4] Client Behaviour
--==================================================================================================

-- Client Rules
awful.rules.rules={
	-- Defaults
	{rule={}, properties={
		border_width=beautiful.border_width,
		border_color=beautiful.border_normal,
		focus=awful.client.focus.filter,
		raise=true,
		keys=clientkeys,
		buttons=clientbuttons,
		screen=awful.screen.preferred,
		placement=awful.placement.no_overlap+awful.placement.no_offscreen,
		size_hints_honor=true}},
	-- Terminator
	{rule={class='terminator'}, properties={
		floating=true, callback=function(c)
			awful.spawn.with_shell("notify-send 'Terminator set to floating'")
		end}},
	-- Htop -- Cant be identified by class or name
--	{rule={name='htop'}, properties={
--		tag=' 1  ', maximized=true, callback=function(c)
--			awful.spawn.with_shell("notify-send 'htop moved to tag 1'")
--		end}},
	-- Nemo
	{rule={class='nemo'}, properties={
		tag=' 2  ', maximized=true, callback=function(c)
			awful.spawn.with_shell("notify-send 'Nemo moved to tag 2'")
		end}},
	-- OBS
	{rule={class='obs'}, properties={
		tag=' 5  ', maximized=true, callback=function(c)
			awful.spawn.with_shell("notify-send 'OBS moved to tag 5'")
		end}},
	-- Obsidian
	{rule={class='obsidian'}, properties={
		tag=' 3  ', callback=function(c)
			awful.spawn.with_shell("notify-send 'Obsidian moved to tag 3'")
		end}},
	-- Geany -- Cant be identified by class or name without explanation
--	{rule={class='geany'}, properties={
--		tag=' 4  ', callback=function(c)
--			awful.spawn.with_shell("notify-send 'Geany moved to tag 4'")
--		end}},
	-- Steam
    {rule={class='steam'}, properties={
		tag=' 4  ', maximized=true, callback=function(c)
			awful.spawn.with_shell("notify-send 'Steam moved to tag 4'")
		end}},
	-- Telegram
	{rule={class='telegram-desktop'}, properties={
		tag=' 7  ', maximized=true, callback=function(c)
			awful.spawn.with_shell("notify-send 'Telegram moved to tag 7'")
		end}},
	-- Firefox
	{rule={class='firefox'}, properties={
		tag=' 8  ', maximized=true, callback=function(c)
			awful.spawn.with_shell("notify-send 'Firefox moved to tag 8'")
		end}},
	-- Discord
	{rule={class='discord'}, properties={
		tag=' 8  ', maximized=true, callback=function(c)
			awful.spawn.with_shell("notify-send 'Discord moved to tag 8'")
		end}},
	-- Thunderbird
	{rule={class='thunderbird'}, properties={
		tag=' 9  ', maximized=true, callback=function(c)
			awful.spawn.with_shell("notify-send 'Thunderbird moved to tag 9'")
		end}},
	-- Vivaldi
	{rule={class='vivaldi-stable'}, properties={
		tag=' 9  ', maximized=true, callback=function(c)
			awful.spawn.with_shell("notify-send 'Vivaldi moved to tag 9'")
		end}},
}

-- Client Management
client.connect_signal('manage', function(c)
	if awesome.startup and not c.size_hints.user_position
	and not c.size_hints.program_position then awful.placement.no_offscreen(c) end
end)

-- Enter Client
client.connect_signal('mouse::enter', function(c)
    c:emit_signal('request::activate', 'mouse_enter', {raise=false})
end)

-- Gain Focus
client.connect_signal('focus', function(c) c.border_color = beautiful.border_focus end)

-- Lose Focus
client.connect_signal('unfocus', function(c) c.border_color = beautiful.border_normal end)

--==================================================================================================
-- [5] Autostart Applications
--==================================================================================================

-- Execution Function
local function run(c)
	if not awesome.startup then
		awful.spawn.easy_async_with_shell(
		string.format('pgrep -f '%s'', c),
			function(stdout) if not stdout:match('%S') then awful.spawn(c) end end)
	else awful.spawn.easy_async_with_shell(string.format(
		"killall -9 '%s' >'/dev/null' 2>&1 & sleep 1; %s &", c, c))
	end
end

-- Startup List & Final
awful.spawn.with_shell('$HOME/.config/awesome/scripts/tog_pulse.sh')
awful.spawn.with_shell('$HOME/.config/awesome/scripts/upd_mpd_widget.sh')
cdnccmd='/usr/share/cadence/src/cadence.py --minimized'
run('pgrep -f "' .. cdnccmd .. '" | xargs kill -9 & sleep 1 & cadence --minimized') -- Temperamental
run('mpd --no-daemon')
run('knotes --skip-note')
run('volumeicon')
run('nm-applet')
run('pamac-tray')
run('picom -b --config "$HOME/.config/awesome/configs/picom.conf"')
run('setxwall')