--[[
        File:      widgets/prompt.lua
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful = require("awful")

local module = {}

local prompt = awful.widget.prompt()

-- Run
function module.run()
    awful.prompt.run({
        fg_cursor = "#00B3FF",
        bg_cursor = "#0F2766",
        ul_cursor = "single",
        prompt = "<span foreground='#1692D0' font='Sci Fied 8'>RUN:</span> ",
        font = "munospace 10",
    },
        prompt.widget,
        function(...) awful.util.spawn(...) end,
        awful.completion.shell,
        awful.util.getdir("cache").. "/history_run", 50
    )
end
-- Run in terminal
function module.cmd()
    awful.prompt.run({
        fg_cursor = "#00B3FF",
        bg_cursor = "#0F2766",
        ul_cursor = "single",
        prompt = "<span foreground='#1692D0' font='Sci Fied 8'>CMD:</span> ",
        font = "munospace 10",
    },
        prompt.widget,
        function(...) awful.util.spawn("urxvt-aw ".. ...) end,
        awful.completion.shell,
        awful.util.getdir("cache").. "/history_cmd", 50
    )
end
-- Lua
function module.lua()
    awful.prompt.run({
        fg_cursor = "#00B3FF",
        bg_cursor = "#0F2766",
        ul_cursor = "single",
        prompt = "<span foreground='#1692D0' font='Sci Fied 8'>LUA:</span> ",
        font = "munospace 10",
    },
        prompt.widget,
        awful.util.eval,
        nil,
        awful.util.getdir("cache").. "/history_eval", 50
    )
end

local function new()
    return prompt
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })