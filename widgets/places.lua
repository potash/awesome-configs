--[[
        File:      widgets/places.lua
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local wibox     = require("wibox")
local beautiful = require("beautiful")
local radical   = require("extern.radical")
local underlay  = require("extern.graph.underlay")
local awful     = require("awful")
local common    = require("widgets.common")
local module = {}

local HOME = os.getenv("HOME")
local OPEN = "krusader --left"

module.PATHS={
    { "Development", HOME.."/Development", beautiful.pl["development"], "D" },
    { "Documents",   HOME.."/Documents",   beautiful.pl["documents"],   "H" },
    { "Downloads",   HOME.."/Downloads",   beautiful.pl["downloads"],   "F" },
    { "Music",       HOME.."/Music",       beautiful.pl["music"],       "M" },
    { "Pictures",    HOME.."/Pictures",    beautiful.pl["pictures"],    "P" },
    { "Videos",      HOME.."/Videos",      beautiful.pl["videos"],      "V" },
    { "www",         HOME.."/public_html", beautiful.pl["public_html"], "W" },
    { "Security",    "/opt/Security",      beautiful.pl["security"],    "S" }
}

module.menu = false
function module.main()
    if not module.menu then
        module.menu = radical.context({
            filer = false, enable_keyboard = true, direction = "bottom",
            x = screen[1].geometry.width - 140,
            y = screen[1].geometry.height - beautiful.wibox["main"].height - (#module.PATHS*beautiful.menu_height) - 22,
        })
        local tags = awful.tag.gettags(1)
        for _,t in ipairs(module.PATHS) do
            module.menu:add_item({
                button1 = function()
                    awful.util.spawn(OPEN.." "..t[2])
                    awful.tag.viewonly(tags[4])
                    common.hide_menu(module.menu)
                end,
                text=t[1], icon=t[3], underlay = underlay(t[4]),
            })
        end
        common.reg_menu(module.menu)
    elseif module.menu.visible then
        common.hide_menu(module.menu)
    else
        common.show_menu(module.menu)
    end
end

-- Text
function module.text()
   return common.cwt({ text="PLACES", width=60, b1=module.main, font="Sci Fied 8" })
end

-- Icon
function module.icon()
   return common.cwi({ icon=beautiful.iw["places"] })
end

--- Return widgets layout
local function new()
    local layout = wibox.layout.fixed.horizontal()
    layout:add(common.arrow(5))
    layout:add(module.icon())
    layout:add(module.text())
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })