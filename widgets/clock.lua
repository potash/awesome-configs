--[[
        File:      widgets/clock.lua
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful     = require("awful")
local wibox     = require("wibox")
local common    = require("widgets.common")
local beautiful = require("beautiful")

local module = {}

local function new()
    local widget = awful.widget.textclock("<span font='Crashed Scoreboard 17' color='"..beautiful.widget_text_fg.."'>%H %M</span> ", 60)
    local clock = wibox.widget.background(widget, beautiful.widget_text_bg)
    widget:set_align("center")
    widget:set_valign("center")
    widget.fit = function() return 62,10 end
    local layout = wibox.layout.fixed.horizontal()
    layout:add(common.arrow(5))
    layout:add(clock)
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })