--[[
        File:      darkBlue.lua
        Date:      2013-10-28
      Author:      Emmanuel Lepage Vallee <elv1313@gmail.com>
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local gears   = require("gears")
local awful   = require("awful")
local naughty = require("naughty")

local theme = {}

local ICONS = awful.util.getdir("config").."/theme/darkBlue"
theme.ICONS = ICONS

theme.wallpaper                  = ICONS.."/background.png"
theme.arrow                      = ICONS.."/arrow"
theme.menu_submenu_icon          = ICONS.."/submenu.png"
theme.path                       = ICONS
theme.awesome_icon               = "/usr/share/awesome/icons/awesome16.png"
theme.menu_height                = 20
theme.popup_time_out             = 3
theme.icon_theme                 = nil

gears.wallpaper.maximized(theme.wallpaper, 1, true)

-- Naughty library settings
naughty.config.defaults.timeout       = 30
naughty.config.defaults.position      = "bottom_right"
naughty.config.defaults.margin        = 1
naughty.config.defaults.gap           = 10
naughty.config.defaults.ontop         = true
naughty.config.defaults.icon_size     = 16
naughty.config.defaults.font          = "monospace 8"
naughty.config.defaults.fg            = "#000000"
naughty.config.defaults.bg            = "#F7DD65"
naughty.config.defaults.border_color  = "#FFB111"
naughty.config.defaults.border_width  = 1
naughty.config.defaults.hover_timeout = 3

-- Main wibox settings
theme.wibox={}
theme.wibox["main"]={}
theme.wibox["main"].enable       = true
theme.wibox["main"].position     = "bottom"
theme.wibox["main"].height       = 16
theme.wibox["main"].bg           = "#0F2766"
theme.wibox["main"].fg           = "#1692D0"

-- Widget icons
theme.iw={}
theme.iw["places"]               = ICONS.."/widgets/places.svg"
theme.iw["menu"]                 = ICONS.."/widgets/menu.svg"
theme.iw["run"]                  = ICONS.."/widgets/run.svg"
theme.iw["tag"]                  = ICONS.."/widgets/workspace.svg"
theme.iw["kbd"]                  = ICONS.."/widgets/keyboard.svg"

-- Places
theme.pl={}
theme.pl["development"]          = ICONS.."/places/development.svg"
theme.pl["documents"]            = ICONS.."/places/documents.svg"
theme.pl["downloads"]            = ICONS.."/places/downloads.svg"
theme.pl["music"]                = ICONS.."/places/music.svg"
theme.pl["pictures"]             = ICONS.."/places/pictures.svg"
theme.pl["videos"]               = ICONS.."/places/videos.svg"
theme.pl["public_html"]          = ICONS.."/places/public_html.svg"
theme.pl["security"]             = ICONS.."/places/security.svg"

-- Client menu
theme.cm={}
theme.cm["close"]                = ICONS.."/client/close.svg"
theme.cm["save"]                 = ICONS.."/client/save.svg"
theme.cm["maximize"]             = ICONS.."/client/maximize.svg"
theme.cm["floating"]             = ICONS.."/client/floating.svg"
theme.cm["sticky"]               = ICONS.."/client/sticky.svg"
theme.cm["ontop"]                = ICONS.."/client/ontop.svg"
theme.cm["titlebar"]             = ICONS.."/client/titlebar.svg"
theme.cm["move"]                 = ICONS.."/client/move.svg"
theme.cm["none"]                 = ICONS.."/client/none.svg"

-- Layout icons
theme.li={}
theme.li["layout_fairh"]         = ICONS.."/layouts/fairh.png"
theme.li["layout_fairv"]         = ICONS.."/layouts/fairv.png"
theme.li["layout_floating"]      = ICONS.."/layouts/floating.png"
theme.li["layout_magnifier"]     = ICONS.."/layouts/magnifier.png"
theme.li["layout_max"]           = ICONS.."/layouts/max.png"
theme.li["layout_fullscreen"]    = ICONS.."/layouts/fullscreen.png"
theme.li["layout_tilebottom"]    = ICONS.."/layouts/tilebottom.png"
theme.li["layout_tileleft"]      = ICONS.."/layouts/tileleft.png"
theme.li["layout_tile"]          = ICONS.."/layouts/tile.png"
theme.li["layout_tiletop"]       = ICONS.."/layouts/tiletop.png"
theme.li["layout_spiral"]        = ICONS.."/layouts/spiral.png"
theme.li["layout_dwindle"]       = ICONS.."/layouts/dwindle.png"

theme.taglist_squares_sel        = ICONS.."/tags/squares_sel.png"
theme.taglist_squares_unsel      = ICONS.."/tags/squares_unsel.png"

-- Applications menu
theme.mapp={}
theme.mapp["work"]               = ICONS.."/launcher/work.svg"
theme.mapp["network"]            = ICONS.."/launcher/network.svg"
theme.mapp["development"]        = ICONS.."/launcher/development.svg"
theme.mapp["file_Manager"]       = ICONS.."/launcher/file_manager.svg"
theme.mapp["messenger"]          = ICONS.."/launcher/messenger.svg"
theme.mapp["reader"]             = ICONS.."/launcher/reader.svg"
theme.mapp["graphics"]           = ICONS.."/launcher/graphics.svg"
theme.mapp["multimedia"]         = ICONS.."/launcher/multimedia.svg"
theme.mapp["office"]             = ICONS.."/launcher/office.svg"
theme.mapp["system"]             = ICONS.."/launcher/system.svg"
theme.mapp["miscellaneous"]      = ICONS.."/launcher/miscellaneous.svg"
theme.mapp["awesome"]            = ICONS.."/launcher/awesome.svg"
theme.qapp={}
theme.qapp["terminal"]           = ICONS.."/launcher/quick/terminal.svg"
theme.qapp["file-manager"]       = ICONS.."/launcher/quick/file-manager.svg"
theme.qapp["browser"]            = ICONS.."/launcher/quick/browser.svg"
theme.qapp["editor"]             = ICONS.."/launcher/quick/editor.svg"
theme.qapp["email"]              = ICONS.."/launcher/quick/email.svg"
theme.qapp["IDE"]                = ICONS.."/launcher/quick/IDE.svg"
theme.qapp["irc"]                = ICONS.."/launcher/quick/irc.svg"
theme.qapp["proc"]               = ICONS.."/launcher/quick/proc.svg"

-- Menu icons
theme.im={}
theme.im["halt"]   = ICONS.."/menu/halt.svg"
theme.im["quit"]   = ICONS.."/menu/quit.svg"
theme.im["reboot"] = ICONS.."/menu/reboot.svg"
theme.im["lock"]   = ICONS.."/menu/lock.svg"
theme.im["screen"] = ICONS.."/menu/screen.svg"


theme.border_width   = 1
theme.border_color   = "#1577D3"
theme.border_normal  = "#000000"
theme.border_focus   = "#00346D"
theme.border_marked  = "#FFF200"
theme.border_tagged  = "#00FF23"

theme.font           = "Sans 8"

theme.bg_normal      = "#0A1535"
theme.bg_focus       = "#003687"
theme.bg_urgent      = "#5B0000"
theme.bg_minimize    = "#040A1A"
theme.bg_highlight   = "#0E2051"
theme.bg_alternate   = "#043A88"

theme.fg_normal      = "#1577D3"
theme.fg_focus       = "#00BBD7"
theme.fg_urgent      = "#FF7777"
theme.fg_minimize    = "#1577D3"

theme.menu_border_width = 1
theme.menu_border_color = "#002E69"

--theme.menu_fg_focus = "#FF001A"
theme.menu_bg_focus = "#002251"

theme.menu_bg_normal = "#001734"
theme.menu_fg_normal = "#1692D0"

theme.menu_bg_alternate = "#004FFF"
theme.menu_bg_highlight = "#001026"
--theme.menu_bg_header    = "#FFFFFF"


-- widget text
--theme.widget_text_font = "Sci Fied 8"
theme.widget_text_font    = "Sans 8"
theme.widget_text_fg      = "#1692D0"
theme.widget_text_bg      = "#0F2766"
theme.widget_text_align   = "center"
theme.widget_text_valign  = "center"

theme.widget_usage_font   = "Ticking Timebomb BB 10"
theme.widget_usage_fg     = "#1692D0"
theme.widget_usage_bg     = "#00121E"
theme.widget_usage_align  = "center"
theme.widget_usage_valign = "center"

theme.taglist_font         = "Sci Fied 10"
theme.tasklist_font        = "Ticking Timebomb BB 11"
theme.taglist_disable_icon = true

-- Title-bar icons
theme.titlebar_close_button_normal              = ICONS.."/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = ICONS.."/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive     = ICONS.."/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = ICONS.."/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = ICONS.."/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = ICONS.."/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = ICONS.."/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = ICONS.."/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = ICONS.."/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = ICONS.."/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = ICONS.."/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = ICONS.."/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = ICONS.."/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = ICONS.."/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = ICONS.."/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = ICONS.."/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = ICONS.."/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = ICONS.."/titlebar/maximized_focus_active.png"

return theme
