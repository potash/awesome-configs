--[[
        File:      rc.lua
        Date:      2014-01-12
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

--local dbg       = require("extern.dbg")
local awful     = require("awful")
awful.rules     = require("awful.rules")
awful.wibox     = require("awful.wibox")
local layout    = require("wibox.layout")
local beautiful = require("beautiful")
local alttab    = require("extern.radical.impl.alttab")

-- When loaded, this module makes sure that there's always a client that will have focus
require("awful.autofocus")

-- Initializes the theme system
beautiful.init(awful.util.getdir('config').."/theme/darkBlue.lua")

-- Initialize debugging utilities
--dbg()

-- External libraries
local awfuldb = require("extern.awfuldb")
local focuser = require("extern.indicator.focus")

-- Widgets
local widgets = require("widgets")

-- Wibox table
local bar  = {}
-- Keybindings table
local keys = {}

-- create dock
--widgets.dock()

-- Radical 
alttab.default_icon = beautiful.path .. "/titlebar2/other.png"
alttab.titlebar_path = beautiful.path.. "/titlebar2/"

-- Create wibox 'main'
bar["main"] = awful.wibox({ position = beautiful.wibox.position, height = beautiful.wibox.height })
bar["main"]:set_bg(beautiful.wibox.bg)

-- Widgets that are aligned to the left
bar["left"] = layout.fixed.horizontal()
bar["left"]:add(widgets.layout())
bar["left"]:add(widgets.menu())
bar["left"]:add(widgets.taglist())
bar["left"]:add(widgets.prompt())

-- Widgets that are aligned to the right
bar["right"] = layout.fixed.horizontal()
bar["right"]:add(widgets.systray())
bar["right"]:add(widgets.kbd())
bar["right"]:add(widgets.places())
bar["right"]:add(widgets.sys())
bar["right"]:add(widgets.clock())

-- Now bring it all together (with the tasklist in the middle)
bar["wibox"] = layout.align.horizontal()
bar["wibox"]:set_left(bar["left"])
bar["wibox"]:set_middle(widgets.tasklist())
bar["wibox"]:set_right(bar["right"])

bar["main"]:set_widget(bar["wibox"])

-- Spawn a program.
local function spawn(cmd)
    awful.util.spawn(cmd, false)
end

-- Kill window
local function killClient()
    dbg.info("Select the window whose client you wish to kill with button 1....")
    awful.util.spawn("xkill")
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
    awful.key({ "Mod4"            }, "w",            function(c) awfuldb.save(c)                             end)
)
--  Key bindings
keys["global"] = awful.util.table.join(
    awful.key({ "Mod4"            }, "r",            function() widgets.prompt.run()                         end),
    awful.key({ "Mod4"            }, "c",            function() widgets.prompt.cmd()                         end),
    awful.key({ "Mod4"            }, "space",        function() widgets.layout.main()                        end),
    awful.key({ "Mod4"            }, "q",            function() widgets.menu.main_qapp()                     end),
    awful.key({ "Mod4", "Shift"   }, "q",            function() widgets.menu.main_app()                      end),
    awful.key({                   }, "Menu",         function() widgets.menu.main_app()                      end),
    awful.key({ "Mod4", "Mod1"    }, "Left",         awful.tag.viewprev                                         ),
    awful.key({ "Mod4", "Mod1"    }, "Right",        awful.tag.viewnext                                         ),
    awful.key({ "Mod4", "Mod1"    }, "Up",           function() widgets.taglist.main()                       end),
    awful.key({ "Mod4", "Mod1"    }, "Down",         function() widgets.taglist.main()                       end),
    awful.key({ "Mod4"            }, "p",            function() widgets.places.main()                        end),
    --awful.key({ "Mod1"            }, "Tab",          function() widgets.altTab()                             end),
    awful.key({ "Mod1"            }, "Tab",          function() alttab.altTab()                              end),
    awful.key({ "Mod1", "Shift"   }, "Tab",          function() alttab.altTabBack()                          end),
    awful.key({ "Control"         }, "Tab",          awful.tag.history.restore                                  ),
    awful.key({ "Mod4"            }, "`",            function() widgets.kbd.switch()                         end),
    awful.key({ "Mod4"            }, "Tab",          function()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end),
    awful.key({ "Mod4",           }, "Left",         function() focuser.global_bydirection("left")           end),
    awful.key({ "Mod4",           }, "Right",        function() focuser.global_bydirection("down")           end),
    awful.key({ "Mod4",           }, "Up",           function() focuser.global_bydirection("up")             end),
    awful.key({ "Mod4",           }, "Down",         function() focuser.global_bydirection("down")           end),
    awful.key({ "Mod4", "Shift"   }, "Left",         function() focuser.global_bydirection("left",nil,true)  end),
    awful.key({ "Mod4", "Shift"   }, "Right",        function() focuser.global_bydirection("down",nil,true)  end),
    awful.key({ "Mod4", "Shift"   }, "Up",           function() focuser.global_bydirection("up",nil,true)    end),
    awful.key({ "Mod4", "Shift"   }, "Down",         function() focuser.global_bydirection("down",nil,true)  end),
    awful.key({ "Control"         }, "Escape",       function() killClient()                                 end),
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
    awful.key({ "Mod4", "Control" }, "r",            awesome.restart                                            ),
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

-- Bind numpad to tag switcher
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

-- Sometimes dialogs apears to fast...
table.insert(awful.rules.rules, {rule = { type = "dialog" }, properties = { floating = true }})

-- Signals emitted on client objects
client.connect_signal("manage", function(c,startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c) client.focus = c end)
    if c.type == "dialog" then
        awful.client.floating.set(c)
        awful.placement.centered(c)
        c.ontop = true
        if beautiful.titlebar["dialog"] then  widgets.titlebar(c) end
    elseif awful.client.floating.get(c) then
        if beautiful.titlebar["float"] then widgets.titlebar(c) end
    end
    if beautiful.titlebar["all"] then widgets.titlebar(c) end
end)

-- when a client gains focus
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

-- when a client looses focus
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

