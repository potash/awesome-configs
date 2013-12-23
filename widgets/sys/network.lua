--[[
        File:      widgets/sys/network.lua
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
local line_graph = require("extern.graph.line_graph")
local dbg = require("extern.dbg")

local module = {}

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
    vicious.register(graph, vicious.widgets.net, '${eth0 up_kb}', 15)
    local L = wibox.layout.margin()
    L:set_widget(base)
    L.fit = function() return 60,35 end
    return L
end
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
    vicious.register(graph, vicious.widgets.net, '${eth0 down_kb}', 15)
    local L = wibox.layout.margin()
    L:set_widget(base)
    L.fit = function() return 60,35 end
    return L
end
--- Create widgets
-- @param: text
local function new_widget(args)
   local args = args or {}
   local text = args.text or "N/A"
   local width = args.width or 40
   local height = args.height or 12
   local valign = args.valign or beautiful.widget_text_valign or "center"
   local align = args.align or beautiful.widget_text_align or "center"

   local t = wibox.widget.textbox()
   local w = wibox.widget.background()
   local b = wibox.widget.background()
   local m = wibox.layout.margin()
   
   t:set_align(align)
   t:set_valign(valign)
   t.fit = function() return width,height end
   t:set_text(text)
   b:set_bg("#001520")
   b:set_widget(t)
   m:set_margins(1)
   m:set_widget(b)
   w:set_widget(m)
   w:set_bg("#000000")
   
   return w,t
end

--- Return widgets layout
local function new()
   vicious.cache(vicious.widgets.net)
   
   local layout={}
   local text={}
   local usage={}
   
   layout["UP"] = wibox.layout.align.horizontal()
   layout["DW"] = wibox.layout.align.horizontal()
   layout["G"] = wibox.layout.align.horizontal()
   
   text["UP"] = new_widget({ text="Upload:", align="left", width=65 })
   text["DW"] = new_widget({ text="Download:", align="left", width=65 })
   
   local u,d
   usage["UP"],u = new_widget({ align="right", width=50 })
   usage["DW"],d = new_widget({ align="right", width=50 })
   
   vicious.register(u, vicious.widgets.net, '${eth0 up_kb}', 6)
   vicious.register(d, vicious.widgets.net, '${eth0 down_kb}', 6)
   
   layout["UP"]:set_left(text["UP"])
   layout["UP"]:set_right(usage["UP"])

   layout["DW"]:set_left(text["DW"])
   layout["DW"]:set_right(usage["DW"])


   layout["G"]:set_left(widget_graph_up())
   layout["G"]:set_right(widget_graph_dw())

   layout["main"] = wibox.layout.fixed.vertical()
   layout["main"]:add(layout["G"])
   layout["main"]:add(layout["UP"])
   layout["main"]:add(layout["DW"])

   return layout["main"]
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
