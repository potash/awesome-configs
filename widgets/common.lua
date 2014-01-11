--[[
        File:      widgets/common.lua
        Date:      2014-01-12
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local gears     = require("gears")
local dbg       = require("extern.dbg")


local cairo = require("lgi").cairo

local module = {}
module.timer = {}

--- Register new menu timer
-- @param m menu to register
function module.reg_menu(m)
    module.timer[m] = timer{ timeout = beautiful.popup_time_out }
    module.timer[m]:connect_signal("timeout", function() module.hide_menu(m) end)
    module.timer[m]:start()
    m.visible = true
end

--- Hide menu and stop timer
-- @param m menu to hide
function module.hide_menu(m)
    module.timer[m]:stop()
    m.visible = false
end

--- Show menu and start timer
-- @param m menu to show
function module.show_menu(m)
    module.timer[m]:start()
    m.visible = true
end

-- Apply color mask
function module.apply_color_mask(img,mask)
    img = gears.surface(img)
    local cr = cairo.Context(img)
    cr:set_source(gears.color(mask or beautiful.icon_grad or beautiful.fg_normal))
    cr:set_operator(cairo.Operator.IN)
    cr:paint()
    return img
end

--- Create new imagebox widget
-- @param table with arguments
function module.imagebox(args)
    local args = args or {}
    local w = wibox.widget.imagebox()

    local b1 = args.b1 or nil
    local b2 = args.b2 or nil
    local b3 = args.b3 or nil
    local b4 = args.b4 or nil
    local b5 = args.b5 or nil

    if args.icon then
        if awful.util.file_readable(args.icon) then
            w:set_image(args.icon)
        elseif awful.util.file_readable(beautiful.ICONS .. args.icon) then
            w:set_image(beautiful.ICONS .. args.icon)
        else
            dbg.error("File "..args.icon.." is not readable or does not exist.")
            w:set_image(beautiful.path .. "/bg/warning.svg")
        end
    end

    w:buttons(awful.util.table.join(
        awful.button({ }, 1, b1),
        awful.button({ }, 2, b2),
        awful.button({ }, 3, b3),
        awful.button({ }, 4, b4),
        awful.button({ }, 5, b5)
    ))

    return w
end

--- Create new textbox widget
-- @param table with arguments
function module.textbox(args)
    local args = args or {}
    local text = args.text or "N/A"
    local width = args.width or 40
    local height = args.height or 16
    local font = args.font or beautiful.widget["font"] or "sans 8"
    local valign = args.valign or beautiful.widget["valign"] or "center"
    local align = args.valign or beautiful.widget["align"] or "center"
    local bg = args.bg or beautiful.widget["bg"] or "#00121E"
    local fg = args.fg or beautiful.widget["fg"] or "#1692D0"

    local b1 = args.b1 or nil
    local b2 = args.b2 or nil
    local b3 = args.b3 or nil
    local b4 = args.b4 or nil
    local b5 = args.b5 or nil

    local w  = wibox.widget.background()
    local wt = wibox.widget.textbox()

    wt:set_markup("<span color='"..fg.."'>"..text.."</span>")
    wt:set_align(align)
    wt:set_valign(valign)
    wt:set_font(font)
    wt.fit = function() return width,height end

    wt:buttons(awful.util.table.join(
        awful.button({ }, 1, b1),
        awful.button({ }, 2, b2),
        awful.button({ }, 3, b3),
        awful.button({ }, 4, b4),
        awful.button({ }, 5, b5)
    ))

    w:set_widget(wt)
    w:set_bg(bg)

    w:connect_signal("mouse::enter", function() wt:set_markup("<span color='"..fg.."'><b>"..text.."</b></span>") end)
    w:connect_signal("mouse::leave", function() wt:set_markup("<span color='"..fg.."'>"..text.."</span>") end)

    return w,wt
end

--- Arrow widget
-- @n: arrow number
local HASH={}
function module.arrow(n)
    if HASH[n] then
        return HASH[n]
    else
        local img = wibox.widget.imagebox()
        img:set_image(beautiful.path.."/arrow/"..n..".png")
        HASH[n] = img
        return HASH[n]
    end
end

local function new()
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })