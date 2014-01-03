--[[
        File:      widgets/sys/disk.lua
        Date:      2014-01-03
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful      = require("awful")
local vicious    = require("extern.vicious")
local beautiful  = require("beautiful")
local wibox      = require("wibox")
local common     = require("widgets.sys.common")

local module = {}

-- Update widgets interval in seconds
module.update = {
    fs = 120
}

local function draw(fs)
    local layout = wibox.layout.align.horizontal()
	 local progressbar = awful.widget.progressbar()
	 progressbar:set_border_color("#000000")
	 progressbar:set_color("#004176")
	 progressbar:set_background_color("#001C2B")
	 progressbar:set_ticks(true)
	 progressbar:set_ticks_gap(1)
	 progressbar:set_ticks_size(2)
	 progressbar:set_width(50)
	 progressbar:set_height(5)
	 vicious.register(progressbar, vicious.widgets.fs, '${'..fs[2]..' used_p}', module.update.fs)
	 local usage,avail  = common.new_widget({ align="right", width=55 })
    vicious.register(avail, vicious.widgets.fs, '${'..fs[2]..' used_p} %', module.update.fs)
	 layout:set_left(common.new_widget({ text=fs[1],  align="left", width=60 }))
	 layout:set_middle(progressbar)
	 layout:set_right(usage)

	 return layout
end

--- Return widgets layout
local function new()
	 vicious.cache(vicious.widgets.fs)
	 local layout = wibox.layout.fixed.vertical()
	 for _,k in ipairs(beautiful.sys.fs) do
		  layout:add(draw(k))
	 end
	 return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
