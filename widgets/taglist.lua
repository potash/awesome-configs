--[[
        File:      widgets/taglist.lua
        Date:      2014-01-12
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local radical   = require("extern.radical")
local underlay  = require("extern.graph.underlay")
local common    = require("widgets.common")

local module = {}

-- /dev/shm is a temporary file storage filesystem, i.e. tmpfs, that uses RAM for the backing store.
--module.history = "/dev/shm/history_tag"
module.history = awful.util.getdir("cache").."/history_tag"

-- Tags table.
module.tag = {
    { name="Work",          sname="w", icon="work.svg",        layout=awful.layout.suit.fair     }, -- 1
    { name="Network",       sname="N", icon="network.svg",     layout=awful.layout.suit.max      }, -- 2
    { name="Development",   sname="D", icon="development.svg", layout=awful.layout.suit.max      }, -- 3
    { name="File Manager",  sname="F", icon="files.svg",       layout=awful.layout.suit.max      }, -- 4
    { name="Messenger",     sname="M", icon="messenger.svg",   layout=awful.layout.suit.max      }, -- 5
    { name="Reader",        sname="R", icon="reader.svg",      layout=awful.layout.suit.max      }, -- 6
    { name="Graphics",      sname="G", icon="graphics.svg",    layout=awful.layout.suit.floating }, -- 7
    { name="Multimedia",    sname="V", icon="multimedia.svg",  layout=awful.layout.suit.max      }, -- 8
    { name="Office",        sname="O", icon="office.svg",      layout=awful.layout.suit.max      }, -- 9
    { name="System",        sname="S", icon="system.svg",      layout=awful.layout.suit.floating }, -- 10
    { name="Miscellaneous", sname="X", icon="misc.svg",        layout=awful.layout.suit.floating }  -- 11
}

-- Create tags
for _,t in ipairs(module.tag) do
    awful.tag.add(t.sname, { icon=beautiful.path.."/tags/"..t.icon, layout=t.layout })
end

-- Setup tags
local tags = awful.tag.gettags(1)
--awful.tag.setproperty(tags[1], "mwfact", 0.60)

-- Read tag history file
function module.selected()
    local f = io.open(module.history, "r")
    if f ~= nil then
        local idx = f:read("*all")
        f:close()
        tags[1].selected = false
        tags[tonumber(idx)].selected = true
    end
end
-- Try to restore last visible tag
module.selected()

-- Main menu
module.menu=false
function module.main()
    if not module.menu then
        local tags = awful.tag.gettags(1)
        module.menu = radical.context({
            filer = false, enable_keyboard = true, direction = "bottom", x = 180,
            y = screen[1].geometry.height - beautiful.wibox.height - (#tags*beautiful.menu_height) - 22,
        })
        local i,t
        for i,t in ipairs(tags) do
            module.menu:add_item({
                button1 = function() awful.tag.viewonly(t) common.hide_menu(module.menu) end,
                selected = (t == awful.tag.selected(1)),
                text = module.tag[i].name,
                icon = beautiful.path.."/tags/"..module.tag[i].icon, 
                underlay = underlay(module.tag[i].sname)
            })
        end
        common.reg_menu(module.menu)
    elseif module.menu.visible then
        common.hide_menu(module.menu)
    else
        common.show_menu(module.menu)
    end
end

-- Signal when client looses tag. 
-- Check if there is no more clients, if true go to previous tag.
client.connect_signal("untagged", function(c, t)
    if awful.tag.selected() == t and #t:clients() == 0 then
        awful.tag.history.restore()
    end
end)

-- Signal just before awesome exits 
-- Perform some actions before restarting/exiting awesome wm.
awesome.connect_signal("exit", function(restarting)
    if restarting then
        local t = awful.tag.selected(1)
        -- Save last visible tag
        local f = io.open(module.history, "w")
        f:write(awful.tag.getidx(t))
        f:close()
        -- Now restart!
        awful.util.restart()
    end
end)

-- Return widget layout
local function new()
    local layout = wibox.layout.fixed.horizontal()
    local style = beautiful.tag or {}
    local buttons = awful.util.table.join(
        awful.button({        }, 1, awful.tag.viewonly),
        awful.button({ "Mod4" }, 1, awful.client.movetotag),
        awful.button({        }, 3, awful.tag.viewtoggle),
        awful.button({ "Mod4" }, 3, awful.client.toggletag))
    layout:add(common.imagebox({icon=beautiful.path.."/widgets/workspace.svg"}))
    layout:add(common.textbox({text="TAG", width=35, b1=module.main}))
    layout:add(awful.widget.taglist(1, awful.widget.taglist.filter.noempty, buttons, style))
    layout:add(common.arrow(6))
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
