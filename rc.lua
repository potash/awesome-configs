--[[
        File:      rc.lua
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

-- Debugging utilities (signails, functions, notifications...)
local dbg       = require("extern.dbg")
dbg()

-- Awesome library
local awful     = require("awful")
awful.rules     = require("awful.rules")
awful.wibox     = require("awful.wibox")
local wibox     = require("wibox")
local beautiful = require("beautiful")
require("awful.autofocus")
-- Initializes the theme system
beautiful.init(awful.util.getdir('config').."/theme/darkBlue.lua")

local awfuldb   = require("extern.awfuldb")
local widgets   = require("widgets")
local layout    = {}
local keys      = {}

-- Wibox layouts
layout["right"] = wibox.layout.fixed.horizontal()
layout["left"]  = wibox.layout.fixed.horizontal()
layout["wibox"] = wibox.layout.align.horizontal()

local main = awful.wibox({
    position = beautiful.wibox["main"].position,
    height = beautiful.wibox["main"].height
})

main:set_bg(beautiful.wibox["main"].bg)

-- Widgets that are aligned to the left
layout["left"]:add(widgets.layout())
layout["left"]:add(widgets.menu())
layout["left"]:add(widgets.taglist())
layout["left"]:add(widgets.prompt())

-- Widgets that are aligned to the right
layout["right"]:add(wibox.widget.systray())
layout["right"]:add(widgets.kbd())
layout["right"]:add(widgets.places())
layout["right"]:add(widgets.sys())
layout["right"]:add(widgets.clock())

-- Now bring it all together (with the tasklist in the middle)
layout["wibox"]:set_left(layout["left"])
layout["wibox"]:set_middle(widgets.tasklist())
layout["wibox"]:set_right(layout["right"])

main:set_widget(layout["wibox"])

local function spawn(cmd)
    awful.util.spawn(cmd.." &>/dev/null", false)
end

-- Mouse bindings
keys["mouse"] = awful.util.table.join(
    awful.button({ }, 3, function() widgets.menu.main_app() end)
)
-- Client mouse bindings
keys["buttons"] = awful.util.table.join(
    awful.button({        }, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ "Mod4" }, 1, awful.mouse.client.move                    ),
    awful.button({ "Mod4" }, 3, awful.mouse.client.resize                  )
)

-- Client keys
keys["client"] = awful.util.table.join(
    awful.key({ "Mod4"            }, "Insert",       function(c) widgets.titlebar(c)                         end),
    awful.key({ "Mod4"            }, "Delete",       function(c) awful.titlebar.hide(c)                      end),
    awful.key({ "Mod4"            }, "k",            function(c) c:kill()                                    end),
    awful.key({ "Mod4"            }, "t",            function(c) c.ontop = not c.ontop                       end),
    awful.key({ "Mod4"            }, "s",            function(c) c.sticky = not c.sticky                     end),
    awful.key({ "Mod4"            }, "m",            function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end),
    awful.key({ "Mod4"            }, "h",            function(c) c.size_hints_honor = not c.size_hints_honor end),
    awful.key({ "Mod4"            }, "a",            function(c) c.above = not c.above                       end),
    awful.key({ "Mod4"            }, "b",            function(c) c.below = not c.below                       end),
    awful.key({ "Mod4"            }, "f",            function(c) c.fullscreen = not c.fullscreen             end),
    awful.key({ "Mod4"            }, "v",            awful.client.floating.toggle                               ),
    awful.key({ "Mod4"            }, "w",            function(c) awfuldb.save(c,awful.tag.getidx(awful.tag.selected(1))) end),
    awful.key({ "Mod1"            }, "Menu",         function(c) widgets.tasklist.main(c)                    end),
    awful.key({ "Mod4"            }, "g",            function(c) c:swap(awful.client.getmaster())            end)
)
--  Key bindings
keys["global"] = awful.util.table.join(
    awful.key({ "Mod4"            }, "r",            function() widgets.prompt.run()                         end),
    awful.key({ "Mod4"            }, "x",            function() widgets.prompt.lua()                         end),
    awful.key({ "Mod4"            }, "c",            function() widgets.prompt.cmd()                         end),
    awful.key({ "Mod4"            }, "space",        function() widgets.layout.main()                        end),
    awful.key({ "Mod4"            }, "q",            function() widgets.menu.main_qapp()                     end),
    awful.key({ "Mod4", "Shift"   }, "q",            function() widgets.menu.main_app()                      end),
    awful.key({                   }, "Menu",         function() widgets.menu.main_app()                      end),
    awful.key({ "Mod4"            }, "Up",           function() widgets.taglist.main()                       end),
    awful.key({ "Mod4"            }, "Down",         function() widgets.taglist.main()                       end),
    awful.key({ "Mod4"            }, "p",            function() widgets.places.main()                        end),
    awful.key({ "Mod1"            }, "Tab",          function() widgets.altTab()                             end),
    awful.key({ "Control"         }, "Tab",          awful.tag.history.restore                                  ),
    awful.key({ "Mod4"            }, "`",            function() widgets.kbd.switch()                         end),
    awful.key({ "Mod4"            }, "Tab",          function()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end),
    awful.key({ "Mod4", "Shift"   }, "Left",         awful.tag.viewprev                                         ),
    awful.key({ "Mod4", "Shift"   }, "Right",        awful.tag.viewnext                                         ),
    awful.key({ "Mod4",           }, "Left",         function()
        awful.client.focus.byidx( 1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ "Mod4",           }, "Right",        function()
        awful.client.focus.byidx( -1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ "Mod4"            }, "KP_Add",       function() spawn("amixer -c 0 set Master 1+ unmute")    end),
    awful.key({ "Mod4"            }, "KP_Subtract",  function() spawn("amixer -c 0 set Master 1- unmute")    end),
    awful.key({ "Mod4", "Shift"   }, "KP_Add",       function() spawn("/usr/bin/mpc volume +5")              end),
    awful.key({ "Mod4", "Shift"   }, "KP_Subtract",  function() spawn("/usr/bin/mpc volume -5")              end),
    awful.key({ "Mod4", "Control" }, "KP_Add",       function() spawn("amixer -c 0 set Front 1+ unmute")     end),
    awful.key({ "Mod4", "Control" }, "KP_Subtract",  function() spawn("amixer -c 0 set Front 1- unmute")     end),
    awful.key({ "Mod4", "Mod1"    }, "KP_Add",       function() spawn("amixer -c 0 set Surround 1+ unmute")  end),
    awful.key({ "Mod4", "Mod1"    }, "KP_Subtract",  function() spawn("amixer -c 0 set Surround 1- unmute")  end),
    awful.key({ "Mod4"            }, "Prior",        function() spawn("/usr/bin/mpc prev")                   end),
    awful.key({ "Mod4"            }, "Next",         function() spawn("/usr/bin/mpc next")                   end),
    awful.key({ "Mod4", "Control" }, "r",            awful.util.restart                                         ),
    awful.key({ "Mod4", "Control" }, "q",            awesome.quit                                               ),
    awful.key({ "Mod1",           }, "bracketright", function() awful.client.swap.byidx(  1)                 end),
    awful.key({ "Mod1",           }, "bracketleft",  function() awful.client.swap.byidx( -1)                 end),
    awful.key({ "Mod4",           }, "bracketright", function() awful.tag.incmwfact( 0.01)                   end),
    awful.key({ "Mod4",           }, "bracketleft",  function() awful.tag.incmwfact(-0.01)                   end),
    awful.key({ "Mod4", "Shift"   }, "bracketright", function() awful.tag.incnmaster( 1)                     end),
    awful.key({ "Mod4", "Shift"   }, "bracketleft",  function() awful.tag.incnmaster(-1)                     end),
    awful.key({ "Mod4", "Control" }, "bracketright", function() awful.tag.incncol( 1)                        end),
    awful.key({ "Mod4", "Control" }, "bracketleft",  function() awful.tag.incncol(-1)                        end)
)
--[[-- Bind all F1-12 keys to tags.
local tags = awful.tag.gettags(1)
for i,_ in ipairs(tags) do
    local tag = awful.tag.gettags(1)[i]
    keys["global"] = awful.util.table.join(keys["global"], awful.key({ "Mod4" }, "F"..i, function() if tag then awful.tag.viewonly(tag) end end))
end]]

-- Bind numpad to tag switcher too
local tags = awful.tag.gettags(1)
local np_map = { 87, 88, 89, 83, 84, 85, 79, 80, 81 }
for i,_ in ipairs(tags) do
    local tag = awful.tag.gettags(1)[i]
    keys["global"] = awful.util.table.join(keys["global"],
        awful.key({ "Mod4"            }, "#"..(np_map[i] or 0),
            function() if tag then awful.tag.viewonly(tag) end end),
        awful.key({ "Mod4", "Control" }, "#"..(np_map[i] or 0),
            function() if tag and client.focus then awful.client.movetotag(tag) awful.tag.viewonly(tag) end end)
    )
end

-- Set keys
root.keys(keys["global"])
root.buttons(keys["mouse"])

-- All clients will match this rule.
awful.rules.rules = {{ rule = { },
    properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        keys = keys["client"],
        buttons = keys["buttons"],
        floating = true,
        size_hints_honor = true
}}}

-- Initializes the windows rules system
awfuldb.load(awful.rules.rules, tags)

-- Signals emitted on client objects
client.connect_signal("manage", function(c,startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c) client.focus = c end)
    if c.type == "dialog" then
        awful.placement.centered(c)
        c.ontop = true
        if beautiful.tb["dialog"] then  widgets.titlebar(c) end
    elseif awful.client.floating.get(c) then
        if beautiful.tb["float"] then 
            widgets.titlebar(c) 
        end
    end
    if beautiful.tb["all"] then widgets.titlebar(c) end
end)
-- when a client gains focus
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
-- when a client looses focus
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

