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
local radical   = require("radical")
local common    = require("widgets.common")

local module = {}
-- /dev/shm is a temporary file storage filesystem, i.e. tmpfs, that uses RAM for the backing store.
module.history = "/dev/shm/history_tag"
--module.history = awful.util.getdir("cache").."/history_tag"

-- Tags table.
module.tag = {
    { name="Work",          sname="w", icon="work.svg",        layout=awful.layout.suit.fair     }, -- 1
    { name="Network",       sname="n", icon="network.svg",     layout=awful.layout.suit.max      }, -- 2
    { name="Development",   sname="d", icon="development.svg", layout=awful.layout.suit.max      }, -- 3
    { name="File Manager",  sname="f", icon="files.svg",       layout=awful.layout.suit.max      }, -- 4
    { name="Messenger",     sname="m", icon="messenger.svg",   layout=awful.layout.suit.max      }, -- 5
    { name="Reader",        sname="r", icon="reader.svg",      layout=awful.layout.suit.max      }, -- 6
    { name="Graphics",      sname="g", icon="graphics.svg",    layout=awful.layout.suit.floating }, -- 7
    { name="Multimedia",    sname="v", icon="multimedia.svg",  layout=awful.layout.suit.max      }, -- 8
    { name="Office",        sname="o", icon="office.svg",      layout=awful.layout.suit.max      }, -- 9
    { name="System",        sname="s", icon="system.svg",      layout=awful.layout.suit.floating }, -- 10
    { name="Miscellaneous", sname="x", icon="misc.svg",        layout=awful.layout.suit.floating }  -- 11
}

-- Create tags
for _,t in ipairs(module.tag) do
    awful.tag.add(string.upper(t.sname), { icon=beautiful.path.."/tags/"..t.icon, layout=t.layout })
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
        if idx then tags[tonumber(idx)].selected = true end
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
        for i,t in ipairs(tags) do
            module.menu:add_item({
                button1 = function() awful.tag.viewonly(t) common.hide_menu(module.menu) end,
                selected = (t == awful.tag.selected(1)),
                text = module.tag[i].name,
                icon = beautiful.path.."/tags/"..module.tag[i].icon,
                underlay = string.upper(module.tag[i].sname)
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
-- Check if there is no more clients, if true then go to the previous tag.
client.connect_signal("untagged", function(c, t)
    if awful.tag.selected() == t and #t:clients() == 0 then
        awful.tag.history.restore()
    end
end)

-- Signal just before awesome exits 
-- Perform some actions before restarting/exiting awesome wm.
awesome.connect_signal("exit", function(restarting)
    if restarting then
        -- Save last visible tag
        local f = io.open(module.history, "w")
        f:write(awful.tag.getidx(awful.tag.selected(1)))
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
    layout:add(common.arrow(2))
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
