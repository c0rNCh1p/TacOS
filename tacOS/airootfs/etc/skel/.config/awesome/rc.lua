--[[                         \  \ \      / __|   __|   _ \    \  |  __|
                            _ \  \ \ \  /  _|  \__ \  (   |  |\/ |  _|
                          _/  _\  \_/\_/  ___| ____/ \___/  _|  _| ___|
----------------------------------------------------------------------------------------------------
 ▸ $XDG_CONFIG_HOME/awesome/rc.lua
----------------------------------------------------------------------------------------------------
 ▸ man 'awesome(1)' | less +/DESCRIPTION
 ▸ man 'awesomerc(5)' | less +/DESCRIPTION
 ▸ $BROWSER 'https://awesomewm.org/doc/api/sample%20files/rc.lua.html'
----------------------------------------------------------------------------------------------------
 1 REQUIRED LIBRARIES
------------------------------------------------------------------------------------------------]]--

local gears=require('gears')
local awful=require('awful')
require('awful.autofocus')
local wibox=require('wibox')
local beautiful=require('beautiful')
local naughty=require('naughty')
naughty.config.defaults['icon_size']=100
local menubar=require('menubar')
local lain=require('lain')
local freedesktop=require('freedesktop')
local hotkeys_popup=require('awful.hotkeys_popup').widget
--require('awful.hotkeys_popup.keys')
local dpi=require('beautiful.xresources').apply_dpi
--local vicious=require('vicious')

--[[------------------------------------------------------------------------------------------------
 2 ERROR HANDLING
------------------------------------------------------------------------------------------------]]--

-- startup errors
if awesome.startup_errors then
	naughty.notify({
		preset=naughty.config.presets.critical,
		title='⚠ Startup error ⚠',
		text=awesome.startup_errors})
end

-- runtime errors
do
	local in_error=false
	awesome.connect_signal('debug::error', function(err)
		if in_error then
			return
		end
		in_error=true
		naughty.notify({
			preset=naughty.config.presets.critical,
			title='⚠ runtime error ⚠',
			text=tostring(err)})
		in_error=false
	end)
end

--[[------------------------------------------------------------------------------------------------
 3 AWESOME ENVIRONMENT
------------------------------------------------------------------------------------------------]]--

local modkey='Mod4'
local altkey='Mod1'
local ctlkey='Control'
local home=os.getenv('HOME')

-- Preset clients
local browser=os.getenv('BROWSER') or 'firefox'
local editorgui=os.getenv('GRAPHICAL') or 'gedit'
local filemanager=os.getenv('FILEMANAGER') or 'nemo'
local mailclient=os.getenv('MAILCLIENT') or 'thunderbird'
local terminal=os.getenv('TERMINAL') or 'terminator'
awful.util.terminal=terminal

-- basic styling
local themes={'tacOS'}
local num=themes[1]
awful.util.tagnames={' 1 ',  ' 2 ',  ' 3 ',  ' 4 ',  ' 5 ',  ' 6 ',  ' 7 ',  ' 8 ',  ' 9 '}
local themedir=string.format('%s/.config/awesome/themes/%s', home, num)
local iconsdir=string.format('%s/.config/awesome/themes/%s/icons', home, num)
local choice=string.format('%s/theme.lua', themedir)
beautiful.init(choice)
--beautiful.wallpaper='/path/to/wallpaper'
beautiful.font='Nouveau IBM Regular 9.5'
beautiful.notification_font='Nouveau IBM Bold 9.5'

-- adjust brightness
local brightness=1.0
local function adjustBrightness(inc)
    brightness=math.min(1.0, math.max(0.1, brightness + (inc * 0.1)))
    awful.spawn.with_shell('xrandr --output HDMI-1 --brightness ' .. tostring(brightness))
    awful.spawn.with_shell('xrandr --output eDP-1 --brightness ' .. tostring(brightness))
end

-- window layouts
awful.layout.layouts={
	awful.layout.suit.tile,
	awful.layout.suit.floating,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	--awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier,
	--awful.layout.suit.corner.nw,
	--awful.layout.suit.corner.ne,
	--awful.layout.suit.corner.sw,
	--awful.layout.suit.corner.se,
	--lain.layout.cascade,
	--lain.layout.cascade.tile,
	--lain.layout.centerwork,
	--lain.layout.centerwork.horizontal,
	--lain.layout.termfair,
	--lain.layout.termfair.center
}

-- fine tune layouts
lain.layout.termfair.nmaster=3
lain.layout.termfair.ncol=1
lain.layout.termfair.center.nmaster=3
lain.layout.termfair.center.ncol=1
lain.layout.cascade.tile.offset_x=dpi(2)
lain.layout.cascade.tile.offset_y=dpi(32)
lain.layout.cascade.tile.extra_padding=dpi(5)
lain.layout.cascade.tile.nmaster=5
lain.layout.cascade.tile.ncol=2
--awful.layout.suit.tile.left.mirror=true

--[[------------------------------------------------------------------------------------------------
 4 MENU BEHAVIOUR
------------------------------------------------------------------------------------------------]]--

-- taglist behaviour
awful.util.taglist_buttons=gears.table.join(
	awful.button({ }, 1, function(t)
		t:view_only()
	end),
	awful.button({modkey}, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({modkey}, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({ }, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({ }, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

-- tasklist behaviour
awful.util.tasklist_buttons=gears.table.join(
	awful.button({ }, 1, function(c)
		if c == client.focus then
			c.minimized=true
		else
			c.minimized=false
			if not c:isvisible() and c.first_tag then
				c.first_tag:view_only()
			end
			client.focus=c
			c:raise()
		end
	end),
	awful.button({ }, 3, function()
		local instance=nil
		return function()
			if instance and instance.wibox.visible then
				instance:hide()
				instance=nil
			else
				instance=awful.menu.clients({
				theme={width=dpi(250)}})
			end
		end
	end),
	awful.button({ }, 4, function()
	awful.client.focus.byidx(1)
	end),
	awful.button({ }, 5, function()
	awful.client.focus.byidx(-1)
	end)
)

-- system menu
menu_icons={
	['Terminal']=iconsdir .. '/terminal.png',
	['Hotkeys']=iconsdir .. '/hotkeys.png',
	['Display']=iconsdir .. '/display.png',
	['Theme']=iconsdir .. '/theme.png',
	['Applications']=iconsdir .. '/applications.png',
	['Logout']=iconsdir .. '/logout.png',
	['Suspend']=iconsdir .. '/suspend.png',
	['Reboot']=iconsdir .. '/reboot.png',
	['Shutdown']=iconsdir .. '/shutdown.png'}
main_menu=awful.menu({
	items={
	{' Terminal', terminal, menu_icons['Terminal']},
	{' Hotkeys', function()
		return false, hotkeys_popup.show_help
	end,
	menu_icons['Hotkeys']},
	{' Display', 'arandr', menu_icons['Display']},
	{' Theme', 'lxappearance', menu_icons['Theme']},
	{' Applications', 'rofi -no-config -no-lazy-grab -show drun -modi drun\
	-theme ~/.config/awesome/rofi/launcher2.rasi', menu_icons['Applications']},
		{' Logout', function()
		awesome.quit()
		end,
		menu_icons['Logout']},
		{' Suspend', 'systemctl suspend', menu_icons['Suspend']},
		{' Reboot', 'systemctl reboot', menu_icons['Reboot']},
		{' Shutdown', 'systemctl poweroff', menu_icons['Shutdown']}}}
)

-- initialize system menu
menu_launcher=awful.widget.launcher({
	menu=main_menu,
	image=beautiful.awesome_icon,
})

-- initialize system tray (defined in theme.lua)
awful.screen.connect_for_each_screen(function(s)
	beautiful.at_screen_connect(s)
		s.systray=wibox.widget.systray()
		s.systray.visible=true
end)

--[[------------------------------------------------------------------------------------------------
 7 KEY BINDINGS
------------------------------------------------------------------------------------------------]]--

-- mouse buttons for top menu
root.buttons(gears.table.join(
	awful.button({ }, 3, function()
		main_menu:toggle()
	end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev))
)

-- global key bindings
globalkeys=gears.table.join(
	awful.key({modkey}, 's', hotkeys_popup.show_help,
	{description='| Show Shortcuts\n', group='01 General'}),
	awful.key({altkey, ctlkey}, 'r', awesome.restart,
	{description='| Reload Awesome\n', group='01 General'}),
	awful.key({modkey}, 'x', function()
		awful.prompt.run{prompt='Lua Code: ',
		textbox=awful.screen.focused().mypromptbox.widget,
		exe_callback=awful.util.eval,
		history_path=awful.util.get_cache_dir() .. '/history_eval'}
	end,
	{description='| Lua Code Prompt\n', group='01 General'}),
	awful.key({ctlkey, altkey}, 'x', awesome.quit,
	{description='| Quit Awesome\n', group='01 General'}),
	awful.key({altkey, 'Shift'}, 'Print', function()
		awful.util.spawn('gnome-screenshot -a')
	end,
	{description='| Area Select Screenshot\n', group='01 General'}),
	awful.key({modkey, altkey}, 'Print', function()
		awful.util.spawn('gnome-screenshot')
	end,
	{description='| Whole Area Screenshot\n', group='01 General'}),
	awful.key({modkey, altkey}, 'Up', function()
		adjustBrightness(1)
	end,
	{description='| Increase Brightness\n', group='01 General'}),
	awful.key({modkey, altkey}, 'Down', function()
		adjustBrightness(-1)
	end,
	{description='| Decrease Brightness\n', group='01 General'}),
	awful.key({modkey, 'Shift'}, 'F1', function()
		awful.spawn.with_shell("$HOME/.config/awesome/toggle_picom.sh")
	end,
	{description='| Toggle Picom\n', group='01 General'}),
	awful.key({modkey}, 'F5', function()
		awful.util.spawn('deadbeef --random')
	end,
	{description='| Deadbeef Random\n', group='01 General'}),
	awful.key({modkey}, 'F7', function()
		awful.util.spawn('deadbeef --play-pause')
	end,
	{description='| Deadbeef Play Pause\n', group='01 General'}),
	awful.key({modkey}, 'F8', function()
		awful.util.spawn('deadbeef --next')
	end,
	{description='| Deadbeef Next\n', group='01 General'}),
	awful.key({modkey}, 'F6', function()
		awful.util.spawn('deadbeef --prev')
	end,
	{description='| Deadbeef Previous\n', group='01 General'}),
	awful.key({modkey, 'Shift'}, 'F2', function()
		awful.spawn.with_shell("$HOME/.config/awesome/toggle_pulse.sh")
	end,
	{description='| Toggle Pulse\n', group='01 General'}),	
	awful.key({modkey}, 'w', function()
		main_menu:show()
	end,
	{description='| Main Menu\n', group='02 Menus'}),
	awful.key({modkey}, 'z', function()
		awful.spawn(string.format("dmenu_run -i -nb '#000000' -nf '#a7c260' -sb '#474f5c'\
		-sf '#c8ff3a' -fn NouveauIBM:pixelsize=16",
		beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
	end,
	{description='| Dmenu Prompt\n', group='02 Menus'}),
	awful.key({modkey}, 'r', function()
		local c=client.focus
		if c then
			c.minimized=true
			awful.spawn.easy_async(string.format('rofi -no-config -no-lazy-grab -show drun \
			-modi drun -theme ~/.config/awesome/rofi/launcher2.rasi',
			beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus),
			function()
				c.minimized=false
			end)
		end
	end,
	{description = '| Global Menu\n', group='02 Menus'}),
	awful.key({modkey, altkey}, 'd', function()
		awful.util.spawn('rofi -show drun')
	end,
	{description='| Rofi Prompt\n', group='02 Menus'}),
	awful.key({altkey, modkey}, 'r', function()
		awful.util.spawn('rofi-theme-selector')
	end,
	{description='| Rofi Theme Select\n', group='02 Menus'}),
	awful.key({modkey}, 'p', function()
		menubar.utils.terminal=terminal
		menubar.show()
	end,
	{description='| Quick Run Menu\n', group='02 Menus'}),
	awful.key({modkey}, 'Left', awful.tag.viewprev,
	{description='| Switch Workspace Left\n', group='05 Workspaces'}),
	awful.key({modkey}, 'Right', awful.tag.viewnext,
	{description='| Switch Workspace Right\n', group='05 Workspaces'}),
	awful.key({modkey}, 'Escape', awful.tag.history.restore,
	{description='| Previous Workspace\n\n', group='05 Workspaces'}),
	awful.key({modkey, altkey}, 'n', function()
		lain.util.add_tag()
	end,
	{description='| Add Workspace (Reload to Del)\n', group='05 Workspaces'}),
	awful.key({modkey}, 'Tab', function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end,
	{description='| Cycle Focus Clients\n\n\n',
	group='03 Client'}),
	awful.key({modkey}, 'j', function()
		awful.client.focus.global_bydirection('down')
		if client.focus then
			client.focus:raise()
		end
	end,
	{description='| Focus Clients from Bottom\n', group='03 Client'}),
	awful.key({modkey}, 'k', function()
		awful.client.focus.global_bydirection('up')
		if client.focus then
			client.focus:raise()
		end
	end,
	{description='| Focus Clients from Top\n', group='03 Client'}),
	awful.key({modkey}, 'h', function()
		awful.client.focus.global_bydirection('left')
		if client.focus then
			client.focus:raise()
		end
	end,
	{description='| Focus Clients from Left\n', group='03 Client'}),
	awful.key({modkey}, 'l', function()
		awful.client.focus.global_bydirection('right')
		if client.focus then
			client.focus:raise()
		end
	end,
	{description='| Focus Clients from Right\n', group='03 Client'}),
	awful.key({modkey, 'Shift'}, 'n', function()
		local c=awful.client.restore()
			if c then client.focus=c c:raise()
		end
	end,
	{description='| Restore Minimized Clients\n', group='03 Client'}),
	awful.key({modkey, 'Shift'}, 'j', function()
		awful.client.swap.byidx(1)
	end,
	{description='| Swap with Left Tiled Window\n', group='03 Client'}),
	awful.key({modkey, 'Shift'}, 'k', function()
		awful.client.swap.byidx(-1)
	end,
	{description='| Swap with Right Tiled Window\n', group='03 Client'}),
	awful.key({modkey, 'Shift'}, 'h', function()
		awful.screen.focus_relative(1)
	end,
	{description='| Focus next Tiled Window\n', group='03 Client'}),
	awful.key({modkey, 'Shift'}, 'l', function()
		awful.screen.focus_relative(-1)
	end,
	{description='| Focus last Tiled Window\n', group='03 Client'}),
	awful.key({altkey, 'Shift'}, 'j', function()
		awful.tag.incmwfact(-0.05)
	end,
	{description='| Decrease Tile Width\n', group='03 Client'}),
	awful.key({altkey, 'Shift'}, 'k', function()
		awful.tag.incmwfact(0.05)
	end,
	{description='| Increase Tile Width\n', group='03 Client'}),
	awful.key({modkey}, 'Return', function()
		awful.util.spawn(terminal)
	end,
	{description='| Launch Terminal\n', group='04 Launchers'}),
	awful.key({modkey}, 'i', function()
		awful.spawn.with_shell('inkscape')
	end,
	{description='| Launch Inkscape\n', group='04 Launchers'}),
	awful.key({modkey}, 'b', function()
		awful.util.spawn(browser)
	end,
	{description='| Launch Browser\n', group='04 Launchers'}),
	awful.key({modkey}, 'e', function()
		awful.spawn.with_shell('gedit --new-window')
	end,
	{description='| Launch Graphical Editor\n', group='04 Launchers'}),
	awful.key({modkey}, 'v', function()
		awful.spawn.with_shell('virtualbox')
	end,
	{description='| Launch Kdenlive\n\n\n\n\n\n\n\n', group='04 Launchers'}),
	awful.key({modkey, 'Shift'}, 'v', function()
		awful.spawn.with_shell('kdenlive')
	end,
	{description='| Launch Virtualbox\n', group='04 Launchers'}),
	awful.key({modkey}, 'f', function()
		awful.util.spawn(filemanager)
	end,
	{description='| Launch File Manager\n', group='04 Launchers'}),
	awful.key({modkey}, 'F2', function()
		awful.spawn.with_shell('pavucontrol')
	end,
	{description='| Launch Pulse Mixer\n', group='04 Launchers'}),
	awful.key({modkey}, 'F3', function()
		awful.spawn.with_shell('cadence --minimised &')
	end,
	{description='| Launch Cadence\n', group='04 Launchers'}),
	awful.key({modkey}, 'F4', function()
		awful.spawn.with_shell('nm-connection-editor')
	end,
	{description='| Launch Connection Editor\n', group='04 Launchers'}),
	awful.key({modkey}, 'F9', function()
		awful.util.spawn(mailclient)
	end,
	{description='| Launch Mail Client\n', group='04 Launchers'}),
	awful.key({modkey}, 'F10', function()
		awful.spawn.with_shell('lxappearance')
	end,
	{description='| Launch Lxappearance\n', group='04 Launchers'}),
	awful.key({modkey}, 'F11', function()
		awful.spawn.with_shell('arandr')
	end,
	{description='| Launch Arandr\n', group='04 Launchers'}),	
	awful.key({modkey}, 'F1', function()
		awful.spawn.with_shell('deadbeef')
	end,
	{description='| Launch Deadbeef\n', group='04 Launchers'}),	
	awful.key({modkey}, 'g', function()
		awful.util.spawn('gimp')
	end,
	{description='| Launch GIMP\n', group='04 Launchers'}),
	awful.key({modkey}, 'o', function()
		awful.spawn.with_shell('loffice')
	end,
	{description='| Launch Libreoffice\n', group='04 Launchers'}),
	awful.key({modkey}, 'c', function()
		awful.spawn.with_shell('galculator')
	end,
	{description='| Launch Calculator\n', group='04 Launchers'}),
	awful.key({modkey, 'Shift'}, 'o', function()
		awful.spawn.with_shell('obs')
	end,
	{description='| Launch OBS\n', group='04 Launchers'}),
	awful.key({modkey, 'Shift'}, 'r', function()
		awful.spawn.with_shell('reaper -nosplash')
	end,
	{description='| Launch Reaper\n', group='04 Launchers'}),
	awful.key({modkey}, 'a', function()
		awful.spawn.with_shell('ardour8 -n')
	end,
	{description='| Launch Ardour\n', group='04 Launchers'}),
	awful.key({modkey}, 'd', function()
		awful.spawn.with_shell('Discord')
	end,
	{description='| Launch Discord\n', group='04 Launchers'}),
	
	awful.key({modkey}, 't', function()
		awful.spawn.with_shell('telegram-desktop')
	end,
	{description='| Launch Telegram\n', group='04 Launchers'}),
	awful.key({modkey, 'Shift'}, 's', function()
		awful.spawn.with_shell('steam-native')
	end,
	{description='| Launch Steam\n', group='04 Launchers'}),		
	awful.key({modkey, 'Shift'}, 'b', function()
		awful.spawn.with_shell('blender')
	end,
	{description='| Launch Blender\n', group='04 Launchers'}),
	awful.key({modkey, 'Shift'}, 't', function()
		awful.util.spawn('archlinux-tweak-tool')
	end,
	{description='| Launch Tweak Tool\n', group='04 Launchers'}),
	awful.key({altkey, ctlkey}, '=', function()
		for s in screen do
			s.mywibox.visible=not s.mywibox.visible
			if s.mybottomwibox then
				s.mybottomwibox.visible=not s.mybottomwibox.visible
			end
		end
	end,
	{description='| Toggle Wibox Visibility\n', group='06 Layout'}),
	awful.key({altkey, ctlkey}, '-', function()
		awful.screen.focused().systray.visible=not awful.screen.focused().systray.visible
	end,
	{description='| Toggle Systray Visibility\n', group='06 Layout'}),
	awful.key({altkey, ctlkey}, 'h', function()
		lain.util.useless_gaps_resize(1)
	end,
	{description='| Increment Useless Gaps\n', group='06 Layout'}),
	awful.key({altkey, ctlkey}, 'l', function()
		lain.util.useless_gaps_resize(-1)
	end,
	{description='| Decrement Useless Gaps\n', group='06 Layout'}),
	awful.key({altkey, ctlkey}, 'j', function()
		awful.tag.incnmaster(1,  nil,  true)
	end,
	{description='| Increment Master Clients\n', group='06 Layout'}),
	awful.key({altkey, ctlkey}, 'k', function()
		awful.tag.incnmaster(-1,  nil,  true)
	end,
	{description='| Decrement Master Clients\n', group='06 Layout'}),
	awful.key({modkey}, 'space', function()
		awful.layout.inc(1)
	end,
	{description='| Select Next Layout\n', group='06 Layout'}),
	awful.key({modkey, 'Shift'}, 'space', function()
		awful.layout.inc(-1)
	end,
	{description='| Select Previous Layout\n', group='06 Layout'})
)

-- client key bindings
clientkeys=gears.table.join(
	awful.key({modkey}, 'n', function(c)
		c.minimized=true
	end,
	{description='| Minimize Window\n', group='03 Client'}),
	awful.key({modkey}, 'm', function(c)
		c.maximized=not c.maximized c:raise()
	end,
	{description='| Maximize Window\n', group='03 Client'}),
	awful.key({modkey}, 'q', function(c)
		c:kill()
	end,
	{description='| Kill Windows\n', group='03 Client'}),
	awful.key({modkey, 'Shift'}, 'm', lain.util.magnify_client,
	{description='| Magnify Focused Window\n', group='03 Client'}),
	awful.key({altkey, 'Shift'}, 'space', awful.client.floating.toggle,
	{description='| Toggle Floating State\n', group='03 Client'}),
	awful.key({altkey, 'Shift'}, 't', function(c)
		c.ontop=not c.ontop
	end,
	{description='| Toggle Sticky State\n', group='03 Client'}),
	awful.key({altkey, 'Shift'}, 'm', function(c)
		c.fullscreen=not c.fullscreen
		c:raise()
	end,
	{description='| Toggle Fullscreen State\n', group='03 Client'})
)

-- tag selection
for i=1, 9 do
	local descr_view, descr_toggle, descr_move, descr_toggle_focus
	if i == 1 or i == 9 then
		descr_view={
			description='| Switch to Workspace\n', group='05 Workspaces'}
		descr_toggle={
			description='| Show Main Client from Workspace\n', group='05 Workspaces'}
		descr_move={
			description='| Throw Focused Client to Workspace\n', group='05 Workspaces'}
		descr_toggle_focus={
			description='| Follow Thrown Client to Workspace\n', group='05 Workspaces'}
	end
	globalkeys=gears.table.join(globalkeys,
		awful.key({modkey}, '#' .. i + 9, function()
			screen=awful.screen.focused() local tag=screen.tags[i]
			if tag then
				tag:view_only()
			end
		end,
	descr_view),
	awful.key({altkey, 'Shift'}, '#' .. i + 9, function()
		screen=awful.screen.focused()
		local tag=screen.tags[i]
			if tag then awful.tag.viewtoggle(tag)
		end
	end,
	descr_toggle),
	awful.key({altkey, ctlkey}, '#' .. i + 9, function()
		if client.focus then
			local tag=client.focus.screen.tags[i]
			if tag then
				client.focus:move_to_tag(tag) tag:view_only()
			end
		end
	end,
	descr_move),
	awful.key({altkey, modkey}, '#' .. i + 9, function()
		if client.focus then
			local tag=client.focus.screen.tags[i]
			if tag then
				client.focus:toggle_tag(tag)
			end
		end
	end,
	descr_toggle_focus))
end

-- client mouse buttons
clientbuttons=gears.table.join(
	awful.button({ }, 1, function (c)
		c:emit_signal('request::activate', 'mouse_click', {raise=true})
	end),
	awful.button({modkey}, 1, function(c)
		c:emit_signal('request::activate', 'mouse_click', {raise=true})
		awful.mouse.client.move(c)
	end),
	awful.button({modkey}, 3, function(c)
		c:emit_signal('request::activate', 'mouse_click', {raise=true})
		awful.mouse.client.resize(c)
	end)
)

-- initialize as root keys
root.keys(globalkeys)

--[[------------------------------------------------------------------------------------------------
 6 CLIENT BEHAVIOUR
------------------------------------------------------------------------------------------------]]--

-- client rules
awful.rules.rules={
	{rule={ },
		properties={
			border_width=beautiful.border_width,
			border_color=beautiful.border_normal,
			focus=awful.client.focus.filter,
			raise=true,
			keys=clientkeys,
			buttons=clientbuttons,
			screen=awful.screen.preferred,
			placement=awful.placement.no_overlap+awful.placement.no_offscreen,
			size_hints_honor=false}},
	{rule_any={type={'dialog', 'normal'}},
		properties={titlebars_enabled=false}},
}

-- client management
client.connect_signal('manage', function(c)
	if awesome.startup and
	not c.size_hints.user_position
	and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end
end)
client.connect_signal('mouse::enter', function(c)
	c:emit_signal('request::activate', 'mouse_enter', {raise=false})
end)
client.connect_signal('focus', function(c)
	c.border_color=beautiful.border_focus
end)
client.connect_signal('unfocus', function(c)
	c.border_color=beautiful.border_normal
end)

--[[------------------------------------------------------------------------------------------------
 7 AUTOSTART APPLICATIONS
------------------------------------------------------------------------------------------------]]--

-- execution function
local function run(c)
    if not awesome.startup then
        awful.spawn.easy_async_with_shell(
        string.format('pgrep -f '%s'', c),
            function(stdout)
                if not stdout:match('%S') then
                    awful.spawn(c)
                end
            end)
    else
        awful.spawn.easy_async_with_shell(
            string.format("killall -9 '%s' >'/dev/null' 2>&1 & sleep 1; %s &", c, c))
    end
end

-- startup list
cadence_cmd='/usr/share/cadence/src/cadence.py --minimized'
run('volumeicon')
run('picom -b --config "$HOME/.config/awesome/picom.conf"')
run('nm-applet')
run('pgrep -f "' .. cadence_cmd .. '" | xargs kill -9 & cadence --minimized')
run('setxwall')
----------------------------------------------------------------------------------------------------
