--[[
        File:      widgets/sys/weather.lua
        Date:      2013-12-18
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful     = require("awful")
local vicious   = require("extern.vicious")
local beautiful = require("beautiful")
local wibox     = require("wibox")

local module = {}

local function new()
    local base = wibox.widget.textbox()
    base:set_markup("Weather widgets")
    local layout = wibox.layout.margin()
    layout:set_widget(base)
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })