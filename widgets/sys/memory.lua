--[[
        File:      widgets/sys/memory.lua - provides RAM and Swap usage statistics
        Date:      2014-01-03
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------

TODO: echo 'return collectgarbage("count")' | awesome-client

--]]

local awful      = require("awful")
local vicious    = require("extern.vicious")
local beautiful  = require("beautiful")
local wibox      = require("wibox")
local pg_graph   = require("extern.graph.progress_graph")
local common     = require("widgets.sys.common")

local module = {}

-- Update widgets interval in seconds
module.update = {
    graph_mem  = 60,
	graph_swap = 60,
	usage   = 30,
    swap    = 30,
    buffers = 30,
    cached  = 30
}

-- Graph memory
local function widget_graph_mem()
   local graph = pg_graph()
   graph:set_horizontal(true)
   graph:set_height(13)
   graph:set_width(120)
   graph:set_rounded_size(0.0)
   graph:set_v_margin(1)
   graph:set_h_margin(1)
   graph:set_graph_line_color("#0036B820")
   graph:set_graph_color("#1C6D9550")
   graph:set_show_text(true)
   graph:set_text_color("#0055C8")
   graph:set_graph_background_color("#0055C810")
   graph:set_background_color("#0055C810")
   
   local base = wibox.widget.base.make_widget()
   local img = wibox.widget.imagebox()
   img:set_image(beautiful.ICONS .. "/widgets/background/progress_graph.png")
   base.fit = function(_, width, height) return width, height end
   base.draw = function(_, wb, cr, width, height)
      wibox.layout.base.draw_widget(wb, cr, img, 0, 0, width, height)
      wibox.layout.base.draw_widget(wb, cr, graph, 0, 0, width, height)
   end
   vicious.register(graph, vicious.widgets.mem,
		    function(_,a)
		       if a[1] < 10 then
			  graph:set_graph_color("#00276E60")
		       elseif a[1] < 50 then
			  graph:set_graph_color("#00259050")
		       elseif a[1] < 50 then
			  graph:set_graph_color("#2400B650")
		       elseif a[1] < 50 then
			  graph:set_graph_color("#4100B950")
		       elseif a[1] < 80 then
			  graph:set_graph_color("#67006E50")
		       elseif a[1] == 100 then
			  graph:set_graph_color("#9A002050")
		       end
		       return a[1]
		    end, module.update.graph_mem)
   local L = wibox.layout.margin()
   L:set_widget(base)
   L.fit = function() return 0,13 end
   return L
end
-- Graph swap
local function widget_graph_swap()
   local graph = pg_graph()
   graph:set_horizontal(true)
   graph:set_height(13)
   graph:set_width(120)
   graph:set_rounded_size(0.0)
   graph:set_v_margin(1)
   graph:set_h_margin(1)
   graph:set_graph_line_color("#0036B820")
   graph:set_graph_color("#1C6D9550")
   graph:set_show_text(true)
   graph:set_text_color("#0055C8")
   graph:set_graph_background_color("#0055C810")
   graph:set_background_color("#0055C810")
   
   local base = wibox.widget.base.make_widget()
   local img = wibox.widget.imagebox()
   img:set_image(beautiful.ICONS .. "/widgets/background/progress_graph.png")
   base.fit = function(_, width, height) return width, height end
   base.draw = function(_, wb, cr, width, height)
      wibox.layout.base.draw_widget(wb, cr, img, 0, 0, width, height)
      wibox.layout.base.draw_widget(wb, cr, graph, 0, 0, width, height)
   end
   vicious.register(graph, vicious.widgets.mem,
		    function(_,a)
		       if a[1] < 10 then
			  graph:set_graph_color("#00276E60")
		       elseif a[1] < 50 then
			  graph:set_graph_color("#00259050")
		       elseif a[1] < 50 then
			  graph:set_graph_color("#2400B650")
		       elseif a[1] < 50 then
			  graph:set_graph_color("#4100B950")
		       elseif a[1] < 80 then
			  graph:set_graph_color("#67006E50")
		       elseif a[1] == 100 then
			  graph:set_graph_color("#9A002050")
		       end
		       return a[5]
		    end, module.update.graph_swap)
   local L = wibox.layout.margin()
   L:set_widget(base)
   L.fit = function() return 0,13 end
   return L
end

-- Memory usage
local function widget_memUsage()
    widget,text = common.new_widget({align="right",width=57})
    vicious.register(text, vicious.widgets.mem, '$2 MB', module.update.usage)
    return widget
end
-- Swap usage
local function widget_memSwap()
    widget,text = common.new_widget({align="right",width=57})
    vicious.register(text, vicious.widgets.mem, '$6 MB', module.update.swap) 
    return widget
end
-- Buffers
local function widget_memBuffers()
    widget,text = common.new_widget({align="right",width=57})
    vicious.register(text, vicious.widgets.mem, function(_,a) return a[10].." MB" end, module.update.buffers)
    return widget
end
-- Cached
local function widget_memCached()
    widget,text = common.new_widget({align="right",width=57})
    vicious.register(text, vicious.widgets.mem, function(_,a) return a[11].." MB" end, module.update.cached)
    return widget
end

--- Return widgets layout
local function new()
   vicious.cache(vicious.widgets.mem)

   local layout_mem = wibox.layout.align.horizontal()
   layout_mem:set_left(common.new_widget({text="Memory:",align="left",width=58}))
   layout_mem:set_right(widget_memUsage())

   local layout_swap = wibox.layout.align.horizontal()
   layout_swap:set_left(common.new_widget({text="Swap:",align="left",width=58}))
   layout_swap:set_right(widget_memSwap())

   local layout_buffers = wibox.layout.align.horizontal()
   layout_buffers:set_left(common.new_widget({text="Buffers:",align="left",width=58}))
   layout_buffers:set_right(widget_memBuffers())

   local layout_cached = wibox.layout.align.horizontal()
   layout_cached:set_left(common.new_widget({text="Cached:",align="left",width=58}))
   layout_cached:set_right(widget_memCached())

   local layout = wibox.layout.fixed.vertical()
   layout:add(layout_mem)
   layout:add(layout_swap)
   layout:add(layout_buffers)
   layout:add(layout_cached)
   layout:add(widget_graph_swap())
   layout:add(widget_graph_mem())

   return layout
end


return setmetatable(module, { __call = function(_, ...) return new(...) end })
