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
local path = beautiful.ICONS.."/places/"

local PATHS = {
    { "Home",        HOME,                 path.."home.svg",        "N" },
    { "Cloud",       HOME.."/Cloud",       path.."remote.svg",      "R" },
    { "Development", HOME.."/Development", path.."development.svg", "D" },
    { "Workspace",   HOME.."/Workspace",   path.."workspace.svg",   "T" },
    { "Documents",   HOME.."/Documents",   path.."documents.svg",   "H" },
    { "Downloads",   HOME.."/Downloads",   path.."downloads.svg",   "F" },
    { "Music",       HOME.."/Music",       path.."music.svg",       "M" },
    { "Pictures",    HOME.."/Pictures",    path.."pictures.svg",    "P" },
    { "Videos",      HOME.."/Videos",      path.."videos.svg",      "V" },
    { "www",         HOME.."/public_html", path.."public_html.svg", "W" },
    { "Security",    "/opt/Security",      path.."security.svg",    "S" }
}

module.menu = false
function module.main()
    if not module.menu then
        module.menu = radical.context({
            filer = false, enable_keyboard = true, direction = "bottom",
            x = screen[1].geometry.width - 140,
            y = screen[1].geometry.height - beautiful.wibox["main"].height - (#PATHS*beautiful.menu_height) - 22,
        })
        local tags = awful.tag.gettags(1)
        for _,t in ipairs(PATHS) do
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

--- Return widgets layout
local function new()
    local layout = wibox.layout.fixed.horizontal()
    layout:add(common.arrow(5))
    layout:add(common.cwi({ icon=beautiful.iw["places"] }))
    layout:add(common.cwt({ text="PLACES", width=60, b1=module.main, font="Sci Fied 8" }))
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })