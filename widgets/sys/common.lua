local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")

local module = {}

--- Create widgets
-- @param: text
function module.new_widget(args)
   local args = args or {}
   local text = args.text or "N/A"
   local width = args.width or 40
   local height = args.height or 12
   local valign = args.valign or beautiful.widget_text_valign or "center"
   local align = args.align or beautiful.widget_text_align or "center"

   local t = wibox.widget.textbox()
   local w = wibox.widget.background()
   local b = wibox.widget.background()
   local m = wibox.layout.margin()
   
   t:set_align(align)
   t:set_valign(valign)
   t.fit = function() return width,height end
   t:set_text(text)

   b:set_bg("#001520")
   b:set_widget(t)
   m:set_margins(1,1,1,1)
   m:set_widget(b)
   w:set_widget(m)
   w:set_bg("#000000")

   return w,t
end


local function new()
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })