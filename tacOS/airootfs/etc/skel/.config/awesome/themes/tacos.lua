--[[ 100x
                                __ __|   \     __|   _ \    __|
                                   |    _ \   (     (   | \__ \
                                  _|  _/  _\ \___| \___/  ____/

====================================================================================================

 Files:
 - Filepath: $HOME/.config/awesome/themes/tacos.lua
 - Licence: $HOME/.config/awesome/licence

====================================================================================================

 Inspiration:
 - Dunzor2, by Dunz0r: $BROWSER https://github.com/dunz0r
 - Matrix, by ShdB: $BROWSER https://github.com/shdb
 - Multicolor, by Lcpz: $BROWSER https://github.com/lcpz
 - Wombat, by Zhuravlik: $BROWSER https://github.com/zhuravlik
 - Zenburn, by Anrxc: $BROWSER https://github.com/vicious-widgets

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
local awful=require('awful')
local beautiful=require('beautiful')
local dpi=require('beautiful.xresources').apply_dpi
local gears=require('gears')
local lain=require('lain')
local wibox=require('wibox')
local naughty=require('naughty')
local markup=lain.util.markup

-- Environment
local theme_file='/tacos.lua'
local home=os.getenv('HOME')
local config_dir=os.getenv('CONFIG') or home .. '/.config'
local awesome_dir=os.getenv('AWESOME_HOME') or config_dir .. '/awesome'
local configs_dir=awesome_dir .. '/configs' or gears.filesystem.get_configuration_dir()
local desktop_dir=awesome_dir .. '/desktop'
local scripts_dir=awesome_dir .. '/scripts'
local theme_dir=awesome_dir .. '/themes'
local icons_dir=theme_dir .. '/icons'
local config_file=configs_dir .. '/openweather.conf'
awful.util.file_readable(theme_dir .. theme_file)
theme={}

--==================================================================================================
-- [2] Theme Variables
--==================================================================================================

-- General
theme.confdir=this_dir
theme.icon_theme='Obsidian Green'
theme.font='Nimbus Mono PS Bold 9'
theme.taglist_font='Square One Bold 6'
theme.border_width=dpi(0.5)
theme.menu_border_width=dpi(0.5)
theme.menu_height=dpi(25)
theme.menu_width=dpi(260)
theme.tasklist_plain_task_name=true
theme.tasklist_disable_icon=true
theme.useless_gap=5
markup=lain.util.markup

-- Colors
theme.bg_normal='#03010f' -- No Touchy
theme.bg_focus='#121214' -- No Touchy
theme.bg_urgent='#161616' -- Black
theme.fg_normal='#c1e874' -- Light Blue (Tags, focused client text and hotkeys)
theme.fg_focus='#7cbad0' -- Light Green, (Focused tag, Notifications)
theme.fg_urgent='#d5251f' -- Deep Bright Red
theme.fg_minimize='#788556' -- Grey Green
theme.border_normal='#274e2a' -- Dark Blue Teal (Unfocused client borders)
theme.border_focus='#83770a' -- Bright Teal (Focused borders)#62be68
theme.border_marked='#38be2e' -- Standard Green
theme.menu_fg_normal='#c1e874' -- Light Green (Menu text)
theme.menu_fg_focus='#7cbad0' -- Light Blue
theme.menu_bg_normal='#161616' -- Black

-- Icons
theme.awesome_icon=icons_dir .. '/awesome.png'
theme.menu_submenu_icon=icons_dir .. '/circle.png'
theme.widget_temp=icons_dir .. '/temp.png'
theme.widget_uptime=icons_dir .. '/ac.png'
theme.widget_cpu=icons_dir .. '/cpu.png'
theme.widget_wttr=icons_dir .. '/dish.png'
theme.widget_fs=icons_dir .. '/fs.png'
theme.widget_mem=icons_dir .. '/mem.png'
theme.widget_note=icons_dir .. '/note.png'
theme.widget_note_on=icons_dir .. '/note_on.png'
theme.widget_netdown=icons_dir .. '/net_down.png'
theme.widget_netup=icons_dir .. '/net_up.png'
theme.widget_mail=icons_dir .. '/mail.png'
theme.widget_batt=icons_dir .. '/bat.png'
theme.widget_clock=icons_dir .. '/clock.png'
theme.widget_vol=icons_dir .. '/spkr.png'
theme.taglist_squares_sel=icons_dir .. '/square_a.png'
theme.taglist_squares_unsel=icons_dir .. '/square_b.png'
theme.layout_tile=icons_dir .. '/tile.png'
theme.layout_tilegaps=icons_dir .. '/tilegaps.png'
theme.layout_tileleft=icons_dir .. '/tileleft.png'
theme.layout_tilebottom=icons_dir .. '/tilebottom.png'
theme.layout_tiletop=icons_dir .. '/tiletop.png'
theme.layout_fairv=icons_dir .. '/fairv.png'
theme.layout_fairh=icons_dir .. '/fairh.png'
theme.layout_spiral=icons_dir .. '/spiral.png'
theme.layout_dwindle=icons_dir .. '/dwindle.png'
theme.layout_max=icons_dir .. '/max.png'
theme.layout_fullscreen=icons_dir .. '/fullscreen.png'
theme.layout_magnifier=icons_dir .. '/magnifier.png'
theme.layout_floating=icons_dir .. '/floating.png'

--==================================================================================================
-- [3] Systray Widgets
--==================================================================================================

-- Text Clock
os.setlocale(os.getenv('LANG'))
local clockicon=wibox.widget.imagebox(theme.widget_clock)
local textclock=wibox.widget.textclock(
	markup('#c1e874', '🗓 %m/%d/%y') .. markup('#c1e874', ' 🯁🯂🯃 %H:%M'))
textclock.font=theme.font

-- Calendar
theme.cal=lain.widget.cal({
	attach_to={ textclock },
	notification_preset={
		font='Nimbus Mono PS Bold 9',
		fg=theme.fg_normal,
		bg=theme.bg_normal},
})

-- CPU Load
local cpuicon=wibox.widget({image=theme.widget_cpu, resize=true, widget=wibox.widget.imagebox})
local cpu=lain.widget.cpu({
	settings=function()
		widget:set_markup(markup.fontfg(theme.font, '#c1e874', cpu_now.usage .. '%'))
	end,
})

-- CPU Temp
local tempicon=wibox.widget({image=theme.widget_temp, resize=true, widget=wibox.widget.imagebox})
local temp=lain.widget.temp({
	settings=function()
		widget:set_markup(markup.fontfg(theme.font, '#7cbad0', coretemp_now .. '°ᶜ'))
	end,
})

-- Battery
local baticon=wibox.widget.imagebox(theme.widget_batt)
local prev_ac_status=nil
local prev_perc=nil
local bat=lain.widget.bat({
	settings=function()
		local perc=bat_now.perc ~= 'N/A' and bat_now.perc .. '%' or bat_now.perc
		if bat_now.ac_status == 1 then
			baticon:set_image(icons_dir .. '/ac.png')
			if prev_ac_status ~= bat_now.ac_status or prev_perc ~= bat_now.perc then
				awful.spawn.with_shell("notify-send 'PowerSupply' 'Battery charging'")
			end
		else baticon:set_image(icons_dir .. '/bat.png')
			if prev_ac_status ~= bat_now.ac_status or prev_perc ~= bat_now.perc then
				awful.spawn.with_shell("notify-send 'PowerSupply' 'Battery serving'")
			end
		end
		widget:set_markup(markup.fontfg(theme.font, '#c1e874', perc))
		prev_ac_status=bat_now.ac_status
		prev_perc=bat_now.perc
	end,
})

-- Volume
local volicon=wibox.widget({image=theme.widget_vol, resize=true, widget=wibox.widget.imagebox})
theme.volume=lain.widget.alsa({
	settings=function()
		if volume_now.status == 'off' then
			volume_now.level=volume_now.level .. 'M'
		end
		widget:set_markup(markup.fontfg(theme.font, '#c1e874', volume_now.level .. '%'))
	end,
})

-- Network Speeds
local netdownicon=wibox.widget.imagebox(theme.widget_netdown)
local netdowninfo=wibox.widget.textbox()
local netupicon=wibox.widget.imagebox(theme.widget_netup)
local netupinfo=lain.widget.net({
	settings=function()
		widget:set_markup(markup.fontfg(theme.font, '#7cbad0', net_now.sent .. 'kb'))
		netdowninfo:set_markup(markup.fontfg(theme.font, '#7cbad0', net_now.received .. 'kb 🮲🮳'))
	end,
})

-- Memory Usage
local memicon=wibox.widget({image=theme.widget_mem, resize=true, widget=wibox.widget.imagebox})
local memory=lain.widget.mem({
	settings=function()
		widget:set_markup(markup.fontfg(theme.font, '#7cbad0', mem_now.used .. 'kb'))
	end,
})

-- Read openweather.conf
local function read_config(file)
	local config={}
	local file_handle=io.open(file, 'r')
	if not file_handle then
		awful.spawn.with_shell("notify-send 'OpenWeather' 'ERR: Failed to read openweather.conf'")
		return config
	end
	for line in file_handle:lines() do
		if line:match('^#') or line:match('^%s*$') then	goto continue
		end
		line=line:gsub('%s*#.*$', '')
		line=line:gsub('^%s*', ''):gsub('%s*$', '')
		local key, value=line:match('([^%s=]+)%s*=%s*([^%s]+)')
		if key and value then config[key]=value
		end
		::continue::
	end
	file_handle:close()
	return config
end

-- Weather
local weather_config=read_config(config_file)
local weathericon=wibox.widget({image=theme.widget_wttr, resize=true, widget=wibox.widget.imagebox})
local weather=lain.widget.weather({
	APPID=weather_config.api_key, -- Auto parse API Key in openweather.conf
	city_id=tonumber(weather_config.city_id), -- Auto parse City ID from openweather.conf
	settings=function()
		awful.spawn.with_shell("notify-send 'OpenWeather' 'API configured'")
		if weather_now and weather_now['weather'] and
			weather_now['weather'][1] and weather_now['main'] then
			local descr=weather_now['weather'][1]['description']:lower()
			local units=math.floor(weather_now['main']['temp'])
			widget:set_markup(lain.util.markup.fontfg(
				theme.font, '#7cbad0', descr .. ' ' .. units .. '°ᶜ'))
		else awful.spawn.with_shell(
			"notify-send 'OpenWeather' 'Invalid config values in openweather.conf'")
		end
	end,
})

-- MPD Widget
local mpdicon=wibox.widget({image=theme.widget_note, resize=true, widget=wibox.widget.imagebox})
local mpd=lain.widget.mpd({
	timeout=5, -- Refresh interval
	settings=function()
		local status_file=io.open(
			os.getenv('HOME') .. '/.config/awesome/scripts/mpd_current.txt', 'r')
		local browser_info='-'
		if status_file then
			local line=status_file:read("*all")
			status_file:close()
			if line and line ~= '-' then
				browser_info=line
			end
		end
		local artist='N/A'
		local title='N/A'
		if mpd_now.state == 'play' then
			artist=mpd_now.artist or 'Unknown Artist'
			title=mpd_now.title or 'Unknown Title'
			widget:set_markup(markup.font(theme.font, markup('#c1e874', artist .. '-' .. title)))
		elseif mpd_now.state == 'pause' then artist='' title=''
			widget:set_markup(markup.font(theme.font, markup('#c1e874', artist .. '-' .. title)))
		else widget:set_markup(markup.font(theme.font, markup('#c1e874', browser_info)))
		end
	end,
})

-- Separator
local function create_separator(color)
	return wibox.widget({
		markup=markup.fontfg(theme.font, color, '⦘ '),
		widget=wibox.widget.textbox,
		align='center'})
end

-- Margins
local function create_margined_widget(widget, left, right, top, bottom)
	return wibox.container.margin(widget, dpi(left), dpi(right), dpi(top), dpi(bottom))
end

--==================================================================================================
-- [4] Initialize Theme
--==================================================================================================

-- Create Layout
function theme.at_screen_connect(s)
	s.quake=lain.util.quake({app=terminal, height=0.50, argname='--name %s'})
	awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])
	s.promptbox=awful.widget.prompt()
	s.layoutbox=awful.widget.layoutbox(s)
	s.layoutbox:buttons(gears.table.join(
		awful.button({}, 1, function() awful.layout.inc(1) end),
		awful.button({}, 2, function() awful.layout.set(awful.layout.layouts[1]) end),
		awful.button({}, 3, function() awful.layout.inc(-1) end),
		awful.button({}, 4, function() awful.layout.inc(1) end),
		awful.button({}, 5, function() awful.layout.inc(-1) end)))
	s.taglist=awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)
	s.tasklist=awful.widget.tasklist(
		s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)
	s.wibox=awful.wibar({
		position='top', screen=s, height=dpi(20), bg=theme.bg_normal, fg=theme.fg_normal})
	s.wibox:setup({layout=wibox.layout.align.horizontal,{layout=wibox.layout.fixed.horizontal,
			menu_launcher, s.taglist, s.promptbox}, nil,{
			layout=wibox.layout.fixed.horizontal,
			-- Systray Order
			create_margined_widget(baticon, 1, 1, 1, 1),
			create_margined_widget(bat.widget, 3, 3, 3, -3),
			create_separator('#c1e874'),
			create_margined_widget(netdownicon, 1, 1, 1, 1),
			create_margined_widget(netdowninfo, 2, 2, 2, 2),
			create_margined_widget(netupinfo.widget, 2, 2, 2, -2),
			create_margined_widget(netupicon, 1, 1, 1, 1),
			create_separator('#7cbad0'),
			create_margined_widget(volicon, 1, 1, 1, 1),
			create_margined_widget(theme.volume.widget, 3, 3, 3, -3),
			create_separator('#c1e874'),
			create_margined_widget(memicon, 1, 1, 1, 1),
			create_margined_widget(memory.widget, 3, 3, 3, -3),
			create_separator('#7cbad0'),
			create_margined_widget(cpuicon, 1, 1, 1, 1),
			create_margined_widget(cpu.widget, 3, 3, 3, -3),
			create_separator('#c1e874'),
			create_margined_widget(tempicon, 1, 1, 1, 1),
			create_margined_widget(temp.widget, 2, 2, 2, -2),
			create_separator('#7cbad0'),
			create_margined_widget(mpdicon, -1, -1, -1, -1),
			create_margined_widget(mpd.widget, 3, 3, 3, -3),
			create_separator('#c1e874'),
			create_margined_widget(weathericon, 1, 1, 1, 1),
			create_margined_widget(weather.widget, 1, 1, 1, -1),
			create_separator('#7cbad0'),
			create_margined_widget(textclock, 2, 2, 2, -2),
			create_margined_widget(clockicon, 0, 0, 0, 0),
			create_separator('#c1e874'),
			wibox.widget.systray(),},})
	s.bottomwibox=awful.wibar({position='bottom', screen=s,
		border_width=0, height=dpi(20), bg=theme.bg_normal, fg=theme.fg_normal})
	s.bottomwibox:setup({layout=wibox.layout.align.horizontal,
		{layout=wibox.layout.fixed.horizontal}, s.tasklist,
		{layout=wibox.layout.fixed.horizontal, s.layoutbox},})
end
return theme