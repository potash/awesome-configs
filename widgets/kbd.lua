--[[
        File:      widgets/kbd.lua
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
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
module.lang["lt"]="Lithuanian"
module.lang["us"]="English"
--module.lang["ru"]="Russian" -- FIXME: well, now RU keybindings are corrupted (WHY?)

module.current = "us" -- default.
function module.set(lang_layout)
    if module.widget and lang_layout ~= module.current then
        awful.util.spawn("setxkbmap "..lang_layout)
        module.widget:set_markup("<b>"..string.upper(lang_layout).."</b>")
        module.current = lang_layout
        --dbg.info("Keyboard layout changed to <b>"..module.lang[lang_layout].."</b>")
    end
end

local k = {}
k.layout = awful.util.table.keys(module.lang)
k.current = 1  -- us is our default layout
function module.switch()
    k.current = k.current % #(k.layout) + 1
    module.set(k.layout[k.current])
end

module.menu = false
function module.main()
    if not module.menu then
        module.menu = radical.context({
            filer = false, enable_keyboard = true, direction = "bottom", x = screen[1].geometry.width - 220,
            y = screen[1].geometry.height - beautiful.wibox["main"].height - (#awful.util.table.keys(module.lang)*beautiful.menu_height) - 22,
        })
        for k,v in pairs(module.lang) do
            module.menu:add_item({text = v,
                button1 = function() module.set(k) module.menu.visible = false end,
                icon = beautiful.path.."/flags/"..k..".png", underlay = underlay(string.upper(k))
            })
        end
        module.menu.visible = true
    elseif module.menu.visible then
        module.menu.visible = false
    else
        module.menu.visible = true
    end
end

-- Text
function module.text()
    local w,c  = common.cwu({ text=string.upper(module.current), width=35, b1=module.main, b3=module.switch, bg="#0F2766", font="Sci Fied 8", align="bottom" })
    module.widget = c
    return w
end

-- Icon
function module.icon()
   return common.cwi({ icon=beautiful.iw["kbd"] })
end

local function new()
    local layout = wibox.layout.fixed.horizontal()
    layout:add(common.arrow(5))
    layout:add(module.icon())
    layout:add(module.text())
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })