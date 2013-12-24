--[[
        File:      widgets/sys/cpu.lua
        Date:      2013-12-18
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
            TODO:
            1: echo 'return collectgarbage("count")' | awesome-client
--]]

local awful      = require("awful")
local vicious    = require("extern.vicious")
local beautiful  = require("beautiful")
local wibox      = require("wibox")
local line_graph = require("extern.graph.line_graph")

local module = {}

-- Get CPU usage
local cpu = {}
local cpu_usage  = {}
local cpu_total  = {}
local cpu_active = {}
function module.cpuUsage()
    local cpu_lines = {}
    -- Get CPU stats
    local f = io.open("/proc/stat")
    for line in f:lines() do
        if string.sub(line, 1, 3) ~= "cpu" then break end
        cpu_lines[#cpu_lines+1] = {}
        for i in string.gmatch(line, "[%s]+([^%s]+)") do
            table.insert(cpu_lines[#cpu_lines], i)
        end
    end
    f:close()

    -- Ensure tables are initialized correctly
    for i = #cpu_total + 1, #cpu_lines do
        cpu_total[i]  = 0
        cpu_usage[i]  = 0
        cpu_active[i] = 0
    end

    for i, v in ipairs(cpu_lines) do
        -- Calculate totals
        local total_new = 0
        for j = 1, #v do
            total_new = total_new + v[j]
        end
        local active_new = total_new - (v[4] + v[5])

        -- Calculate percentage
        local diff_total  = total_new - cpu_total[i]
        local diff_active = active_new - cpu_active[i]

        if diff_total == 0 then diff_total = 1E-6 end
        cpu_usage[i]      = math.floor((diff_active / diff_total) * 100)

        -- Store totals
        cpu_total[i]   = total_new
        cpu_active[i]  = active_new
    end
    dbg.dump(cpu_usage)
    return cpu_usage
end

-- Timer
function module.timer()
    local wtimer = timer{ timeout = 5 }
    wtimer:connect_signal("timeout", function() end)
    wtimer:start()
end

--
-- Graph
local function widget_graph()
    local graph = line_graph()
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
    vicious.register(graph, vicious.widgets.cpu, '$1', 5)
    local layout = wibox.layout.margin()
    layout:set_widget(base)
    layout.fit = function() return 0,61 end
    return layout
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

local function draw()
   local layout={}
   layout["usage"] = wibox.layout.align.horizontal()
   layout["load"] = wibox.layout.align.horizontal()
   layout["temp"] = wibox.layout.align.horizontal()

   local text={}
   local usage={}
    
   text["load"] = new_widget({ text="Load:", align="left", width=58 })
   text["cpu"]  = new_widget({ text="Usage:", align="left", width=58 })
   text["temp"] = new_widget({ text="Temp:", align="left", width=58 })
   
   usage["cpu"],c  = new_widget({ align="right", width=57 })
   usage["load"],l = new_widget({ align="right", width=57 })
   usage["temp"],t = new_widget({ align="right", width=57 })
    
   vicious.register(t, vicious.contrib.sensors, '$1℃', 30, 'Core0 Temp')
   vicious.register(l, vicious.widgets.uptime, '$4', 60)
   vicious.register(c, vicious.widgets.cpu, '$1%', 5)
   
   layout["usage"]:set_left(text["cpu"])
   layout["usage"]:set_right(usage["cpu"])

   layout["load"]:set_left(text["load"])
   layout["load"]:set_right(usage["load"])

   layout["temp"]:set_left(text["temp"])
   layout["temp"]:set_right(usage["temp"])

   layout["main"] = wibox.layout.fixed.vertical()
   layout["main"]:add(widget_graph())
   layout["main"]:add(layout["load"])
   layout["main"]:add(layout["usage"])
   layout["main"]:add(layout["temp"])

   return layout["main"]
end

--- Return widgets layout
local function new(menu)
	vicious.cache(vicious.widgets.cpu)
	vicious.cache(vicious.widgets.uptime)

	local widget = draw()
	return widget
end


return setmetatable(module, { __call = function(_, ...) return new(...) end })
