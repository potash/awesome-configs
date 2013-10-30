--[[
        File:      extern/awfulld/init
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local setmetatable = setmetatable

local awful     = require("awful")
local naughty   = require("naughty")
local beautiful = require("beautiful")

package.cpath = awful.util.getdir('config')..'/extern/awfuldb/lsqlite3/?.so;' .. package.cpath
local sqlite3 = require("lsqlite3")

local module = {}

module.db =  awful.util.getdir('config').."/extern/awfuldb/rules.db"

function module.notify(msg)
    naughty.notify({ text = "Database: </b> "..msg })
end
--- Save the client to a database
-- @param C Client
function module.save(C)
    -- SQLite nera boolean datatypes...
    -- todel tenka kurti savo, o gal geriau butu saugoti kaip integers (0/1) ?

    local INFO = { }
    local db = sqlite3.open(module.db)

    for k, t in ipairs(awful.tag.gettags(1)) do
        for _, v in ipairs(C:tags()) do
            if v == t then
                INFO.TAG = k
            end
        end
    end

    INFO.NAME     = C.name     or ""
    INFO.CLASS    = C.class    or ""
    INFO.INSTANCE = C.instance or ""
    INFO.ROLE     = C.role     or ""

    if C.skip_taskbar               then INFO.ST          = 1 else INFO.ST         = 0 end
    if C.minimized                  then INFO.MINIMIZED   = 1 else INFO.MINIMIZED  = 0 end
    if C.size_hints_honor           then INFO.SHH         = 1 else INFO.SHH        = 0 end
    if C.ontop                      then INFO.ONTOP       = 1 else INFO.ONTOP      = 0 end
    if C.above                      then INFO.ABOVE       = 1 else INFO.ABOVE      = 0 end
    if C.below                      then INFO.BELOW       = 1 else INFO.BELOW      = 0 end
    if C.fullscreen                 then INFO.FULLSCREEN  = 1 else INFO.FULLSCREEN = 0 end
    if C.maximized_horizontal       then INFO.MHORIZ      = 1 else INFO.MHORIZ     = 0 end
    if C.maximized_vertical         then INFO.MVERTI      = 1 else INFO.MVERTI     = 0 end
    if C.sticky                     then INFO.STICKY      = 1 else INFO.STICKY     = 0 end
    if C.focusable                  then INFO.FOCUSABLE   = 1 else INFO.FOCUSABLE  = 0 end
    if awful.client.floating.get(C) then INFO.FLOAT       = 1 else INFO.FLOAT      = 0 end

    -- ant loop gauti name, class, instance, role ir patikrinti ar sutampa su esamu client
    for SN, SC, SI, SR in db:urows("SELECT name, class, instance, role FROM rules") do
        if INFO.NAME == SN and INFO.CLASS == SC and INFO.INSTANCE == SI and INFO.ROLE == SR then
            module.notify("Client already exists in current database")
            db:close()
            return
        end
    end
    module.notify("Saved")
    local stmt = db:prepare[[ INSERT INTO rules VALUES (NULL,
                :tag, :name, :class, :instance, :role, :skip_taskbar, :minimized, :size_hints_honor, :ontop,
                :above, :below, :fullscreen, :maximized_horizontal, :maximized_vertical, :sticky, :focusable, :float) ]]
    stmt:bind_names{
        tag = INFO.TAG,
        name = INFO.NAME,
        class = INFO.CLASS,
        instance = INFO.INSTANCE,
        role = INFO.ROLE,
        type = INFO.TYPE,
        skip_taskbar = INFO.ST,
        minimized = INFO.MINIMIZED,
        size_hints_honor = INFO.SHH,
        ontop = INFO.ONTOP,
        above = INFO.ABOVE,
        below = INFO.BELOW,
        fullscreen = INFO.FULLSCREEN,
        maximized_horizontal = INFO.MHORIZ,
        maximized_vertical = INFO.MVERTI,
        sticky = INFO.STICKY,
        focusable = INFO.FOCUSABLE,
        float = INFO.FLOAT
    }
    stmt:step()
    stmt:finalize()
    db:close()
end
--- Get windows rules
-- Gave windows rules is sqlite database nustatome kaip langu taisykles.
function module.get(keys)
    awful.rules.rules = {
        -- All clients will match this rule.
        { rule = { },
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                keys = keys["client"],
                buttons = keys["buttons"],
                floating = true,
                size_hints_honor = true
            }
        },
    }

    local db = sqlite3.open(module.db)
    db:exec[[
    CREATE TABLE IF NOT EXISTS rules(
        id                   INTEGER PRIMARY KEY,
        tag                  INTEGER,
        name                 TEXT,
        class                TEXT,
        instance             TEXT,
        role                 TEXT,
        skip_taskbar         INTEGER,
        minimized            INTEGER,
        size_hints_honor     INTEGER,
        ontop                INTEGER,
        above                INTEGER,
        below                INTEGER,
        fullscreen           INTEGER,
        maximized_horizontal INTEGER,
        maximized_vertical   INTEGER,
        sticky               INTEGER,
        focusable            INTEGER,
        float                INTEGER
    )]]

    local function all_rules()
        return db:nrows("SELECT * FROM rules")
    end
    for rule in all_rules() do
        local INFO = { }
        local VAR = { }
        INFO.TAG = rule.tag
        VAR.TAGS = awful.tag.gettags(1)

        if rule.name                    == "" then INFO.NAME       = nil  else INFO.NAME       = rule.name     end
        if rule.class                   == "" then INFO.CLASS      = nil  else INFO.CLASS      = rule.class    end
        if rule.instance                == "" then INFO.INSTANCE   = nil  else INFO.INSTANCE   = rule.instance end
        if rule.role                    == "" then INFO.ROLE       = nil  else INFO.ROLE       = rule.role     end
        if rule.skip_taskbar            == 1  then INFO.ST         = true else INFO.ST         = false         end
        if rule.minimized               == 1  then INFO.MINIMIZED  = true else INFO.MINIMIZED  = false         end
        if rule.size_hints_honor        == 1  then INFO.SHH        = true else INFO.SHH        = false         end
        if rule.ontop                   == 1  then INFO.ONTOP      = true else INFO.ONTOP      = false         end
        if rule.above                   == 1  then INFO.ABOVE      = true else INFO.ABOVE      = false         end
        if rule.below                   == 1  then INFO.BELOW      = true else INFO.BELOW      = false         end
        if rule.fullscreen              == 1  then INFO.FULLSCREEN = true else INFO.FULLSCREEN = false         end
        if rule.maximized_horizontal    == 1  then INFO.MHORIZ     = true else INFO.MHORIZ     = false         end
        if rule.maximized_vertical      == 1  then INFO.MVERTI     = true else INFO.MVERTI     = false         end
        if rule.sticky                  == 1  then INFO.STICKY     = true else INFO.STICKY     = false         end
        if rule.focusable               == 1  then INFO.FOCUSABLE  = true else INFO.FOCUSABLE  = false         end
        if rule.float                   == 1  then INFO.FLOAT      = true else INFO.FLOAT      = false         end

        local newrule = {
            rule = {
                name = INFO.NAME,
                class = INFO.CLASS,
                instance = INFO.INSTANCE,
                role = INFO.ROLE
            },
            properties = {
                floating = INFO.FLOAT,
                skip_taskbar = INFO.ST,
                size_hints_honor = INFO.SHH,
                ontop = INFO.ONTOP,
                above = INFO.ABOVE,
                below = INFO.BELOW,
                fullscreen = INFO.FULLSCREEN,
                maximized_horizontal = INFO.MHORIZ,
                maximized_vertical = INFO.MVERTI,
                sticky = INFO.STICKY,
                focusable = INFO.FOCUSABLE,
                tag = VAR.TAGS[INFO.TAG],
            }
        }
        table.insert(awful.rules.rules, newrule)
    end
    if db then
        db:close()
    end
    -- lame taip nustatyti, bet saugant windows rules i database
    -- sudetinga nustatyti dialogs pagal rules, tai sita rule uztikrina
    -- kad dialog tikrai bus floatig ir su titlebar.
    table.insert(awful.rules.rules, {
        rule = { type = "dialog" },
        properties = {
            border_width = 1,
            border_color = beautiful.border_normal,
            floating = true,
            size_hints_honor = true
        }
    })
end

local function new()
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })