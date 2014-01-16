--[[
        File:      widgets/notifications.lua
        Date:      2014-01-12
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------

button 1: radical menu su listu notifications history
button 3: reset notifications

--]]

local wibox     = require("wibox")
local beautiful = require("beautiful")
local radical   = require("extern.radical")
local underlay  = require("extern.graph.underlay")
local awful     = require("awful")
local common    = require("widgets.common")
local naughty   = require("naughty")

local module = {}
module.items = {}

-- Update notifications icon
local function update_icon()
    if #module.items >= 1 then
        module.icon:set_image(beautiful.path.."/widgets/notifications.svg")
    else
        module.icon:set_image() -- reset
    end
    -- Hide menu
    if module.menu and module.menu.visible then 
        module.menu.visible = false
    end
end
-- Format notifications
local function update_notifications(data)
    local text,icon,count,limit,bg,time = data.text or "N/A", data.icon or beautiful.unknown,1,100
    if data.title and data.title ~= "" then text = "<b>"..data.title.."</b> - "..text end
    local text = string.sub(text, 0, limit)
    for k,v in ipairs(module.items) do
        if text == v.text then count, v.count = count + 1, v.count + 1 end
    end
    time=os.date("%H:%M:%S")
    if data.preset and data.preset.bg then bg=data.preset.bg end -- TODO: presets
    if count == 1 then table.insert(module.items, {text=text,icon=icon,count=count,bg=bg,time=time}) end
    update_icon()
end

-- Reset
function module.reset()
    module.items={}
    update_icon()
end

function module.main()
    if module.menu and module.menu.visible then module.menu.visible = false return end
    if module.items and #module.items > 0 then
        module.menu = radical.context({
            filer = false, enable_keyboard = false, fkeys_prefix = false,
            style = radical.style.classic, item_style = radical.item_style.classic,
            direction = "bottom", 
            x = screen[1].geometry.width,
            y = screen[1].geometry.height - beautiful.wibox.height - ((#module.items)*beautiful.menu_height)
        })
        for k,v in ipairs(module.items) do
            module.menu:add_item({
                button1 = function() 
                    table.remove(module.items, k)
                    update_icon()
                    module.main() -- display the menu again
                end,
                text=v.text, icon=v.icon,underlay = underlay(v.count),tooltip = v.time,
            })
        end
        module.menu.visible = true
    end
end

-- Callback used to modify notifications
naughty.config.notify_callback = function(data)
    update_notifications(data)
    return data
end

-- Return widget
local function new()
    widget,module.icon = common.imagebox({bg="#00000000",b1=module.main, b3=module.reset})
    update_icon()
    return widget
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
