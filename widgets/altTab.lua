--[[
        File:      widgets/altTab.lua
        Date:      2014-01-12
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful     = require("awful")
local beautiful = require("beautiful")
local radical   = require("radical")
local common    = require("widgets.common")

local module = {}

module.menu = {}
module.timer = {}

module.timer[1] = timer{timeout = beautiful.menu_timeout or 5}
module.timer[1]:connect_signal("timeout", function()
    if module.menu.visible then
        module.menu.visible = false
        keygrabber.stop()
    end
end)
function module.timer_restart()
    if module.timer[1].started then
        module.timer[1]:stop()
    end
    module.timer[1]:start()
end

local function get_image(c)
    print(cairo.Surface(c.content, true):write_to_png("/dev/shm/t.png"))
    return cairo.ImageSurface.create_from_png("/dev/shm/t.png")
end


local function new()
    local cls = client.get(1)
    if #cls > 1 then -- run alt-tab behavior when there is more than one client running.
        module.timer_restart()
        module.menu = radical.box({
            filter = true, show_filter = true, fkeys_prefix = false, enable_keyboard = true,
            style = radical.style.classic, item_style = radical.item_style.classic})
        module.menu:add_key_hook({}, "Tab", "press", function()
            module.timer_restart()
            local item = module.menu.next_item
            item.selected = true
            item.button1()
            return true
        end)
        for _,v in pairs(cls) do
            module.menu:add_item({
                text = awful.util.escape(string.sub(v.name, 0,80)),
                button1 = function()
                    module.timer_restart()
                    if v:tags()[1] and v:tags()[1].selected == false then
                        awful.tag.viewonly(v:tags()[1])
                    end
                    client.focus = v
                end,
                icon = v.icon or beautiful.unknown,
                selected = client.focus == v,
                --suffix_widget = common.textbox({text = v:tags()[1].name, width=16, font="Sci Fied 10", bg="#00121E00", fg="#1577D3"}),
                underlay = v:tags()[1].name
            })
        end
        module.menu.visible = true
    end
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })