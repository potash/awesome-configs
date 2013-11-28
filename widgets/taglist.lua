--[[
        File:      widgets/taglist.lua
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
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

local path = beautiful.ICONS .. "/tags/"

-- Tags table.
module.tag = {
    { name="Work",          sname="w", icon=path.."work.svg",        layout=awful.layout.suit.fair     }, -- 1
    { name="Network",       sname="N", icon=path.."network.svg",     layout=awful.layout.suit.max      }, -- 2
    { name="Development",   sname="D", icon=path.."development.svg", layout=awful.layout.suit.max      }, -- 3
    { name="File Manager",  sname="F", icon=path.."files.svg",       layout=awful.layout.suit.max      }, -- 4
    { name="Messenger",     sname="M", icon=path.."messenger.svg",   layout=awful.layout.suit.max      }, -- 5
    { name="Reader",        sname="R", icon=path.."reader.svg",      layout=awful.layout.suit.max      }, -- 6
    { name="Graphics",      sname="G", icon=path.."graphics.svg",    layout=awful.layout.suit.floating }, -- 7
    { name="Multimedia",    sname="V", icon=path.."multimedia.svg",  layout=awful.layout.suit.max      }, -- 8
    { name="Office",        sname="O", icon=path.."office.svg",      layout=awful.layout.suit.max      }, -- 9
    { name="System",        sname="S", icon=path.."system.svg",      layout=awful.layout.suit.floating }, -- 10
    { name="Miscellaneous", sname="X", icon=path.."misc.svg",        layout=awful.layout.suit.floating }  -- 11
}
-- Load tags
for _,t in ipairs(module.tag) do
    awful.tag.add(t.sname, { icon=t.icon, layout=t.layout })
end
local tags = awful.tag.gettags(1)
awful.tag.setproperty(tags[1], "mwfact", 0.60)
tags[1].selected = false
tags[3].selected = true

-- Tag list widget
function module.taglist()
    -- The style overrides default theme.
    local style = {
        -- TODO: add some style?
    }
    -- A table with buttons binding to set.
    local buttons = awful.util.table.join(
        awful.button({ }, 1, awful.tag.viewonly),
        awful.button({ }, 3, function()      end)
    )
    local widget = awful.widget.taglist(1, awful.widget.taglist.filter.noempty, buttons, style)
    return widget
end

module.menu=false
function module.main()
    if not module.menu then
        local tags = awful.tag.gettags(1)
        module.menu = radical.context({
            filer = false, enable_keyboard = true, direction = "bottom",
            x = 180,
            y = screen[1].geometry.height - beautiful.wibox["main"].height - (#tags*beautiful.menu_height) - 22,
        })
        local i,t
        for i,t in ipairs(tags) do
            module.menu:add_item({
                button1 = function()
                    awful.tag.viewonly(t)
                    common.hide_menu(module.menu)
                end,
                --selected = (t == awful.tag.selected(1)),
                text = module.tag[i].name, icon = module.tag[i].icon, underlay = underlay(module.tag[i].sname)
            })
        end
        common.reg_menu(module.menu)
    elseif module.menu.visible then
        common.hide_menu(module.menu)
    else
        common.show_menu(module.menu)
    end
end

local function new()
    local layout = wibox.layout.fixed.horizontal()
    layout:add(common.cwi({ icon=beautiful.iw["tag"] }))
    layout:add(common.cwt({ text="TAG", width=35, b1=module.main, font="Sci Fied 8"}))
    layout:add(module.taglist())
    layout:add(common.arrow(6))
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })