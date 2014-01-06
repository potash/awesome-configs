--[[
        File:      widgets/layout.lua
        Date:      2014-01-06
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local underlay  = require("extern.graph.underlay")
local radical   = require("extern.radical")
local common    = require("widgets.common")

local module = {}

local path = beautiful.ICONS.."/layouts/"

-- Layouts table
module.layouts = {
    awful.layout.suit.floating,          -- 1
    awful.layout.suit.tile,              -- 2
    awful.layout.suit.tile.left,         -- 3
    awful.layout.suit.tile.bottom,       -- 4
    awful.layout.suit.tile.top,          -- 5
    awful.layout.suit.fair,              -- 5
    awful.layout.suit.fair.horizontal,   -- 7
    awful.layout.suit.spiral,            -- 8
    awful.layout.suit.spiral.dwindle,    -- 9
    awful.layout.suit.max,               -- 10
    awful.layout.suit.max.fullscreen,    -- 11
    awful.layout.suit.magnifier,         -- 12
}

-- Layouts icons
module.icons = {
    fairh      = path.."fairh.png",
    fairv      = path.."fairv.png",
    floating   = path.."floating.png",
    magnifier  = path.."magnifier.png",
    max        = path.."max.png",
    fullscreen = path.."fullscreen.png",
    tilebottom = path.."tilebottom.png",
    tileleft   = path.."tileleft.png",
    tile       = path.."tile.png",
    tiletop    = path.."tiletop.png",
    spiral     = path.."spiral.png",
    dwindle    = path.."dwindle.png"
}

module.menu = false
function module.main()
    if not module.menu then
        module.menu = radical.context({
            filer = false, enable_keyboard = true, direction = "bottom",
            x = 15,
            y = screen[1].geometry.height - beautiful.wibox["main"].height - (#module.layouts*beautiful.menu_height) - 22})
        local current = awful.layout.get(awful.tag.getscreen(awful.tag.selected()))
        for i, layout_real in ipairs(module.layouts) do
            local layout_name = awful.layout.getname(layout_real)
            if layout_name then
                module.menu:add_item({
                    icon = module.icons[layout_name] or beautiful.cm["none"], 
                    text = layout_name,
                    button1 = function()
                        awful.layout.set(module.layouts[module.menu.current_index] or module.layouts[1], awful.tag.selected())
                        common.hide_menu(module.menu)
                    end,
                    selected = (layout_real == current), underlay = underlay(i),
                })
            end
        end
        common.reg_menu(module.menu)
    elseif module.menu.visible then
        common.hide_menu(module.menu)
    else
        common.show_menu(module.menu)
    end
end

-- Return widgets layout
local function new()
    local layout = wibox.layout.fixed.horizontal()
    local widget = common.imagebox({icon=module.icons[awful.layout.getname(awful.layout.get(1))]})

    local function update()
        widget:set_image(module.icons[awful.layout.getname(awful.layout.get(1))])
    end

    awful.tag.attached_connect_signal(1, "property::selected", update)
    awful.tag.attached_connect_signal(1, "property::layout",   update)

    layout:add(widget)
    layout:add(common.textbox({ text="LAYOUT", width=60, b1=module.main }))
    layout:add(common.arrow(6))
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })