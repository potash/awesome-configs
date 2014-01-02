--[[
        File:      extern/awfuldb/init.lua
        Date:      2014-01-02
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local setmetatable = setmetatable
local table = table
local client = client

local awful     = require("awful")
local naughty   = require("naughty")
local beautiful = require("beautiful")

-- The path used by require to search for a C loader.
package.cpath = awful.util.getdir("config").."/extern/awfuldb/lsqlite3/?.so;" .. package.cpath
local has_sqlite3, sqlite3 = pcall(require, "lsqlite3")

local module = {}
local db_path = beautiful.dbpath

--- Displays database notifications.
-- @param msg Text to display
function module.notify(msg)
    naughty.notify({ title = "Database", text = msg, border_color = "#FFB111", timeout = 5 })
end

-- Check if required module loaded
if not has_sqlite3 then
    module.notify('There is an error loading LuaSQLite3 module')
end

-- Prepare database
local function prepare()
    local db = sqlite3.open(db_path)
    db:exec[[
        CREATE TABLE IF NOT EXISTS rules(
           id                   INTEGER       PRIMARY KEY AUTOINCREMENT UNIQUE,
           tag                  INTEGER( 2 )  DEFAULT ( 1 ),
           name                 TEXT,
           class                TEXT,
           instance             TEXT,
           role                 TEXT,
           type                 TEXT,
           skip_taskbar         INTEGER( 1 )  DEFAULT ( 0 ),
           minimized            INTEGER( 1 )  DEFAULT ( 0 ),
           size_hints_honor     INTEGER( 1 )  DEFAULT ( 0 ),
           ontop                INTEGER( 1 )  DEFAULT ( 0 ),
           above                INTEGER( 1 )  DEFAULT ( 0 ),
           below                INTEGER( 1 )  DEFAULT ( 0 ),
           fullscreen           INTEGER( 1 )  DEFAULT ( 0 ),
           maximized_horizontal INTEGER( 1 )  DEFAULT ( 0 ),
           maximized_vertical   INTEGER( 1 )  DEFAULT ( 0 ),
           sticky               INTEGER( 1 )  DEFAULT ( 0 ),
           focusable            INTEGER( 1 )  DEFAULT ( 0 ),
           float                INTEGER( 1 )  DEFAULT ( 0 ),
           screen               INTEGER( 1 )  DEFAULT ( 0 ),
           width                INTEGER( 5 )  DEFAULT ( 0 ),
           height               INTEGER( 5 )  DEFAULT ( 0 ),
           x                    INTEGER( 5 )  DEFAULT ( 0 ),
           y                    INTEGER( 5 )  DEFAULT ( 0 ) 
    )]]
    -- CREATE UNIQUE INDEX is its own statement and cannot be used within a CREATE TABLE statement.
    db:exec[[CREATE UNIQUE INDEX IF NOT EXISTS id ON rules(name, class, instance, role)]]

    return db
end

--- Save the client.
-- @param c Client
-- @param t tag by its taglist index (ex awful.tag.getidx(awful.tag.selected(1)))
function module.save(c,t)
    if not has_sqlite3 then return end
    local db = sqlite3.open(db_path)
    local function optimize(obj)
        if type(obj) == "string" then return obj
        elseif type(obj) == "boolean" and obj then return 1
        elseif type(obj) == "boolean" and not obj then return 0
        else return "" end
    end

    -- The REPLACE command is an alias for the "INSERT OR REPLACE" variant of the INSERT command
    -- This only works if you have an unique key on the table
    local stmt = db:prepare[[ REPLACE INTO rules VALUES (NULL, :tag, :name, :class, 
                :instance, :role, :type, :skip_taskbar, :minimized, :size_hints_honor, :ontop, 
                :above, :below, :fullscreen, :maximized_horizontal, :maximized_vertical, :sticky, 
                :focusable, :float, :screen, :width, :height, :x, :y) ]]

    -- Shit happens ;-)
    if db:errcode() ~= 0 then 
        module.notify(db:error_message())
        db:close()
        return
    end

    -- Table with client coordinates. 
    local geo = c.geometry(c)

    -- Binds the values to statement parameters
    stmt:bind_names{
        tag = t,
        name = optimize(c.name),
        class = optimize(c.class),
        instance = optimize(c.instance),
        role = optimize(c.role),
        type = optimize(c.type),
        skip_taskbar = optimize(c.skip_taskbar),
        minimized = optimize(c.minimized),
        size_hints_honor = optimize(c.size_hints_honor),
        ontop = optimize(c.ontop),
        above = optimize(c.above),
        below = optimize(c.below),
        fullscreen = optimize(c.fullscreen),
        maximized_horizontal = optimize(c.maximized_horizontal),
        maximized_vertical = optimize(c.maximized_vertical),
        sticky = optimize(c.sticky),
        focusable = optimize(c.focusable),
        float = optimize(awful.client.floating.get(c)),
        screen = c.screen,
        width = geo.width,
        height = geo.height,
        x = geo.x,
        y = geo.y
    }
    stmt:step()
    stmt:finalize()
    module.notify("Client saved.")
    db:close() -- Close database
end

--- Load windows rules from the database.
-- @param rules table (awful.rules.rules)
-- @param tags tags table (awful.tag.gettags())
function module.load(rules, tags)
    if not has_sqlite3 then return end
    local db = prepare()

    -- Optimize values
    local function optimize(obj)
        if obj == "" then return nil
        elseif obj == 1 then return true
        elseif obj == 0 then return false
        else return obj end
    end

    -- Get all items
    for item in db:nrows("SELECT * FROM rules") do
        -- Create new table
        local newrule = {
            rule = {
                name = optimize(item.name), class = optimize(item.class),
                instance = optimize(item.instance), role = optimize(item.role),
            },
            properties = {
                floating = optimize(item.float),
                skip_taskbar = optimize(item.skip_taskbar),
                size_hints_honor = optimize(item.size_hints_honor),
                ontop = optimize(item.ontop),
                above = optimize(item.above),
                below = optimize(item.below),
                fullscreen = optimize(item.fullscreen),
                maximized_horizontal = optimize(item.maximized_horizontal),
                maximized_vertical = optimize(item.maximized_vertical),
                sticky = optimize(item.sticky),
                focusable = optimize(item.focusable),
                tag = tags[item.tag],
            }
        }
        -- Set coordinates (if x/y isn't 0 and client is floating state)
        if item.float == 1 and item.x ~= 0 and item.y ~= 0 then
            newrule.callback = function(_c)
                _c:geometry({ width = item.width , height = item.height, x = item.x, y = item.y })
            end
        end
        table.insert(rules, newrule)
    end

    -- Close database.
    if db then db:close() end
end

local function new()

end

return setmetatable(module, { __call = function(_, ...) return new(...) end })