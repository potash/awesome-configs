--[[
        File:      widgets/prompt.lua
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful     = require("awful")
local beautiful = require("beautiful")

local module = {}

module.prompt = awful.widget.prompt()

-- Command prompt
function module.run()
    awful.prompt.run({
        fg_cursor = beautiful.pr["fg_cursor"],
        bg_cursor = beautiful.pr["bg_cursor"],
        ul_cursor = beautiful.pr["ul_cursor"],
        font = beautiful.pr["font"],
        prompt = beautiful.pr["cmd"]
    },
        module.prompt.widget,
        function(...) awful.util.spawn(...) end,
        awful.completion.shell,
        awful.util.getdir("cache").. "/history_run", 50
    )
end
-- Run in terminal
function module.cmd()
    awful.prompt.run({
        fg_cursor = beautiful.pr["fg_cursor"],
        bg_cursor = beautiful.pr["bg_cursor"],
        ul_cursor = beautiful.pr["ul_cursor"],
        font = beautiful.pr["font"],
        prompt = beautiful.pr["run"]
    },
        module.prompt.widget,
        function(...) awful.util.spawn("urxvt-aw ".. ...) end,
        awful.completion.shell,
        awful.util.getdir("cache").. "/history_cmd", 50
    )
end
-- Lua prompt
function module.lua()
    awful.prompt.run({
        fg_cursor = beautiful.pr["fg_cursor"],
        bg_cursor = beautiful.pr["bg_cursor"],
        ul_cursor = beautiful.pr["ul_cursor"],
        font = beautiful.pr["font"],
        prompt = beautiful.pr["lua"]
    },
        module.prompt.widget,
        awful.util.eval,
        nil,
        awful.util.getdir("cache").. "/history_eval", 50
    )
end

local function new()
    return module.prompt
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })