--[[
        File:      widgets/kbd.lua
        Date:      2014-01-12
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local radical   = require("extern.radical")
local underlay  = require("extern.graph.underlay")
local common    = require("widgets.common")

local module = {}

module.lang={}
module.lang["us"]="English"
module.lang["lt"]="Lithuanian"
--module.lang["ru"]="Russian" -- BUG: RU keybindings are corrupted (#982)
module.current = "us" -- default.
function module.set(lang_layout)
    if module.widget and lang_layout ~= module.current then
        awful.util.spawn("setxkbmap "..lang_layout, false)
        module.widget:set_markup("<b>"..string.upper(lang_layout).."</b>")
        module.current = lang_layout
    end
end

local kbd = {}
kbd.layout = awful.util.table.keys(module.lang)
kbd.current = 1  -- US is our default layout
function module.switch()
    kbd.current = kbd.current % #(kbd.layout) + 1
    module.set(kbd.layout[kbd.current])
end

module.menu = false
function module.main()
    if not module.menu then
        module.menu = radical.context({
            filer = false, enable_keyboard = true, direction = "bottom", x = screen[1].geometry.width - 285,
            y = screen[1].geometry.height - beautiful.wibox.height - (#awful.util.table.keys(module.lang)*beautiful.menu_height) - 22,
        })
        for k,v in pairs(module.lang) do
            module.menu:add_item({text = v,
                button1 = function() module.set(k) common.hide_menu(module.menu) end,
                icon = beautiful.path.."/flags/"..k..".png", underlay = underlay(string.upper(k))
            })
        end
        common.reg_menu(module.menu)
    elseif module.menu.visible then
        common.hide_menu(module.menu)
    else
        common.show_menu(module.menu)
    end
end

local function new()
    local layout = wibox.layout.fixed.horizontal()
    local w,c  = common.textbox({text=string.upper(module.current),width=35,b1=module.main,b3=module.switch})
    module.widget = c
    layout:add(common.arrow(5))
    layout:add(common.imagebox({ icon=beautiful.path.."/widgets/keyboard.svg" }))
    layout:add(w)
    return layout
end



return setmetatable(module, { __call = function(_, ...) return new(...) end })
