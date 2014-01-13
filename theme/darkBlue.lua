--[[
        File:      darkBlue.lua
        Date:      2014-01-12
      Author:      Emmanuel Lepage Vallee <elv1313@gmail.com>
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
TODO: popup sys widget menu jeigu diske vietos nera arba memory arba temp
--]]

local gears   = require("gears")
local awful   = require("awful")
local naughty = require("naughty")
local cairo   = require("lgi").cairo

-- Create cairo pattern from png file
local function pattern(image)
    local pat = cairo.Pattern.create_for_surface(cairo.ImageSurface.create_from_png(image))
    cairo.Pattern.set_extend(pat,cairo.Extend.REPEAT)
    return pat
end

local theme = {}

theme.path                            = awful.util.getdir("config").."/theme/darkBlue"
theme.menu_submenu_icon               = theme.path.."/submenu.png"
theme.awesome_icon                    = theme.path.."/logos/awesome.png"
theme.dist_icon                       = theme.path.."/logos/gentoo.svg"
theme.wallpaper                       = theme.path.."/background.png"
theme.unknown                         = theme.path.."/logos/unknown.svg"
theme.bg_systray                      = "#00184800"
theme.menu_height                     = 20
theme.popup_time_out                  = 5
theme.icon_theme                      = nil

-- Main wibox settings
theme.wibox={}
theme.wibox.position                  = "bottom"
theme.wibox.height                    = 16
theme.wibox.bg                        = pattern(theme.path.."/background/wibox.png")
theme.wibox.fg                        = "#1692D0"

-- Taglist widget
theme.tag={}
theme.tag["font"]                     = "Sci Fied 10"
theme.tag["bg_focus"]                 = "#0F2766"
theme.tag["fg_focus"]                 = "#1692D0"
theme.tag["bg_urgent"]                = "#0F2766"
theme.tag["fg_urgent"]                = "#C12C0B"
theme.tag["bg_occupied"]              = "#0F2766"
theme.tag["fg_occupied"]              = "#1F5391"
theme.tag["bg_empty"]                 = "#0F2766"
theme.tag["fg_empty"]                 = "#1692D0"
theme.tag["squares_sel"]              = theme.path.."/tags/squares_sel.png"
theme.tag["squares_unsel"]            = theme.path.."/tags/squares_unsel.png"
theme.tag["squares_resize"]           = true
theme.taglist_disable_icon            = true

-- Tasklist widget
theme.task={}
theme.task["font"]                    = "Liberation sans 9"
theme.task["fg_normal"]               = "#155898"
theme.task["bg_normal"]               = pattern(theme.path.."/background/tasklist_normal.png")
theme.task["fg_focus"]                = "#1692D0"
theme.task["bg_focus"]                = pattern(theme.path.."/background/tasklist_focus.png")
theme.task["fg_urgent"]               = "#1692D0"
theme.task["bg_urgent"]               = pattern(theme.path.."/background/tasklist_urgent.png")
theme.task["fg_minimize"]             = "#1692D0"
theme.task["bg_minimize"]             = pattern(theme.path.."/background/tasklist_minimize.png")
theme.task["sticky"]                  = "▪"
theme.task["ontop"]                   = '⌃'
theme.task["floating"]                = '✈'
theme.task["maximized_horizontal"]    = '⬌'
theme.task["maximized_vertical"]      = '⬍'
theme.tasklist_disable_icon           = false
theme.tasklist_plain_task_name        = true

-- Titlebar
theme.titlebar={}
theme.titlebar["all"]                 = false
theme.titlebar["float"]               = true
theme.titlebar["dialog"]              = true
theme.titlebar["status"]              = true
theme.titlebar["size"]                = 13
theme.titlebar["valign"]              = "center"
theme.titlebar["position"]            = "top"
theme.titlebar["font"]                = "Liberation Mono 8"
theme.titlebar["bg_focus"]            = pattern(theme.path.."/background/titlebar_focus.png")
theme.titlebar["fg"]                  = "#1692D0"
theme.titlebar["bg"]                  = pattern(theme.path.."/background/titlebar.png")

-- Prompt style
theme.prompt={}  
theme.prompt["fg_cursor"]             = "#00B3FF"
theme.prompt["bg_cursor"]             = "#0F2766"
theme.prompt["ul_cursor"]             = "single"
theme.prompt["font"]                  = "munospace 10"
theme.prompt["cmd"]                   = "<span foreground='#1692D0' font='Sci Fied 8'>CMD:</span> "
theme.prompt["run"]                   = "<span foreground='#1692D0' font='Sci Fied 8'>RUN:</span> "
theme.prompt["lua"]                   = "<span foreground='#1692D0' font='Sci Fied 8'>LUA:</span> "

-- Text widget
theme.widget={}
theme.widget["font"]                  = "Sci Fied 8"
theme.widget["fg"]                    = "#1692D0"
theme.widget["bg"]                    = "#0F2766"
theme.widget["align"]                 = "center"
theme.widget["valign"]                = "center"

-- Radical menus
theme.menu_border_width               = 1
theme.menu_border_color               = "#002F5F"
theme.menu_fg_normal                  = "#1692D0"
theme.menu_bg_normal                  = pattern(theme.path.."/background/radical.png")
theme.menu_bg_focus                   = pattern(theme.path.."/background/radical_focus.png")
theme.menu_bg_header                  = pattern(theme.path.."/background/radical_header.png")
theme.menu_bg_highlight               = pattern(theme.path.."/background/radical_highlight.png")
theme.menu_bg_alternate               = "#004FFF"

-- Naughty settings
naughty.config.defaults.timeout       = 30
naughty.config.defaults.position      = "bottom_right"
naughty.config.defaults.margin        = 1
naughty.config.defaults.gap           = 10
naughty.config.defaults.ontop         = true
naughty.config.defaults.icon_size     = 16
naughty.config.defaults.font          = "Liberation Mono 8"
naughty.config.defaults.fg            = "#000000"
naughty.config.defaults.bg            = "#F7DD65"
naughty.config.defaults.border_color  = "#FFB111"
naughty.config.defaults.border_width  = 1
naughty.config.defaults.hover_timeout = 3

-- Awesome
theme.border_width                    = 1
theme.border_color                    = "#1577D3"
theme.border_normal                   = "#000000"
theme.border_focus                    = "#00346D"
theme.border_marked                   = "#FFF200"
theme.border_tagged                   = "#00FF23"
theme.font                            = "Liberation Sans 9"
theme.bg_normal                       = "#0A1535"
theme.bg_focus                        = "#003687"
theme.bg_urgent                       = "#5B0000"
theme.bg_minimize                     = "#040A1A"
theme.bg_highlight                    = "#0E2051"
theme.bg_alternate                    = "#043A88"
theme.fg_normal                       = "#1577D3"
theme.fg_focus                        = "#00BBD7"
theme.fg_urgent                       = "#FF7777"
theme.fg_minimize                     = "#1577D3"

-- Titlebar icons
theme.titlebar_close_button_normal              = theme.path.."/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = theme.path.."/titlebar/close_focus.png"
theme.titlebar_ontop_button_normal_inactive     = theme.path.."/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme.path.."/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme.path.."/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_active        = theme.path.."/titlebar/ontop_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.path.."/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme.path.."/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme.path.."/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.path.."/titlebar/sticky_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.path.."/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme.path.."/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme.path.."/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.path.."/titlebar/floating_focus_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.path.."/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.path.."/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme.path.."/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.path.."/titlebar/maximized_normal_inactive.png"

-- Set wallpaper 
gears.wallpaper.maximized(theme.wallpaper, 1, true)

return theme
