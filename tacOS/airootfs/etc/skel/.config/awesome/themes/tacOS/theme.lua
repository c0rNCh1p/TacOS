--[[                        __|  |  | _ |  _ \ \ \  /    \   _ \   __|
                           (     __ |   |  __/  >  <   (  |    /  (_ |
                          \___| _| _|  _| _|    _/\_\ \__/  _|_\ \___|

                                      Inspiration:
                                      ▸ dunzor2 by dunz0r
                                      ▸ multicolor by lcpz
                                      ▸ wombat by zhuravlik
                                      ▸ zenburn by anrxc
                                      
----------------------------------------------------------------------------------------------------
 ▸ $XDG_CONFIG_HOME/awesome/themes/tacOS/theme.lua
----------------------------------------------------------------------------------------------------
 ▸ $BROWSER 'https://awesomewm.org/doc/api/sample%20files/theme.lua.html'
----------------------------------------------------------------------------------------------------
 1 REQUIRED LIBRARIES
------------------------------------------------------------------------------------------------]]--

local gears=require('gears')
local lain=require('lain')
local awful=require('awful')
require('awful.util')
local wibox=require('wibox')
local dpi=require('beautiful.xresources').apply_dpi
local config=awful.util.getdir('config')

--[[------------------------------------------------------------------------------------------------
 2 SETUP ENVIRONMENT
------------------------------------------------------------------------------------------------]]--

local themename='tacOS'
local home=os.getenv('HOME')
local configdir=os.getenv('XDG_CONFIG_HOME') or os.getenv('CONFIG')
local awesomedir=configdir .. '/awesome'
local themedir=awesomedir .. '/themes'
local thisdir=themedir .. '/tacOS'
local iconsdir=thisdir .. '/icons'
--local layoutsdir=thisdir .. '/layouts'
--local taglistdir=thisdir .. '/taglists'
--local titlebardir=thisdir .. '/titlebar'
if awful.util.file_readable(thisdir .. '/theme.lua') then
	themefile=thisdir .. '/theme.lua'
else
	themefile=home .. '.config/awesome/themes/tacOS/theme.lua'
end

--[[------------------------------------------------------------------------------------------------
 3 THEME VARIABLES
------------------------------------------------------------------------------------------------]]--

theme={}
theme.confdir=thisdir
theme.icon_theme='Obsidian Green'
theme.font='Nouveau IBM Regular 10'
theme.taglist_font='Square One Bold 6'
theme.border_width=dpi(1)
theme.menu_border_width=dpi(1)
theme.menu_height=dpi(25)
theme.menu_width=dpi(260)
theme.tasklist_plain_task_name=true
theme.tasklist_disable_icon=true
theme.useless_gap=5
markup=lain.util.markup

theme.bg_normal='#03010f'
theme.bg_focus='#121214'
theme.bg_urgent='#161616'
theme.fg_normal='#a7c260'
theme.fg_focus='#6288c2'
theme.fg_urgent='#d5251f'
theme.fg_minimize='#788556'
theme.border_normal='#6288c2'
theme.border_focus='#8bad2f'
theme.border_marked='#9ac429'
theme.menu_fg_normal='#a7c260'
theme.menu_fg_focus='#6288c2'
theme.menu_bg_normal='#161616'
theme.menu_bg_focus='#161616'

theme.awesome_icon=iconsdir .. '/awesome.png'
--theme.menu_submenu_icon=iconsdir .. '/awesome.png'
theme.widget_temp=iconsdir .. '/temp.png'
theme.widget_uptime=iconsdir .. '/ac.png'
theme.widget_cpu=iconsdir .. '/cpu.png'
theme.widget_weather=iconsdir .. '/dish.png'
theme.widget_fs=iconsdir .. '/fs.png'
theme.widget_mem=iconsdir .. '/mem.png'
theme.widget_note=iconsdir .. '/note.png'
theme.widget_note_on=iconsdir .. '/note_on.png'
theme.widget_netdown=iconsdir .. '/net_down.png'
theme.widget_netup=iconsdir .. '/net_up.png'
theme.widget_mail=iconsdir .. '/mail.png'
theme.widget_batt=iconsdir .. '/bat.png'
--theme.widget_clock=iconsdir .. '/clock.png'
theme.widget_vol=iconsdir .. '/spkr.png'
theme.taglist_squares_sel=iconsdir .. '/square_a.png'
theme.taglist_squares_unsel=iconsdir .. '/square_b.png'
theme.layout_tile=iconsdir .. '/tile.png'
theme.layout_tilegaps=iconsdir .. '/tilegaps.png'
theme.layout_tileleft=iconsdir .. '/tileleft.png'
theme.layout_tilebottom=iconsdir .. '/tilebottom.png'
theme.layout_tiletop=iconsdir .. '/tiletop.png'
theme.layout_fairv=iconsdir .. '/fairv.png'
theme.layout_fairh=iconsdir .. '/fairh.png'
theme.layout_spiral=iconsdir .. '/spiral.png'
theme.layout_dwindle=iconsdir .. '/dwindle.png'
theme.layout_max=iconsdir .. '/max.png'
theme.layout_fullscreen=iconsdir .. '/fullscreen.png'
theme.layout_magnifier=iconsdir .. '/magnifier.png'
theme.layout_floating=iconsdir .. '/floating.png'

--[[------------------------------------------------------------------------------------------------
 4 SYSTRAY WIDGETS
------------------------------------------------------------------------------------------------]]--

-- text clock
os.setlocale(os.getenv('LANG'))
local mytextclock=
wibox.widget.textclock(markup('#9eafc9', '🗓 %a %d/%m/%y ') .. markup('#a7c260', '⏲ %H:%M '))
mytextclock.font=theme.font
theme.cal=lain.widget.cal({
	attach_to={mytextclock},
	notification_preset={
		font='Nouveau IBM Regular 10',
		fg=theme.fg_normal,
		bg=theme.bg_normal
	}
})

-- cpu load
local cpuicon=wibox.widget.imagebox(theme.widget_cpu)
local cpu=lain.widget.cpu({
	settings=function()
		widget:set_markup(markup.fontfg(theme.font, '#9eafc9', cpu_now.usage .. '% '))
	end
})

-- cpu temp
local tempicon=wibox.widget.imagebox(theme.widget_temp)
local temp=lain.widget.temp({
	settings=function()
		widget:set_markup(markup.fontfg(theme.font, '#a7c260', coretemp_now .. '°C '))
	end
})

-- battery
local baticon=wibox.widget.imagebox(theme.widget_batt)
local bat=lain.widget.bat({
	settings=function()
		local perc=bat_now.perc ~= 'N/A' and bat_now.perc .. '%' or bat_now.perc
		if bat_now.ac_status == 1 then
			perc=perc .. ' plug'
		end
		widget:set_markup(markup.fontfg(theme.font, theme.fg_normal, perc .. ' '))
	end
})

-- volume
local volicon=wibox.widget.imagebox(theme.widget_vol)
theme.volume=lain.widget.alsa({
	settings=function()
		if volume_now.status == 'off' then
			volume_now.level=volume_now.level .. 'M'
		end
		widget:set_markup(markup.fontfg(theme.font, '#9eafc9', volume_now.level .. '% '))
	end
})

-- network speeds
local netdownicon=wibox.widget.imagebox(theme.widget_netdown)
local netdowninfo=wibox.widget.textbox()
local netupicon=wibox.widget.imagebox(theme.widget_netup)
local netupinfo=lain.widget.net({
	settings=function()
		widget:set_markup(markup.fontfg(theme.font, '#a7c260', net_now.sent .. ' '))
		netdowninfo:set_markup(markup.fontfg(theme.font, '#9eafc9', net_now.received .. ' '))
	end
})

-- memory usage
local memicon=wibox.widget.imagebox(theme.widget_mem)
local memory=lain.widget.mem({
	settings=function()
		widget:set_markup(markup.fontfg(theme.font, '#a7c260', mem_now.used .. 'M '))
	end
})

-- systray layout
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
			--baticon,
			--bat.widget,
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

----------------------------------------------------------------------------------------------------
