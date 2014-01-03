--[[
        File:      widgets/sys/network.lua
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
local line_graph = require("extern.graph.line_graph")
local common     = require("widgets.sys.common")

local module = {}

module.update = {
    graph_up = 60,
	graph_dw = 60,
	up = 30,
    dw = 30,
}

-- Upload graph
local function widget_graph_up()
    local graph = line_graph()
    graph:set_height(35)
    graph:set_width(59)
    graph:set_graph_line_color("#034100")
    graph:set_graph_color("#1C6D9550")
    
    local base = wibox.widget.base.make_widget()
    local img = wibox.widget.imagebox()
    img:set_image(beautiful.ICONS .. "/widgets/background/graph2.png")
    base.fit = function(_, width, height) return width, height end
    base.draw = function(_, wb, cr, width, height)
        wibox.layout.base.draw_widget(wb, cr, img, 0, 0, width, height)
        wibox.layout.base.draw_widget(wb, cr, graph, 0, 0, width, height)
    end
    vicious.register(graph, vicious.widgets.net, '${eth0 up_kb}', module.update.graph_up)
    local L = wibox.layout.margin()
    L:set_widget(base)
    L.fit = function() return 60,35 end
    return L
end
-- Download graph
local function widget_graph_dw()
    local graph = line_graph()
    graph:set_height(35)
    graph:set_width(59)
    graph:set_graph_line_color("#440500")
    graph:set_graph_color("#1C6D9550")
    
    local base = wibox.widget.base.make_widget()
    local img = wibox.widget.imagebox()
    img:set_image(beautiful.ICONS .. "/widgets/background/graph2.png")
    base.fit = function(_, width, height) return width, height end
    base.draw = function(_, wb, cr, width, height)
        wibox.layout.base.draw_widget(wb, cr, img, 0, 0, width, height)
        wibox.layout.base.draw_widget(wb, cr, graph, 0, 0, width, height)
    end
    vicious.register(graph, vicious.widgets.net, '${eth0 down_kb}', module.update.graph_dw)
    local L = wibox.layout.margin()
    L:set_widget(base)
    L.fit = function() return 60,35 end
    return L
end

-- Upload
local function widget_netUpload()
    widget,text = common.new_widget({align="right",width=57})
    vicious.register(text, vicious.widgets.net, '${eth0 up_kb}', module.update.up)
    return widget
end
-- Download
local function widget_netDownload()
    widget,text = common.new_widget({align="right",width=57})
    vicious.register(text, vicious.widgets.net, '${eth0 down_kb}', module.update.dw)
    return widget
end

-- Return widgets layout
local function new()
   vicious.cache(vicious.widgets.net)

   layout_up = wibox.layout.align.horizontal()
   layout_up:set_left(common.new_widget({ text="Upload:", align="left", width=58 }))
   layout_up:set_right(widget_netUpload())

   layout_dw = wibox.layout.align.horizontal()
   layout_dw:set_left(common.new_widget({ text="Download:", align="left", width=58 }))
   layout_dw:set_right(widget_netDownload())

   layout_graph = wibox.layout.align.horizontal()
   layout_graph:set_left(widget_graph_up())
   layout_graph:set_right(widget_graph_dw())

   layout = wibox.layout.fixed.vertical()
   layout:add(layout_graph)
   layout:add(layout_up)
   layout:add(layout_dw)

   return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
