--[[
        File:      widgets/sys/cpu.lua
        Date:      2014-01-03
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful      = require("awful")
local vicious    = require("extern.vicious")
local beautiful  = require("beautiful")
local wibox      = require("wibox")
local graph      = require("extern.graph.line_graph")
local common     = require("widgets.sys.common")

local module = {}

-- Update widgets interval in seconds
module.update = {
    graph = 5,
    load = 60,
    temp = 60,
    cpu = 6
}

-- Graph widget
local function widget_graph()
    local graph = graph()
    graph:set_height(61)
    graph:set_width(120)
    graph:set_graph_line_color("#0036B8")
    graph:set_graph_color("#1C6D9550")
    
    local base = wibox.widget.base.make_widget()
    local img = wibox.widget.imagebox()
    img:set_image(beautiful.ICONS .. "/widgets/background/sys.png")
    base.fit = function(_, width, height) return width, height end
    base.draw = function(_, wb, cr, width, height)
        wibox.layout.base.draw_widget(wb, cr, img, 0, 0, width, height)
        wibox.layout.base.draw_widget(wb, cr, graph, 0, 0, width, height)
    end
    vicious.register(graph, vicious.widgets.cpu, '$1', module.update.graph)
    local layout = wibox.layout.margin()
    layout:set_widget(base)
    layout.fit = function() return 0,61 end
    return layout
end
-- CPU Load
local function widget_cpuLoad()
    widget,text  = common.new_widget({ align="right", width=57 })
    vicious.register(text, vicious.widgets.uptime, '$4',  module.update.load)
    return widget
end
-- CPU temp
local function widget_cpuTemp()
    widget,text = common.new_widget({ align="right", width=57 })
    vicious.register(text, vicious.contrib.sensors, '$1℃', module.update.temp, 'Core0 Temp')
    return widget
end
-- CPU usage
local function widget_cpuUsage()
    widget,text  = common.new_widget({ align="right", width=57 })
    vicious.register(text, vicious.widgets.cpu, '$1%', module.update.cpu)
    return widget
end

--- Return widgets layout
local function new(menu)
    vicious.cache(vicious.widgets.cpu)
    vicious.cache(vicious.widgets.uptime)

    local layout_cpu = wibox.layout.align.horizontal()
    layout_cpu:set_left(common.new_widget({ text="Usage:", align="left", width=58 }))
    layout_cpu:set_right(widget_cpuUsage())

    local layout_load = wibox.layout.align.horizontal()
    layout_load:set_left(common.new_widget({ text="Load:",  align="left", width=58 }))
    layout_load:set_right(widget_cpuLoad())

    local layout_temp = wibox.layout.align.horizontal()
    layout_temp:set_left(common.new_widget({ text="Temp:",  align="left", width=58 }))
    layout_temp:set_right(widget_cpuTemp())

    local layout = wibox.layout.fixed.vertical()
    layout:add(widget_graph())
    layout:add(layout_load)
    layout:add(layout_cpu)
    layout:add(layout_temp)

    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
