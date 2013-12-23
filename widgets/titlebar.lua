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
    -- Layouts
    local left_layout = wibox.layout.fixed.horizontal()
    local right_layout = wibox.layout.fixed.horizontal()
    local middle_layout = wibox.layout.flex.horizontal()

    -- Buttons for the titlebar
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
    -- Status images
    if beautiful.tb["add_status"] then
        local status_image = wibox.widget.imagebox()
        local status_layout = wibox.layout.fixed.horizontal()

        local function update_icons()
            local s=""
            if c.sticky == true then s = s.."_sticky"  end
            if c.ontop == true then  s = s.."_ontop"   end
            if awful.client.floating.get(c) then s = s.."_float" end
            status_image:set_image(beautiful.ICONS .. "/titlebar/status"..s..".png")
        end
        update_icons(c)
        c:connect_signal("property::floating", update_icons)
        c:connect_signal("property::ontop", update_icons)
        c:connect_signal("property::sticky", update_icons)
        
        status_layout:add(status_image)
        status_layout:buttons(buttons)
        right_layout:add(status_layout)
    end

    -- Client icon
    local clientIcon = wibox.widget.imagebox()
    clientIcon:set_image(c.icon or beautiful.cm["none"])

    -- Titlebar title
    local clientTitle = wibox.widget.textbox()
    clientTitle:set_valign(beautiful.tb["valign"])
    clientTitle:set_font(beautiful.tb["font"])
    local function update_title()
        local text = awful.util.linewrap(awful.util.escape(c.name) or "N/A", 80)
        clientTitle:set_markup("<span color='".. beautiful.tb["fg"] .."'>".. text .."</span>")
    end
    c:connect_signal("property::name", update_title)
    update_title()

    left_layout:add(clientIcon)
    left_layout:add(clientTitle)
    left_layout:buttons(buttons)

    -- Empty middle layout (it is required for buttons)
    middle_layout:buttons(buttons)

    -- Titlebar buttons
    right_layout:add(awful.titlebar.widget.floatingbutton(c))
    right_layout:add(awful.titlebar.widget.maximizedbutton(c))
    right_layout:add(awful.titlebar.widget.stickybutton(c))
    right_layout:add(awful.titlebar.widget.ontopbutton(c))
    right_layout:add(awful.titlebar.widget.closebutton(c))

    -- Now bring it all together
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(middle_layout)
    layout:set_right(right_layout)
    --  Available "position" values are top, left, right and bottom. 
    --  Additionally, the foreground and background colors can be configured via e.g. "bg_normal" and "bg_focus". 
    awful.titlebar(c, { size = beautiful.tb["size"], position = beautiful.tb["position"],
        bg_normal = beautiful.tb["bg"],bg_focus = beautiful.tb["bg_focus"]}):set_widget(layout)
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })