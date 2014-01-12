--[[
        File:      widgets/systray.lua
        Date:      2014-01-12
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")

local module = {}

-- Return systray widget
local function new()
    local layout = wibox.layout.fixed.horizontal()
    local widget = wibox.widget.background()
    widget:set_widget(wibox.widget.systray())
    widget:set_bg("#000000")

    layout:add(widget)
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
