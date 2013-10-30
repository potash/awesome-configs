--[[
        File:      widgets/clock.lua
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful  = require("awful")
local wibox  = require("wibox")
local common = require("widgets.common")

local module = {}

-- Create a clock widget
function module.text()
    local widget = awful.widget.textclock("<span font='Crashed Scoreboard 17' color='#1692D0' >%H %M</span> ", 60)
    local clock     = wibox.widget.background(widget, "#0F2766")
    widget:set_align("center")
    widget:set_valign("center")
    widget.fit = function() return 65,10 end
    return clock
end

local function new()
    local layout = wibox.layout.fixed.horizontal()
    layout:add(common.arrow(5))
    layout:add(module.text())
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })