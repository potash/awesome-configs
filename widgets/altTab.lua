--[[
        File:      widgets/altTab.lua
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]
local awful     = require("awful")
local radical   = require("extern.radical")
local underlay  = require("extern.graph.underlay")
local beautiful = require("beautiful")

local module = {}

local style=radical.style.classic
local item_style=radical.item_style.classic

module.menu= {}
module.timer={}

module.timer[1] = timer{timeout = beautiful.popup_time_out}
module.timer[1]:connect_signal("timeout", function()
    if module.menu.visible then
        module.menu.visible = false
        keygrabber.stop()
    end
end)
function module.timer_restart()
    if module.timer[1].started then
        module.timer[1]:stop()
    end
    module.timer[1]:start()
end

local function new()
    module.timer_restart()
    module.menu = radical.box({filter = true, show_filter = true, style = style, item_style = item_style})
    module.menu:add_key_hook({}, "Tab", "press", function()
        module.timer_restart()
        local item = module.menu.next_item
        item.selected = true
        item.button1()
        return true
    end)
    for _,v in pairs(client.get(1)) do
        module.menu:add_item({
            text = awful.util.escape(v.name) or "N/A",
            button1 = function()
                module.timer_restart()
                if v:tags()[1] and v:tags()[1].selected == false then
                    awful.tag.viewonly(v:tags()[1])
                end
                client.focus = v
            end,
            icon = v.icon or beautiful.cm["none"],
            selected = client.focus == v,
            underlay = underlay(v:tags()[1].name)
        })
    end
    module.menu.visible  = true
    return module.menu
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })