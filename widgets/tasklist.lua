--[[
        File:      widgets/tasklist.lua
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]
local awful     = require("awful")
local radical   = require("extern.radical")
local underlay  = require("extern.graph.underlay")
local beautiful = require("beautiful")
local titlebar  = require("widgets.titlebar")
local awfuldb   = require("extern.awfuldb")
local tags      = require("widgets.taglist")

local module = {}

local style=radical.style.classic
local item_style=radical.item_style.classic

local function hideMenu()
    if module.menu then
        module.menu.visible = false
    end
end

local function move2tag()
    local items = radical.context({enable_keyboard = false, style = style, item_style = item_style})
    local gt = awful.tag.gettags(1)
    for i, _ in ipairs(gt) do
        items:add_item({
            text = tags.tag[i].name,
            button1 = function()
                awful.client.movetotag(gt[i]) -- TODO: focused? tai kiek pagreitina menu load time, bet turi problemu
                module.menu.visible = false
                keygrabber.stop()
            end,
            icon = tags.tag[i].icon,
            underlay = underlay(tags.tag[i].sname)
        })
    end
    return items
end
local function items(c,m)
    -- Move to tag
    m:add_item({ text = "Move to tag", icon=beautiful.cm["move"], sub_menu=move2tag})
    -- Title bar
    m:add_item({ text="Title bar", icon=beautiful.cm["titlebar"],
        checked = function()
            if titlebar.visible(c) then
                return true
            else
                return false
            end
        end,
        button1 = function()
            titlebar.toggle(c)
            hideMenu()
        end
    })
    -- Ontop
    m:add_item({ text = "Ontop", icon = beautiful.cm["ontop"],
        checked = function()
            if c.ontop then
                return true
            else
                return false
            end
        end,
        button1 = function()
            c.ontop = not c.ontop
            hideMenu()
        end
    })
    -- Sticky
    m:add_item({ text = "Sticky", icon = beautiful.cm["sticky"],
        checked = function()
            if c.sticky then
                return true
            else
                return false
            end
        end,
        button1 = function()
            c.sticky = not c.sticky
            hideMenu()
        end
    })
    -- Floating
    m:add_item({ text = "Floating", icon = beautiful.cm["floating"],
        checked = function()
            if awful.client.floating.get(c) then
                return true
            else
                return false
            end
        end,
        button1 = function()
            if awful.client.floating.get(c) then
                awful.client.floating.delete(c)
            else
                awful.client.floating.toggle(c)
            end
            hideMenu()
        end
    })
    -- Maximize
    -- FIXME: Jeigu client yra maximize horizontal ir vertical, jis tampa ir floating.
    m:add_item({ text = "Maximize", icon = beautiful.cm["maximize"],
        checked = function()
            if c.maximized_horizontal or c.maximized_vertical then
                return true
            else
                return false
            end
        end,
        button1 = function()
            if c.maximized_horizontal or c.maximized_vertical then
                c.maximized_horizontal = false
                c.maximized_vertical = false
            else
                c.maximized_horizontal = true
                c.maximized_vertical = true
                awful.client.floating.delete(c)
            end
            hideMenu()
        end
    })
    -- Save
    m:add_item({ text = "Save", icon = beautiful.cm["save"],
        underlay = underlay("SQL"),
        button1 = function()
            awfuldb.save(c)
            hideMenu()
        end
    })
    -- Close
    m:add_item({ text = "Close", icon = beautiful.cm["close"],
        underlay = underlay(c.pid),
        button1 = function()
            c:kill()
            hideMenu()
        end
    })
end

module.menu = false
function module.main(c)
    if module.menu and module.menu.visible then
        hideMenu()
        keygrabber.stop()
    else
        module.menu = radical.context({ enable_keyboard = true, style = style, item_style = item_style })
        items(c, module.menu)
        module.menu.visible = true
    end
end

local function new()
    client.connect_signal("list", hideMenu)
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function(c)
            if module.menu and module.menu.visible then
                hideMenu()
            elseif c == client.focus then
                c.minimized = true
            else
                c.minimized = false
                client.focus = c
                c:raise()
            end
        end),
        awful.button({ }, 3, function(c) module.main(c) end)
    )
    local widget = awful.widget.tasklist(1, awful.widget.tasklist.filter.currenttags, buttons)
    return widget
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })