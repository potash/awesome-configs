--[[
        File:      widgets/sys/disk.lua
        Date:      2013-12-18
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]


local awful      = require("awful")
local vicious    = require("extern.vicious")
local beautiful  = require("beautiful")
local wibox      = require("wibox")
local progress_graph      = require("extern.graph.progress_graph")
local common     = require("widgets.sys.common")

local dbg = require("extern.dbg")

local module = {}

local function widget_graph_mem()
   local graph = progress_graph()
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
		    end, 1)
   local L = wibox.layout.margin()
   L:set_widget(base)
   L.fit = function() return 0,13 end
   return L
end


local function widget_graph_swap()
   local graph = progress_graph()
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
		    end, 1)
   local L = wibox.layout.margin()
   L:set_widget(base)
   L.fit = function() return 0,13 end
   return L
end

--- Return widgets layout
local function new()
   vicious.cache(vicious.widgets.mem)
   
   local layout={}
   local text={}
   local usage={}
   
   layout["root"] = wibox.layout.align.horizontal()
   layout["data"] = wibox.layout.align.horizontal()
   layout["cloud"] = wibox.layout.align.horizontal()

   text["root"] = common.new_widget({text="root:",align="left",width=58})
   text["data"] = common.new_widget({text="Data:",align="left",width=58})
   text["cloud"] = common.new_widget({text="Cloud:",align="left",width=58})
      
   local r,d,c
   usage["root"],r = common.new_widget({align="right",width=57})
   usage["data"],d = common.new_widget({align="right",width=57})
   usage["cloud"],c = common.new_widget({align="right",width=57})

   vicious.register(r, vicious.widgets.mem, '$2 MB', 1)
   vicious.register(d, vicious.widgets.mem, '$6 MB', 1)
   vicious.register(c, vicious.widgets.mem, '$6 MB', 1)

   layout["root"]:set_left(text["root"])
   layout["root"]:set_right(usage["root"])

   layout["data"]:set_left(text["data"])
   layout["data"]:set_right(usage["data"])
   
   layout["data"]:set_left(text["data"])
   layout["data"]:set_right(usage["data"])
   
   layout["main"] = wibox.layout.fixed.vertical()
   layout["main"]:add(layout["root"])
   layout["main"]:add(layout["data"])
   layout["main"]:add(widget_graph_swap())
   layout["main"]:add(widget_graph_mem())

   return layout["main"]
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
