--[[
        File:      widgets/sys.lua
        Date:      2014-01-03
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
        TODO:
        1: Parasyti core widgetus (main)
        2: TIMER pvz kas 5min patikrinti free space, memory usage ir jeigu problema tai apie tai pranesti
--]]

local wibox     = require("wibox")
local beautiful = require("beautiful")
local radical   = require("extern.radical")
local awful     = require("awful")
local common    = require("widgets.common")
local dbg       = require("extern.dbg")

local sys_cpu   = require("widgets.sys.cpu")
local sys_mem   = require("widgets.sys.memory")
local sys_net   = require("widgets.sys.network")
local sys_snd   = require("widgets.sys.sound")
local sys_hdd   = require("widgets.sys.disk")
local sys_wea   = require("widgets.sys.weather")
local sys_serv  = require("widgets.sys.services")

local module = {}

--- Header widget
function module.header(args)
   local args = args or {}
   local text = args.text or "N/A"
   local icon = args.icon or ""

   local t = wibox.widget.textbox()
   local w = wibox.widget.background()
   local i = wibox.widget.imagebox()
   local l = wibox.layout.align.horizontal()

   t:set_markup("<span color='#000000' font='Election Day 8' font_weight='light'> ".. text .."</span>")
   t:set_valign("bottom")

   i:set_image(beautiful.path .. "/widgets/sys/"..icon)
   
   l:set_right(i)
   l:set_left(t)
   
   w:set_widget(l)
   w:set_bg("#005CB0")

   return w
end

module.menu = false
function module.main()
    if not module.menu then
        module.menu = radical.context({ direction = "bottom",
            width = 120, x = screen[1].geometry.width - 125, enable_keyboard=false,
            y = screen[1].geometry.height - beautiful.wibox.height - 325 - 60,
            fg="#005CB0"
        })
        module.menu:add_widget(module.header({text="CPU Usage", icon="cpu.svg"      }),  { height = 12  })
        module.menu:add_widget(sys_cpu(module.menu),                                     { height = 104 })
        module.menu:add_widget(module.header({ text="Memory",    icon="mem.svg"     }),  { height = 12  })
        module.menu:add_widget(sys_mem(module.menu),                                     { height = 85  })
        module.menu:add_widget(module.header({ text="Network",   icon="network.svg" }),  { height = 12  })
        module.menu:add_widget(sys_net(module.menu),                                     { height = 65  })
        module.menu:add_widget(module.header({ text="DISK",      icon="disks.svg"   }),  { height = 12  })
        module.menu:add_widget(sys_hdd(module.menu),                                     { height = 60  })

        module.menu.visible = true
    elseif module.menu.visible then
        module.menu.visible = false
    else
        module.menu.visible = true
    end
end

--- Return widgets layout
local function new()
    local layout = wibox.layout.fixed.horizontal()
    layout:add(common.arrow(5))
    layout:add(common.imagebox({ icon=beautiful.path.."/widgets/system.svg" }))
    layout:add(common.textbox({ text="SYS", width=35, b1=module.main }))
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
