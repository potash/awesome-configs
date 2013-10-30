--[[
        File:      widgets/titlebar.lua
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")

local module = {}
local cache  = {} -- XXX: Nes awful nera funkcijos patikrinti ar klientas turi titlebar.

local function add_titlebar(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )
    -- TODO: Client menu
    local clientIcon = wibox.widget.imagebox()
    clientIcon:set_image(c.icon or beautiful.cm["none"])
    clientIcon:buttons(awful.util.table.join(awful.button({ }, 1, function() end)))

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(clientIcon)
    left_layout:buttons(buttons)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(awful.titlebar.widget.floatingbutton(c))
    right_layout:add(awful.titlebar.widget.maximizedbutton(c))
    right_layout:add(awful.titlebar.widget.stickybutton(c))
    right_layout:add(awful.titlebar.widget.ontopbutton(c))
    right_layout:add(awful.titlebar.widget.closebutton(c))

    -- The title goes in the middle
    local middle_layout = wibox.layout.flex.horizontal()
    local title = awful.titlebar.widget.titlewidget(c)
    title:set_align("left")
    middle_layout:add(title)
    middle_layout:buttons(buttons)

    -- Now bring it all together
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)
    layout:set_middle(middle_layout)

    awful.titlebar(c, { bg_normal = "#0A1535", bg_focus = "#0F2766", size = 14 }):set_widget(layout)
end

-- Add titlebar
function module.add(c)
    if not cache[c.name] then
        add_titlebar(c)
        cache[c.name] = true
    end
end

-- Remove titlebar
function module.del(c)
    if cache[c.name] then
        awful.titlebar(c, { size = 0 })
        cache[c.name] = false
    end
end

-- Toggle titlebar
function module.toggle(c)
    if cache[c.name] then
        module.del(c)
    else
        module.add(c)
    end
end

-- Check for visible titlebar
function module.visible(c)
    if cache[c.name] then
        return true
    else
        return false
    end
end

-- Return widgets layout
local function new()
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })