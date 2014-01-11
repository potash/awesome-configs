--[[
        File:      widgets/clock.lua
        Date:      2014-01-12
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful     = require("awful")
local wibox     = require("wibox")
local common    = require("widgets.common")
local beautiful = require("beautiful")

local module = {}

local function new()
    local clock = awful.widget.textclock("<span font='Crashed Scoreboard 17' color='"..beautiful.widget["fg"].."'>%H %M</span> ", 60)
    clock:set_align("center")
    clock:set_valign("center")
    clock.fit = function() return 62,10 end
    local widget = wibox.widget.background(clock, beautiful.widget["bg"])
    local layout = wibox.layout.fixed.horizontal()
    layout:add(common.arrow(5))
    layout:add(widget)
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })