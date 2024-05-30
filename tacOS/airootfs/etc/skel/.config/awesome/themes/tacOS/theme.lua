--[[                           __________         _______  _________
                               \__   ___/____ ____\_ __  \/   _____/
                                 |   |  \__  \  __\   |   \_____   \
                                 |___|  (____/____/_______/________/

                                       Inspiration:
                                        ~ Dunzor2 by Dunz0r
                                        ~ Matrix by ShdB
                                        ~ Multicolor by Lcpz
                                        ~ Wombat by Zhuravlik                                                                              
                                        ~ Zenburn by Anrxc

----------------------------------------------------------------------------------------------------
 ▸ $XDG_CONFIG_HOME/awesome/themes/tacOS/theme.lua
----------------------------------------------------------------------------------------------------
 ▸ $BROWSER 'https://awesomewm.org/doc/api/sample%20files/theme.lua.html'
----------------------------------------------------------------------------------------------------
 1 ~ Required Libraries
------------------------------------------------------------------------------------------------]]--

local gears=require('gears')
local lain=require('lain')
local awful=require('awful')
require('awful.util')
local wibox=require('wibox')
local dpi=require('beautiful.xresources').apply_dpi
local config=awful.util.getdir('config')

--[[------------------------------------------------------------------------------------------------
 2 ~ Setup Environment
------------------------------------------------------------------------------------------------]]--

local theme_name='tacOS'
local home=os.getenv('HOME')
local config_dir=os.getenv('XDG_CONFIG_HOME') or os.getenv('CONFIG')
local awesome_dir=config_dir .. '/awesome'
local theme_dir=awesome_dir .. '/themes'
local this_dir=theme_dir .. '/tacOS'
local icons_dir=this_dir .. '/icons'
--local layouts_dir=this_dir .. '/layouts'
--local taglist_dir=this_dir .. '/taglists'
--local titlebar_dir=this_dir .. '/titlebar'
if awful.util.file_readable(this_dir .. '/theme.lua') then
	theme_file=this_dir .. '/theme.lua'
else
	theme_file=home .. '.config/awesome/themes/tacOS/theme.lua'
end

--[[------------------------------------------------------------------------------------------------
 3 ~ Theme Variables
------------------------------------------------------------------------------------------------]]--

theme={}
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

theme.bg_normal='#03010f' -- No Touchy
theme.bg_focus='#121214' -- No Touchy
theme.bg_urgent='#161616' -- Black
theme.fg_normal='#7cbad0' -- Light Blue (Tags, focused client text and hotkeys)
theme.fg_focus='#c1e874' -- Light Green (Focused tag)
theme.fg_urgent='#d5251f' -- Deep Bright Red
theme.fg_minimize='#788556' -- Grey Green
theme.border_normal='#274e2a' -- Dark Blue Teal (Unfocused client borders)
theme.border_focus='#62be68' -- Bright Teal (Focused borders)
theme.border_marked='#38be2e' -- Standard Green
theme.menu_fg_normal='#c1e874' -- Light Green (Menu text)
theme.menu_fg_focus='#7cbad0' -- Light Blue
theme.menu_bg_normal='#161616' -- Black
theme.menu_bg_focus='#161616' -- Black

theme.awesome_icon=icons_dir .. '/awesome.png'
theme.menu_submenu_icon=icons_dir .. '/circle.png'
theme.widget_temp=icons_dir .. '/temp.png'
theme.widget_uptime=icons_dir .. '/ac.png'
theme.widget_cpu=icons_dir .. '/cpu.png'
theme.widget_weather=icons_dir .. '/dish.png'
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

--[[------------------------------------------------------------------------------------------------
 4 ~ Systray Widgets
------------------------------------------------------------------------------------------------]]--

-- Text Clock
os.setlocale(os.getenv('LANG'))
local mytextclock=
wibox.widget.textclock(markup('#c1e874', ' 🗓 %m/%d/%y') .. markup('#c1e874', ' 🯁🯂🯃 ⏲ %H:%M '))
mytextclock.font=theme.font
theme.cal=lain.widget.cal({
	attach_to={mytextclock},
	notification_preset={
		font='Nouveau IBM Regular 10',
		fg=theme.fg_normal,
		bg=theme.bg_normal
	}
})

-- CPU Load⟯ ❱ ❯ ❱ 
local cpuicon=wibox.widget.imagebox(theme.widget_cpu)
local cpu=lain.widget.cpu({
	settings=function()
		widget:set_markup(markup.fontfg(theme.font, '#c1e874', cpu_now.usage .. '% ❱ '))
	end
})

-- CPU Temp
local tempicon=wibox.widget.imagebox(theme.widget_temp)
local temp=lain.widget.temp({
	settings=function()
		widget:set_markup(markup.fontfg(theme.font, '#7cbad0', coretemp_now .. '°C ❱ '))
	end
})

local baticon=wibox.widget.imagebox(theme.widget_batt)
local prev_ac_status=nil
local prev_perc=nil
local bat=lain.widget.bat({
	settings=function()
		local perc=bat_now.perc ~= 'N/A' and bat_now.perc .. '%' or bat_now.perc
		if bat_now.ac_status == 1 then
			baticon:set_image(icons_dir .. '/ac.png')
			if prev_ac_status ~= bat_now.ac_status or prev_perc ~= bat_now.perc then
				awful.spawn.with_shell('notify-send "Battery: Charging"')
			end
		else
			baticon:set_image(icons_dir .. '/bat.png')
			if prev_ac_status ~= bat_now.ac_status or prev_perc ~= bat_now.perc then
				awful.spawn.with_shell('notify-send "Battery: Serving"')
			end
		end
		widget:set_markup(markup.fontfg(theme.font, '#c1e874', perc .. ' ❱ '))
		prev_ac_status=bat_now.ac_status
		prev_perc=bat_now.perc
	end,
})

-- Volume
local volicon=wibox.widget.imagebox(theme.widget_vol)
theme.volume=lain.widget.alsa({
	settings=function()
		if volume_now.status == 'off' then
			volume_now.level=volume_now.level .. 'M'
		end
		widget:set_markup(markup.fontfg(theme.font, '#c1e874', volume_now.level .. '% ❱ '))
	end
})

-- Network Speeds🡘
local netdownicon=wibox.widget.imagebox(theme.widget_netdown)
local netdowninfo=wibox.widget.textbox()
local netupicon=wibox.widget.imagebox(theme.widget_netup)
local netupinfo=lain.widget.net({
	settings=function()
		widget:set_markup(markup.fontfg(theme.font, '#7cbad0', net_now.sent .. 'kb ❱ '))
		netdowninfo:set_markup(markup.fontfg(theme.font, '#7cbad0', net_now.received .. 'kb 🮲🮳'))
	end
})

-- Memory Usage
local memicon=wibox.widget.imagebox(theme.widget_mem)
local memory=lain.widget.mem({
	settings=function()
		widget:set_markup(markup.fontfg(theme.font, '#7cbad0', mem_now.used .. 'kb ❱ '))
	end
})

-- Systray Layout
function theme.at_screen_connect(s)
	s.quake=lain.util.quake({app='urxvt', height=0.50, argname='--name %s' })
	awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])
	s.mypromptbox=awful.widget.prompt()
	s.mylayoutbox=awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
	awful.button({}, 1, function()
		awful.layout.inc(1)
	end),
	awful.button({}, 2, function()
		awful.layout.set(awful.layout.layouts[1])
	end),
	awful.button({}, 3, function()
		awful.layout.inc(-1)
	end),
	awful.button({}, 4, function()
		awful.layout.inc(1)
	end),
	awful.button({}, 5, function()
		awful.layout.inc(-1)
	end)))
	s.mytaglist=awful.widget.taglist(
		s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)
	s.mytasklist=awful.widget.tasklist(
		s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)
	s.mywibox=awful.wibar({
		position='top', screen=s, height=dpi(20), bg=theme.bg_normal, fg=theme.fg_normal})
	s.mywibox:setup{
		layout=wibox.layout.align.horizontal,{
			layout=wibox.layout.fixed.horizontal,
			menu_launcher,
			s.mytaglist,
			s.mypromptbox,},
		nil,{
			layout=wibox.layout.fixed.horizontal,
			baticon,
			bat.widget,
			netdownicon,
			netdowninfo,
			netupicon,
			netupinfo.widget,
			volicon,
			theme.volume.widget,
			memicon,
			memory.widget,
			cpuicon,
			cpu.widget,
			tempicon,
			temp.widget,
			clockicon,
			mytextclock,
			wibox.widget.systray(),},}
	s.mybottomwibox=awful.wibar({
	position='bottom', screen=s, border_width=0, height=dpi(20),
	bg=theme.bg_normal, fg=theme.fg_normal})
	s.mybottomwibox:setup{
		layout=wibox.layout.align.horizontal,{
			layout=wibox.layout.fixed.horizontal,},
		s.mytasklist,{
			layout=wibox.layout.fixed.horizontal,
			s.mylayoutbox,},}
end
return theme
