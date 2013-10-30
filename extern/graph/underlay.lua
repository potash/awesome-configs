--        File:      graph/underlay.lua
--        Date:      9/5/13
--      Author:      Emmanuel Lepage Vallée
-- Description:      Draw information buble intended for menus background
--   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
--     Licence:
--       USAGE:      -------
--     Require:      -------
--        NOTE:      -------

local setmetatable = setmetatable

local beautiful  = require("beautiful")
local pangocairo = require("lgi").PangoCairo
local pango      = require("lgi").Pango
local cairo      = require("lgi").cairo
local color      = require("gears.color")

local module = {}

-- Draw information buble intended for menus background
local pango_l = {}
local function new(text,args)
    local args = args or {}
    local height = args.height or (beautiful.menu_height-3)
    if not pango_l[height] then
        local pango_crx = pangocairo.font_map_get_default():create_context()
        pango_l[height] = pango.Layout.new(pango_crx)
        local desc = pango.FontDescription()
        desc:set_family("Verdana")
        desc:set_weight(pango.Weight.BOLD)
        desc:set_size((height-8) * pango.SCALE)
        pango_l[height]:set_font_description(desc)
    end
    pango_l[height].text = text
    local width = pango_l[height]:get_pixel_extents().width + height + 4
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, width+(args.padding_right or 0), height+4)
    local cr = cairo.Context(img)
    cr:set_source(color(args.bg or beautiful.bg_alternate))
    cr:arc((height-4)/2 + 2, (height-4)/2 + 2 + (args.margins or 0), (height-4)/2+(args.padding or 0)/2,0,2*math.pi)
    cr:fill()
    cr:arc(width - (height-4)/2 - 2, (height-4)/2 + 2 + (args.margins or 0), (height-4)/2+(args.padding or 0)/2,0,2*math.pi)
    cr:rectangle((height-4)/2+2,2 + (args.margins or 0)-(args.padding or 0)/2,width - (height),(height-4)+(args.padding or 0))
    cr:fill()
    cr:set_source(color(args.fg or beautiful.bg_normal))
    cr:set_operator(cairo.Operator.CLEAR)
    cr:move_to(height/2 + 2,1 + (args.margins or 0)-(args.padding or 0)/2)
    cr:show_layout(pango_l[height])
    return img
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })