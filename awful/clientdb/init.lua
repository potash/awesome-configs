--[[
        File:      extern/awfuldb/init.lua
        Date:      2014-01-22
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local setmetatable = setmetatable
local table        = table
local client       = client
local awful        = require("awful")
local naughty      = require("naughty")
local has_DBI, DBI = pcall(require, "DBI")

local module = {}
module.db = awful.util.getdir("config").."/awful/clientdb/rules.db"

-- Displays database notifications.
local function notify(msg)
    naughty.notify({ title = "Database", text = msg, border_color = "#FFB111", timeout = 5 })
end

-- Check if required module loaded
if not has_DBI then
    module.notify('There is an error loading Lua DBI module')
end

-- Prepare database
local function prepare()
    local dbh = DBI.Connect('SQLite3', module.db)
    -- set the autocommit flag (this is turned off by default)
    dbh:autocommit(true)
    local sth = dbh:prepare([[
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
    )]])
    sth:execute()
    -- CREATE UNIQUE INDEX is its own statement and cannot be used within a CREATE TABLE statement.
    local sth = dbh:prepare([[CREATE UNIQUE INDEX IF NOT EXISTS id ON rules(name, class, instance, role)]])
    sth:execute()
    sth:close()
    return dbh
end

--- Save the client.
-- @param c Client
function module.save(c)
    if not has_DBI then return end
    local dbh = DBI.Connect('SQLite3', module.db)
    local c = c or client.focused
    local tag,geo = awful.tag.getidx(c:tags()[1]), c.geometry(c)
    -- Optimize values
    local function optimize(obj)
        if type(obj) == "string" then return obj
        elseif type(obj) == "boolean" and obj then return 1
        elseif type(obj) == "boolean" and not obj then return 0
        else return "" end
    end
    -- The REPLACE command is an alias for the "INSERT OR REPLACE" variant of the INSERT command
    -- This only works if you have an unique key on the table
    local sth = dbh:prepare('REPLACE INTO rules VALUES (NULL, ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)')
    -- execute the handle with bind parameters
    sth:execute(
        tag, optimize(c.name), optimize(c.class), optimize(c.instance), optimize(c.role),
        optimize(c.type), optimize(c.skip_taskbar), optimize(c.minimized),
        optimize(c.size_hints_honor), optimize(c.ontop), optimize(c.above),
        optimize(c.below), optimize(c.fullscreen), optimize(c.maximized_horizontal),
        optimize(c.maximized_vertical), optimize(c.sticky), optimize(c.focusable),
        optimize(awful.client.floating.get(c)), c.screen, geo.width, geo.height, geo.x, geo.y
    )
    -- Commit the transaction
    dbh:commit()
    -- Finish and close the handles.
    sth:close()
    dbh:close()
    notify("Client saved.")
end

--- Load windows rules from the database.
function module.load()
    if not has_DBI then return end
    local dbh = prepare()
    -- Optimize values
    local function optimize(obj)
        if obj == "" then return nil
        elseif obj == 1 then return true
        elseif obj == 0 then return false
        else return obj end
    end
    -- Create a select handle
    local sth = dbh:prepare('SELECT * FROM rules')
    sth:execute()
    for item in sth:rows(true) do
        -- Create new table
        local newrule = {
            rule = {
                name = optimize(item.name), class = optimize(item.class), instance = optimize(item.instance), role = optimize(item.role),
            },
            properties = {
                floating = optimize(item.float), skip_taskbar = optimize(item.skip_taskbar),
                size_hints_honor = optimize(item.size_hints_honor), ontop = optimize(item.ontop),
                above = optimize(item.above), below = optimize(item.below), fullscreen = optimize(item.fullscreen), 
                maximized_horizontal = optimize(item.maximized_horizontal), maximized_vertical = optimize(item.maximized_vertical),
                sticky = optimize(item.sticky),focusable = optimize(item.focusable), tag = awful.tag.gettags(item.screen)[item.tag]
            }
        }
        -- Set coordinates (if x/y isn't 0 and client is floating state)
        if optimize(item.float) and item.x ~= 0 and item.y ~= 0 then
                newrule.callback = function(_c)
                _c:geometry({ width = item.width , height = item.height, x = item.x, y = item.y })
            end
        end
        table.insert(awful.rules.rules, newrule)
    end
    -- finish and close the handles.
    sth:close()
    dbh:close()
end

local function new()
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })