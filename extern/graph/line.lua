-- @author cedlemo  

local setmetatable = setmetatable
local ipairs = ipairs
local math = math
local table = table
local type = type
local string = string
local color = require("gears.color")
local base = require("wibox.widget.base")

local superproperties = {
    h_margin = 2 ;
    v_margin = 2 ;
    background_border = nil ;
    background_color = "#00000000" ;
    graph_background_color = "#00000066" ;
    graph_background_border = "#00000000" ;
    rounded_size = 0 ;
    graph_color = "#7fb21966" ;
    graph_line_color = "#7fb219" ;
    text_color = "ffffff" ;
    font_size = 9 ;
    font = "sans";
    background_text_color = "#00000066" ;
    background_text_border = "#ffffff";
    padding = 2;
    menu_width = 300;
}
local linegraph = { mt = {} }
local data = setmetatable({}, { __mode = "k" })

---Fill all the widget (width * height) with this color (default is none ) 
--@usage mygraph:set_background_color(string) -->"#rrggbbaa"
--@name set_background_color
--@class function
--@graph graph the graph
--@param color a string "#rrggbbaa" or "#rrggbb"

---Set a border (width * height) with this color (default is none ) 
--@usage mygraph:set_background_border(string) -->"#rrggbbaa"
--@name set_background_border
--@class function
--@graph graph the graph
--@param color a string "#rrggbbaa" or "#rrggbb"

---Fill the graph area background with this color (default is none)
--@usage mygraph:set_graph_background_color(string) -->"#rrggbbaa"
--@name set_graph_background_color
--@class function
--@param graph the graph
--@param color a string "#rrggbbaa" or "#rrggbb"

---Set a border on the graph area background (default is none ) 
--@usage mygraph:set_graph_background_border(string) -->"#rrggbbaa"
--@name set_graph_background_border
--@class function
--@graph graph the graph
--@param color a string "#rrggbbaa" or "#rrggbb"

---Set rounded corners for background and graph background
--@usage mygraph:set_rounded_size(a) -> a in [0,1]
--@name set_rounded_size
--@class function
--@param graph the graph
--@param rounded_size float in [0,1]

---Define the top and bottom margin for the graph area
--@usage mygraph:set_v_margin(integer)
--@name set_v_margin
--@class function
--@param graph the graph
--@param margin an integer for top and bottom margin

---Define the left and right margin for the graph area
--@usage mygraph:set_h_margin(integer)
--@name set_h_margin
--@class function
--@param graph the graph
--@param margin an integer for left and right margin

---Define the graph color
--@usage mygraph:set_graph_color(string) -->"#rrggbbaa"
--@name set_graph_color
--@class function
--@param graph the graph
--@param color a string "#rrggbbaa" or "#rrggbb"

---Define the graph outline
--@usage mygraph:set_graph_line_color(string) -->"#rrggbbaa"
--@name set_graph_line_color
--@class function
--@param graph the graph
--@param color a string "#rrggbbaa" or "#rrggbb"

---Display text on the graph or not
--@usage mygraph:set_show_text(boolean) --> true or false
--@name set_show_text
--@class function
--@param graph the graph
--@param boolean true or false (default is false)

---Define the color of the text
--@usage mygraph:set_text_color(string) -->"#rrggbbaa"
--@name set_text_color
--@class function
--@param graph the graph
--@param color a string "#rrggbbaa" or "#rrggbb" defaul is white

---Define the background color of the text
--@usage mygraph:set_background_text_color(string) -->"#rrggbbaa"
--@name set_background_text_color
--@class
--@param graph the graph
--@param color a string "#rrggbbaa" or "#rrggbb"

---Define the text font size
--@usage mygraph:set_font_size(integer)
--@name set_font_size
--@class function
--@param graph the graph
--@param size the font size

---Define the template of the text to display
--@usage mygraph:set_label(string)
--By default the text is : (value_send_to_the_widget *100) .. "%"
--static string: example set_label("CPU usage:") will display "CUP usage:" on the graph
--dynamic string: use $percent in the string example set_label("Load $percent %") will display "Load 10%" 
--@name set_label
--@class function
--@param graph the graph
--@param text the text to display

---Convert an hexadecimal color to rgba color.
--It convert a string variable "#rrggbb" or "#rrggbbaa" (with r,g,b and a which are hexadecimal value) to r, g, b a=1 or r,g,b,a (with r,g,b,a floated value from 0 to 1.
--The function returns 4 variables.
--@param my_color a string "#rrggbb" or "#rrggbbaa"
local function hexadecimal_to_rgba_percent(my_color)
    local r,v,b,a
    --check if color is a valid hex color else return white
    if string.find(my_color,"#[0-f][0-f][0-f][0-f][0-f]") then
        --delete #
        my_color=string.gsub(my_color,"^#","")
        r=string.format("%d", "0x"..string.sub(my_color,1,2))
        v=string.format("%d", "0x"..string.sub(my_color,3,4))
        b=string.format("%d", "0x"..string.sub(my_color,5,6))
        if string.sub(my_color,7,8) == "" then
            a=255
        else
            a=string.format("%d", "0x"..string.sub(my_color,7,8))
        end
    else
        r=255
        v=255
        b=255
        a=255
    end
    return r/255,v/255,b/255,a/255
end
---Draw a rectangle width rounded corners.
--@param cairo_context a cairo context already initialised with oocairo.context_create( )
--@param x the x coordinate of the left top corner
--@param y the y corrdinate of the left top corner
--@param width the width of the rectangle
--@param height the height of the rectangle
--@param color a string "#rrggbb" or "#rrggbbaa" for the color of the rectangle
--@param rounded_size a float value from 0 to 1 (0 is no rounded corner)
--@param border color a string "#rrggbb" or "#rrggbbaa" for the color of the border
local function draw_rounded_corners_rectangle(cairo_context,x,y,width, height, color, rounded_size,border)
    --if rounded_size =0 it is a classical rectangle (whooooo!)
    local height = height
    local width = width
    local x = x
    local y = y
    local rounded_size = rounded_size or 0.4
    local radius
    if height > width then
        radius=0.5 * width
    else
        radius=0.5 * height
    end
    local r,g,b,a
    local PI = 2*math.asin(1)
    r,g,b,a=hexadecimal_to_rgba_percent(color)
    cairo_context:set_source_rgba(r,g,b,a)
    --top left corner
    cairo_context:arc(x + radius*rounded_size,y + radius*rounded_size, radius*rounded_size,PI, PI * 1.5)
    --top right corner
    cairo_context:arc(width - radius*rounded_size,y + radius*rounded_size, radius*rounded_size,PI*1.5, PI * 2)
    --bottom right corner
    cairo_context:arc(width - radius*rounded_size,height -  radius*rounded_size, radius*rounded_size,PI*0, PI * 0.5)
    --bottom left corner
    cairo_context:arc(x + radius*rounded_size,height -  radius*rounded_size, radius*rounded_size,PI*0.5, PI * 1)
    cairo_context:close_path()
    cairo_context:fill()

    if border ~= nil then
        cairo_context:set_line_width(1)

        r,g,b,a=hexadecimal_to_rgba_percent(border)
        cairo_context:set_source_rgba(r,g,b,a)
        --top left corner
        cairo_context:arc(x +1 + radius*rounded_size,y+1 + radius*rounded_size, radius*rounded_size,PI, PI * 1.5)
        --top right corner
        cairo_context:arc(width -1 - radius*rounded_size,y +1+ radius*rounded_size, radius*rounded_size,PI*1.5, PI * 2)
        --bottom right corner
        cairo_context:arc(width -1 - radius*rounded_size,height -1 -  radius*rounded_size, radius*rounded_size,PI*0, PI * 0.5)
        --bottom left corner
        cairo_context:arc(x +1 + radius*rounded_size,height -1 -  radius*rounded_size, radius*rounded_size,PI*0.5, PI * 1)
        cairo_context:close_path()
        cairo_context:stroke()
    end

end
---Set a rectangle width rounded corners that define the area to draw.
--@param cairo_context a cairo context already initialised with oocairo.context_create( )
--@param x the x coordinate of the left top corner
--@param y the y corrdinate of the left top corner
--@param width the width of the rectangle
--@param height the height of the rectangle
--@param rounded_size a float value from 0 to 1 (0 is no rounded corner)
local function clip_rounded_corners_rectangle(cairo_context,x,y,width, height, rounded_size)
    --if rounded_size =0 it is a classical rectangle (whooooo!)
    local height = height
    local width = width
    local x = x
    local y = y
    local rounded_size = rounded_size or 0.4
    local radius
    if height > width then
        radius=0.5 * width
    else
        radius=0.5 * height
    end

    local PI = 2*math.asin(1)
    --top left corner
    cairo_context:arc(x + radius*rounded_size,y + radius*rounded_size, radius*rounded_size,PI, PI * 1.5)
    --top right corner
    cairo_context:arc(width - radius*rounded_size,y + radius*rounded_size, radius*rounded_size,PI*1.5, PI * 2)
    --bottom right corner
    cairo_context:arc(width - radius*rounded_size,height -  radius*rounded_size, radius*rounded_size,PI*0, PI * 0.5)
    --bottom left corner
    cairo_context:arc(x + radius*rounded_size,height -  radius*rounded_size, radius*rounded_size,PI*0.5, PI * 1)
    cairo_context:close_path()
    cairo_context:clip()
end
---Check if an hexadecimal color is fully transparent.
--Returns true or false
--@param my_color a string "#rrggbb" or "#rrggbbaa"
local function is_transparent(my_color)
    --check if color is a valid hex color else return white
    if string.find(my_color,"#[0-f][0-f][0-f][0-f][0-f]") then
        --delete #
        local my_color=string.gsub(my_color,"^#","")
        if string.sub(my_color,7,8) == "" then
            return false
        else
            local alpha=string.format("%d", "0x"..string.sub(my_color,7,8))

            if alpha/1 == 0 then
                return true
            else
                return false
            end
        end
    else
        return false
    end
end
---Draw text on a rectangle which width and height depend on the text width and height.
--@param cairo_context a cairo context already initialised with oocairo.context_create( )
--@param text the text to display
--@param x the x coordinate of the left of the text
--@param y the y coordinate of the bottom of the text
--@param background_text_color a string "#rrggbb" or "#rrggbbaa" for the rectangle color
--@param text_color a string "#rrggbb" or "#rrggbbaa" for the text color
--@param show_text_centered_on_x a boolean value not mandatory (false by default) if true, x parameter is the coordinate of the middle of the text
--@param show_text_centered_on_y a boolean value not mandatory (false by default) if true, y parameter is the coordinate of the middle of the text
--@param show_text_on_left_of_x a boolean value not mandatory (false by default) if true, x parameter is the right of the text
--@param show_text_on_bottom_of_y a boolean value not mandatory (false by default) if true, y parameter is the top of the text
local function draw_text_and_background(cairo_context, text, x, y, background_text_color, text_color, show_text_centered_on_x, show_text_centered_on_y, show_text_on_left_of_x, show_text_on_bottom_of_y)
    --Text background
    local ext=cairo_context:text_extents(text)
    local x_modif = 0
    local y_modif = 0
    local show_text_on_left_of_y, show_text_centered_on_x, show_text_on_left_of_x
    local show_text_centered_on_y, show_text_on_bottom_of_y
    if show_text_centered_on_x == true then
        x_modif = ((ext.width + ext.x_bearing) / 2) + ext.x_bearing / 2
        show_text_on_left_of_x = false
    else
        if show_text_on_left_of_x == true then
            x_modif = ext.width + 2 *ext.x_bearing
        else
            x_modif = x_modif
        end
    end

    if show_text_centered_on_y == true then
        y_modif = ((ext.height +ext.y_bearing)/2 ) + ext.y_bearing / 2
        show_text_on_left_of_y = false
    else
        if show_text_on_bottom_of_y == true then
            y_modif = ext.height + 2 *ext.y_bearing
        else
            y_modif = y_modif
        end
    end
    cairo_context:rectangle(x + ext.x_bearing - x_modif,y + ext.y_bearing - y_modif,ext.width, ext.height)
    local r,g,b,a=hexadecimal_to_rgba_percent(background_text_color)
    cairo_context:set_source_rgba(r,g,b,a)
    cairo_context:fill()
    --Text
    cairo_context:new_path()
    cairo_context:move_to(x-x_modif,y-y_modif)
    local r,g,b,a=hexadecimal_to_rgba_percent(text_color)
    cairo_context:set_source_rgba(r, g, b, a)
    cairo_context:show_text(text)
end
local properties = {
    "width", "height", "h_margin", "v_margin", "background_border", "background_color",
    "graph_background_border", "graph_background_color", "rounded_size", "graph_color", "graph_line_color",
    "show_text", "text_color", "font_size", "font", "text_background_color", "label"
}
function linegraph.draw(graph, wibox, cr, width, height)
    local max_value = data[graph].max_value
    local values = data[graph].values
    -- Set the values we need
    local value = data[graph].value
    local graph_border_width = 0

    if data[graph].graph_background_border then
        graph_border_width = 1
    end

    local v_margin =  superproperties.v_margin 
    if data[graph].v_margin and data[graph].v_margin <= data[graph].height/4 then 
        v_margin = data[graph].v_margin 
    end
    
    local h_margin = superproperties.h_margin
    if data[graph].h_margin and data[graph].h_margin <= data[graph].width / 3 then 
        h_margin = data[graph].h_margin 
    end
    
    local background_border = data[graph].background_border or superproperties.background_border
    local background_color = data[graph].background_color or superproperties.background_color
    local rounded_size = data[graph].rounded_size or superproperties.rounded_size
    local graph_background_color = data[graph].graph_background_color or superproperties.graph_background_color
    local graph_background_border = data[graph].graph_background_border or superproperties.graph_background_border
    local graph_color = data[graph].graph_color or superproperties.graph_color
    local graph_line_color = data[graph].graph_line_color or superproperties.graph_line_color
    local text_color = data[graph].text_color or superproperties.text_color
    local background_text_color = data[graph].background_text_color or superproperties.background_text_color
    local font_size =data[graph].font_size or superproperties.font_size
    local font = data[graph].font or superproperties.font
    
    local line_width = 1
    cr:set_line_width(line_width)
    cr:set_antialias("subpixel") 
    -- Draw the widget background 
    if data[graph].background_color then
        draw_rounded_corners_rectangle(
            cr,
            0, --x
            0, --y
            data[graph].width,
            data[graph].height,
            background_color,
            rounded_size,
            background_border
        )
    end
    -- Draw the graph background 
    --if background_border is set, graph background  must not be drawn on it 
    local h_padding = 0
    local v_padding = 0

    if background_border ~= nil and h_margin < 1 then
        h_padding = 1
    else 
        h_padding = h_margin + 1
    end
    if background_border ~= nil and v_margin < 1 then
        v_padding = 1
    else
        v_padding = v_margin + 1
    end

    if data[graph].graph_background_color then
        draw_rounded_corners_rectangle(
            cr,
            h_padding, --x
            v_padding, --y
            data[graph].width - h_padding,
            data[graph].height - v_padding ,
            graph_background_color,
            rounded_size,
            graph_background_border
        )
    end
    clip_rounded_corners_rectangle(
        cr,
        h_padding, --x
        v_padding, --y
        data[graph].width - h_padding,
        data[graph].height - v_padding,
        rounded_size
    )
    --Drawn the graph
    --if graph_background_border is set, graph must not be drawn on it 

    if is_transparent(graph_background_border) == false then
        h_padding = h_padding + 1
        v_padding = v_padding + 1
    end
    --find nb values we can draw every column_length px
    --if rounded, make sure that graph don't begin or end outside background
    --check for the less value between hight and height to calculate the space for rounded size:
    local column_length = 2
    local less_value
    if data[graph].height > data[graph].width then
        less_value = data[graph].width/2
    else
        less_value = data[graph].height/2
    end
    local max_column=math.ceil((data[graph].width - (2*h_padding +2*(rounded_size * less_value)))/column_length)
    --Check if the table graph values is empty / not initialized
    --if next(data[graph].values) == nil then
    if #data[graph].values == 0 or #data[graph].values ~= max_column then
        -- initialize graph_values with empty values:
        data[graph].values={}
        for i=1,max_column do
            --the following line feed the graph with random value if you uncomment it and comment the line after it
            --data[graph].values[i]=math.random(0,100) / 100
            data[graph].values[i]=0
        end
    end
    -- Fill the graph
    local x=data[graph].width -(h_padding + rounded_size * less_value)
    local y=data[graph].height-(v_padding)
  
    cr:new_path()
    cr:move_to(x,y)
    cr:line_to(x,y)
    for i=1,max_column do
        local y_range=data[graph].height - (2 * v_margin)
        y= data[graph].height - (v_padding + ((data[graph].values[i]) * y_range))
        cr:line_to(x,y)
        x=x-column_length
    end
    y=data[graph].height - (v_padding )
    cr:line_to(x + column_length ,y) 
    cr:line_to(width - h_padding,data[graph].height - (v_padding ))
    cr:close_path()
  
    local r,g,b,a=hexadecimal_to_rgba_percent(graph_color)
    cr:set_source_rgba(r, g, b, a)
    cr:fill()
  
    -- Draw the graph line
    local r,g,b,a=hexadecimal_to_rgba_percent(graph_line_color)
    cr:set_source_rgba(r, g, b,a)

    x=data[graph].width - (h_padding + rounded_size * less_value)
    y=data[graph].height-(v_padding) 

    cr:new_path()
    cr:move_to(x,y )
    cr:line_to(x,y )
    for i=1,max_column do
        local y_range=data[graph].height - (2 * h_margin + 1)
        y= data[graph].height - (v_margin + ((data[graph].values[i]) * y_range))
        cr:line_to(x,y )
        x=x-column_length
    end
    x=x + column_length
    y=data[graph].height - (v_padding )
    cr:line_to(x ,y ) 
    cr:stroke()
    
    if data[graph].show_text == true then
        --Draw Text and it's background
        cr:set_font_size(font_size)

        if type(font) == "string" then
            cr:select_font_face(font,nil,nil)
        elseif type(font) == "table" then
            cr:select_font_face(font.family or "Sans", font.slang or "normal", font.weight or "normal")
        end

        local value = data[graph].values[1] * 100
        local text
        if data[graph].label then
            text=string.gsub(data[graph].label,"$percent", value)
        else
            text=value .. "%"
        end
        draw_text_and_background(
            cr,
            text,
            h_padding + rounded_size * less_value,
            data[graph].height/2 , background_text_color,text_color,false,true,false,false
        )
    end
end
function linegraph.fit(graph, width, height)
    return data[graph].width, data[graph].height
end
--- Add a value to the graph
-- For compatibility between old and new awesome widget, add_value can be replaced by set_value
-- @usage mygraph:add_value(a) or mygraph:set_value(a)
-- @param graph The graph.
-- @param value The value between 0 and 1.
-- @param group The stack color group index.
local function add_value(graph, value, group)
    if not graph then return end

    local value = value or 0
    local values = data[graph].values
   
    if string.find(value, "nan") then
       value=0
    end
   
    local values = data[graph].values
    table.remove(values, #values)
    table.insert(values,1,value)
    graph:emit_signal("widget::updated")
    return graph
end
--- Set the graph height.
-- @param graph The graph.
-- @param height The height to set.
function linegraph:set_height( height)
    if height >= 5 then
        data[self].height = height
        self:emit_signal("widget::updated")
    end
    return self
end
--- Set the graph width.
-- @param graph The graph.
-- @param width The width to set.
function linegraph:set_width( width)
    if width >= 5 then
        data[self].width = width
        self:emit_signal("widget::updated")
    end
    return self
end
-- Build properties function
for _, prop in ipairs(properties) do
    if not linegraph["set_" .. prop] then
        linegraph["set_" .. prop] = function(graph, value)
            data[graph][prop] = value
            graph:emit_signal("widget::updated")
            return graph
        end
    end
end
--- Create a graph widget.
-- @param args Standard widget() arguments. You should add width and height
-- key to set graph geometry.
-- @return A graph widget.
function linegraph.new(args)
    
    local args = args or {}

    args.width = args.width or 100
    args.height = args.height or 20

    if args.width < 5 or args.height < 5 then return end

    local graph = base.make_widget()
    data[graph] = {}

    for _, v in ipairs(properties) do
      data[graph][v] = args[v] 
    end

    data[graph].values = {}
    
    -- Set methods
    graph.set_value = add_value
    graph.add_value = add_value
    graph.draw = linegraph.draw
    graph.fit = linegraph.fit

    for _, prop in ipairs(properties) do
        graph["set_" .. prop] = linegraph["set_" .. prop]
    end

    return graph
end
function linegraph.mt:__call(...)
    return linegraph.new(...)
end

return setmetatable(linegraph, linegraph.mt)

