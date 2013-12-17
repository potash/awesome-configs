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
local dbg       = require("extern.dbg")

local module = {}

local function new(c)
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
    local wi = wibox.widget.imagebox()
    local function update_icons()
        local s=""
        if c.sticky == true then s = s.."_sticky"  end
        if c.ontop == true then  s = s.."_ontop"   end
        if awful.client.floating.get(c) then s = s.."_float" end
        wi:set_image(beautiful.ICONS .. "/titlebar/status"..s..".png")
    end

    --update_icons(c)
    --c:connect_signal("property::floating", update_icons)
    --c:connect_signal("property::ontop", update_icons)
    --c:connect_signal("property::sticky", update_icons)

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

    local wt = wibox.widget.textbox()

    local function update()
        local title = awful.util.linewrap(awful.util.escape(c.name) or "N/A", 80)
        wt:set_markup("<span color='#1692D0'>".. title .."</span>")
    end

    c:connect_signal("property::name", update)
    update()

    wt:set_align("left")
    wt:set_valign("center")
    wt:set_font("sans 8")
    wt.fit = function() return 100,14 end

    middle_layout:add(wt)
    middle_layout:buttons(buttons)

    -- Now bring it all together
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)
    layout:set_middle(middle_layout)

    awful.titlebar(c, { size = 12 }):set_widget(layout)
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })