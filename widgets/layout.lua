--[[
        File:      widgets/layout.lua
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
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

module.timer={}
module.timer[1] = timer{timeout = beautiful.popup_time_out}
module.timer[1]:connect_signal("timeout", function()
    if module.menu.visible then
        module.menu.visible = false
        keygrabber.stop()
        module.timer[1]:stop()
    end
end)

function module.timer_stop()
    if module.timer[1].started then
        module.timer[1]:stop()
        keygrabber.stop()
    end
end
function module.timer_start()
    if not module.timer[1].started then
        module.timer[1]:start()
    end
end

module.menu = false
function module.main()
    if not module.menu then
        module.menu = radical.context({
            filer = false, enable_keyboard = true, direction = "bottom", x = 15,
            y = screen[1].geometry.height - beautiful.wibox["main"].height - (#module.layouts*beautiful.menu_height) - 22})
        local current = awful.layout.get(awful.tag.getscreen(awful.tag.selected()))
        for i, layout_real in ipairs(module.layouts) do
            local layout_name = awful.layout.getname(layout_real)
            if layout_name then
                module.menu:add_item({
                    icon = beautiful.li["layout_" .. layout_name] or beautiful.cm["none"], text = layout_name,
                    button1 = function(_, mod)
                        awful.layout.set(module.layouts[module.menu.current_index] or module.layouts[1], awful.tag.selected())
                        module.menu.visible = false
                        module.timer_stop()
                    end,
                    selected = (layout_real == current),
                    underlay = underlay(i),
                })
            else
                dbg.error(layout_name.." Failed.")
            end
        end
        module.timer_start()
        module.menu.visible = true
    elseif module.menu.visible then
        module.menu.visible = false
        module.timer_stop()
    else
        module.menu.visible = true
        module.timer_start()
    end
end

-- Widget text
function module.text()
    return common.cwt({ text="LAYOUT", width=60, b1=module.main, font="Sci Fied 8" })
end

-- Widget icon
function module.icon()
    -- try to get the layout icon
    local function geticon()
        if beautiful.li then
            return beautiful.li["layout_" ..awful.layout.getname(awful.layout.get(1))]
        else
            return
        end
    end
    
    -- Create widget
    local widget = common.cwi({icon=geticon()})
    
    -- When tag property changes update layout icon.
    local function update()
        widget:set_image(geticon())
    end
    awful.tag.attached_connect_signal(1, "property::selected", update)
    awful.tag.attached_connect_signal(1, "property::layout",   update)

    return widget
end

-- Return widgets layout
local function new()
    local layout = wibox.layout.fixed.horizontal()
    layout:add(module.icon())
    layout:add(module.text())
    layout:add(common.arrow(6))
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })