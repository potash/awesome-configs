# Radical menu system for AwesomeWM
=======================================

This is Radical, one of the largest Awesome extension module. It provide un
unified interface to generate multiple types of menus.

[![Too many menus](https://raw.github.com/Elv13/radical/master/screenshot/all.png)](https://raw.github.com/Elv13/radical/master/screenshot/all.png)

## Installation

Installing Radical is simple, just move to ~/.config/awesome and clone the
repository

```sh
cd ~/.config/awesome
git clone https://github.com/Elv13/radical.git
```

The require it at the top of your rc.lua:

```lua
    local radical = require("radical")
```

## Usage

Unlike awful.menu, radical act like other Awesome 3.5 layouts. You need to add
items one by one. This have the benefit of letting you interact with the items
themselves programatically.

The most simple kind of menus, contexts one, can be created like this:

```lua
    local menu = radical.context({})
    menu:add_item({text="Screen 1",button1=function() print("Hello World! ") end})
    menu:add_item({text="Screen 9",icon=beautiful.path.."Icon/layouts/tileleft.png"})
    menu:add_item({text="Sub Menu",sub_menu = function()
        local smenu = radical.context({})
        smenu:add_item({text="item 1"})
        smenu:add_item({text="item 2"})
        return smenu
    end})
    
    -- To add the menu to a widget:
    local mytextbox = wibox.widget.textbox()
    mytextbox:set_menu(menu,3) -- 3 = right mouse button, 1 = left mouse button
    
    -- To add a key binding on a "box" menu (and every other types)
    menu:add_key_binding({"Mod4"},",")
```

In this example, a simple 3 item menu is created with a dynamically generated
submenu. Please note that generating submenus using function will generate it
every time it is being shown. For static menus, it is faster to simply create
them once and passing the submenu object to the "sub_menu" item property.

`:set_menu` can also take a lazy-loading function instead of a
menu. The second parameter is not mandatory, the default is `1`.

`:add_key_binding` will add a key binding. It can also take a function as 3rd
parameter. However, it wont correctly place "context" menu as it have no idea
where you expect them. It work better with "box" menus.

### Menu types

The current valid types are:

 * **Context:** Regular context menu
 * **Box:** Centered menus (think Windows alt-tab menu)
 * **Embed:** Menus in menus. This can be used as subsections in large menus

### Menu style

Each menus come in various styles for various applications. New style can also
be created by beautiful themes. The current ones are:

 * **Arrow:** Gnome3 and Mac OSX like menus with border radius and an arrow
 * **Classic:** Replicate awful.menu look

Arrow also have a few types:

 * radical.base.arrow_type.NONE
 * radical.base.arrow_type.PRETTY
 * radical.base.arrow_type.CENTERED

### Item style

Like menus, items can have their own style. Valid values:

 * **Basic:** The most simple kind of items, no borders or special shape
 * **Classic:** 1px border at the end of each items
 * **Rounded:** A 3px border radius at each corner

### Menu layouts

On top of each styles, menu can also have different layouts to display items:

* **Vertical:** Items are displayed on top of each other
* **Horizontal:** Items are displayed alongside each other
* **Grid:** Items are displayed as a 2D array

### Using styles and layouts

```lua
    local radical = require("radical")
    
    local m = radical.context({
        style      = radical.style.classic      ,
        item_style = radical.item_style.classic ,
        layout     = radical.layout.vertical    })
    
```


### Tooltip

Radical also have its own styled tooltip widget. It can be used in menus, but
also in every widgets using the `set_tooltip` method:

```lua

local mytextbox = wibox.widget.textbox()
mytextbox:set_tooltip("foo bar")

```

## Options

Radical offer a (very, very) wide range of options to allow the creation of rich
and novel menus. The options are available in 2 formats: menu wide and item
specific. Menu wide options will take effect on all items and on the way the
menu itself is being displayed while items ones apply only to a specific item.
Multiple items can have multiple sets of options.

### Menu options

|      Name       | Description                                        | Type                          |
| --------------- | -------------------------------------------------- | ----------------------------- |
| bg              | Background color                                   | String/gradient/pattern       |
| fg              | Foreground (text) color                            | String/gradient/pattern       |
| bg_focus        | Background of focussed items                       | String/gradient/pattern       |
| fg_focus        | Foreground of focussed items                       | String/gradient/pattern       |
| bg_alternate    | Alternate background color                         | String/gradient/pattern       |
| bg_highlight    | Highlight background color                         | String/gradient/pattern       |
| bg_header       | Header (see widgets section) color                 | String/gradient/pattern       |
| border_color    | Border color                                       | String/gradient/pattern       |
| border_width    | Border width                                       | number                        |
| item_height     | Default height of items                            | number                        |
| item_width      | Default width of items                             | number                        |
| width           | Original width                                     | number                        |
| default_width   | Default menu width                                 | number                        |
| icon_size       | Icon size                                          | number                        |
| auto_resize     | Resize menu if items are too large                 | boolean                       |
| parent_geometry | Set the menu parent                                | geometry array                |
| arrow_type      | Set the arrow type when use arrow style            | see "arrow_type" enum         |
| visible         | Show or hide the menu                              | boolean                       |
| direction       | The direction from which the arrow will point      | "left","right","top","bottom" |
| row             | Number of row (in grid layout)                     | number                        |
| column          | Number of columns (in grid layout)                 | number                        |
| layout          | The menu layout (default:vertical)                 | see "Menu layouts" section    |
| style           | The menu style (default:arrow)                     | see "Menu style"              |
| item_style      | The item style (default:basic)                     | see "Item style"              |
| filter          | Filter the menu when the user type                 | boolean                       |
| show_filter     | Show a filter widget at the bottom                 | boolean                       |
| filter_string   | Default filter string                              | string                        |
| fkeys_prefix    | Display F1-F12 indicators for easy navigation      | boolean                       |
| underlay_alpha  | Underlay (see item options) opacity                | 0-1                           |
| filter_prefix   | Text to be shown at begenning of the filter string | string                        |
| max_items       | Maximum number of items before showing scrollbar   | number                        |
| enable_keyboard | Enable or disable keyboard navigation / hooks      | boolean                       |
| disable_markup  | Disable pango markup in items text                 | boolean                       |
| x               | X position (absolute)                              | number                        |
| y               | Y position (absolute)                              | number                        |
| sub_menu_on     | Show submenu on selection or when clicking         | see "sub_menu_on" enum        |

###Item options

|      Name      |                 Description                  |        Type       |
| -------------- | -------------------------------------------- | ----------------- |
| text           | The item text                                | string            |
| height         | The item height                              | number            |
| icon           | The item icon                                | string or pattern |
| bg             | See menu options                             | see menu options  |
| fg             | See menu options                             | see menu options  |
| fg_focus       | See menu options                             | see menu options  |
| bg_focus       | See menu options                             | see menu options  |
| sub_menu       | Add a submenu to this item                   | menu or function  |
| selected       | Select this item                             | boolean           |
| checkable      | Is the item dual state (a checkbox)          | boolean           |
| checked        | Is the item checked or not                   | boolean           |
| underlay       | Text to render at the far-right of the item  | [array of] string |
| prefix_widget  | Widget to append at the begenning of the item| widget            |
| suffix_widget  | Widget to append at the end of the item      | widget            |
| tooltip        | A tooltip shown on the side or bottom        | string            |
| button1        | Left mouse button action                     | function          |
| button2        | Mid mouse button action                      | function          |
| button3        | Right mouse button action                    | function          |
| button4        | Scroll up action                             | function          |
| button5        | Scroll down action                           | function          |

###Common methods

All menus provide a bunch of methods. Most of them have been coverred above, but
here is the list:

|       Name       |                 Description                  |       Arguments       | Return |
| ---------------- | -------------------------------------------- | --------------------- | ------ |
| add_item         | Add new item to a menu                       | array of options      | item   |
| add_widget       | Add a new widget instead of an item          | a widget, args        |  ---   |
| add_embeded_menu | Add an inline menu to another menu           | an "embed" menu       |  ---   |
| add_key_binding  | Add a global key binding to a menu           | mod array, key        |  ---   |
| add_key_hook     | Add a callback when a key is pressed         | mod, key, event, func |  ---   |
| clear            | Remove all items                             |           ---         |  ---   |
| scroll_down      | If the menu is cropped, scroll down          |           ---         |  ---   |
| scroll_up        | If the menu is cropped, scroll up            |           ---         |  ---   |


###Beautiful options

Radical also use the some of the same theme options as awful.menu, plus some:

|            Name              |              Description               |          Type           |
| ---------------------------- | -------------------------------------  | ----------------------  |
| menu_height                  | Menu height                            | String/Gradient/Pattern |
| menu_width                   | Menu default/minimum width             | Number                  |
| menu_border_width            | Border width                           | Number                  |
| menu_border_color            | Border color                           | String/Gradient/Pattern |
| menu_fg_normal               | Text/Foreground color                  | String/Gradient/Pattern |
| menu_bg_focus                | Selected item color                    | String/Gradient/Pattern |
| menu_bg_header               | Header widget background color         | String/Gradient/Pattern |
| menu_bg_alternate            | Scrollbar and other widget color       | String/Gradient/Pattern |
| menu_bg_normal               | Default background                     | String/Gradient/Pattern |
| menu_bg_highlight            | Highlighted item background            | String/Gradient/Pattern |
| menu_submenu_icon            | Sub menu pixmap (aka >)                | Path/Pattern            |
| menu_separator_color         | Menu separator color                   | String/Gradient/Pattern |
| draw_underlay                | Function returning the underlay pixmap | Function                |

