--[[
        File:      widgets/menu.lua
        Date:      2013-10-28
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2013 Free Software Foundation, Inc.
     Licence:      GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
        NOTE:      -------
--]]

local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local underlay  = require("extern.graph.underlay")
local radical   = require("extern.radical")
local common    = require("widgets.common")

local module = {}
local path = beautiful.path.."/launcher"
local style = radical.style.classic
local item_style = radical.item_style.classic

function module.mitems()
    --- Main menu table
    module.mapp={}
    module.mapp["Work"] = {
        icon = beautiful.mapp["work"],
        items = {
            { name="GNU/Emacs",                command="emacs",                icon=path.."/app/emacs.png",      },
            { name="Terminal",                 command="urxvt",                icon=path.."/app/terminal.png"    }
        }
    }
    module.mapp["Network"] = {
        -- GPS
        icon = beautiful.mapp["network"],
        items = {
            { name="Firefox",                  command="firefox",              icon=path.."/app/firefox.png"     },
            { name="Wireshark",                command="wireshark",            icon=path.."/app/wireshark.png"   },
            { name="ZenMap",                   command="zenmap",               icon=path.."/app/zenmap.png"      },
            { name="QNetStatView",             command="qnetstatview",         icon=path.."/app/netstat.png"     },
            { name="BurpSuite",                command="burpsuite",            icon=path.."/app/burpsuite.png"   },
            { name="CrossFTP",                 command="crossftp",             icon=path.."/app/crossftp.png"    },
            { name="Tixati",                   command="tixati",               icon=path.."/app/tixati.png"      }
        }
    }
    module.mapp["Development"] = {
        icon = beautiful.mapp["development"],
        items = {
            { name="gdb",                      command="prompt_gdb",           icon=path.."/app/terminal.png"    },
            { name="Python",                   command="prompt_python",        icon=path.."/app/terminal.png"    },
            { name="Perl",                     command="prompt_perl",          icon=path.."/app/terminal.png"    },
            { name="Lua",                      command="prompt_lua",           icon=path.."/app/terminal.png"    },
            { name="Tk",                       command="tkcon",                icon=path.."/app/terminal.png"    },
            { name="IDEA",                     command="idea",                 icon=path.."/app/idea.png"        },
            { name="PyCrham",                  command="pycharm",              icon=path.."/app/pycharm.png"     },
            { name="Sqlite",                   command="tksqlite",             icon=path.."/app/cpan.png"        },
            { name="KDbg",                     command="kdbg",                 icon=path.."/app/kdbg.png"        },
            { name="KCachegrind",              command="kcachegrind",          icon=path.."/app/kcachegrind.png" },
            { name="IDA Hex-Rays",             command="ida",                  icon=path.."/app/ida.png"         },
            { name="BeyondCompare",            command="bcompare",             icon=path.."/app/bcompare.png"    },
            { name="gitk",                     command="gitk",                 icon=path.."/app/git.png"         },
            { name="tkcvs",                    command="tkcvs",                icon=path.."/app/git.png"         },
            { name="Visual REgex",             command="visual_regexp",        icon=path.."/app/re.png"          },
            { name="Deskzilla",                command="Deskzilla",            icon=path.."/app/deskzilla.png"   }
        }
    }
    module.mapp["File Manager"] = {
        icon = beautiful.mapp["file_Manager"],
        items = {
            { name="Krusader",                 command="krusader",             icon=path.."/app/krusader.png"    },
            { name="Kate",                     command="kate",                 icon=path.."/app/kate.png"        }
        }
    }
    module.mapp["Messenger"] = {
        icon = beautiful.mapp["messenger"],
        items = {
            { name="Skype",                    command="kvirc4",               icon=path.."/app/kvirc.png"       },
            { name="KVirc",                    command="kopete",               icon=path.."/app/kopete.png"      },
            { name="Kopete",                   command="skype",                icon=path.."/app/skype.png"       }
        }
    }
    module.mapp["Reader"] = {
        icon = beautiful.mapp["reader"],
        items = {
            { name="Qpdf",                     command="qpdf",                 icon=path.."/app/okular.png"      },
            { name="QuiteRSS",                 command="quiterss",             icon=path.."/app/quiterss.png"    }
        }
    }
    module.mapp["Graphics"] = {
        -- ccolor, image viever
        icon = beautiful.mapp["graphics"],
        items = {
            { name="digiKam",                  command="digikam",              icon=path.."/app/digikam.png"     },
            { name="Gimp",                     command="gimp-2.8",             icon=path.."/app/gimp.png"        },
            { name="showFoto",                 command="showfoto",             icon=path.."/app/showfoto.png"    },
            { name="LightScreen",              command="lightscreen",          icon=path.."/app/lightscreen.png" },
            { name="Color Chooser",            command="ccolor",                                                 },
            { name="Color Picker",             command="colorpicker",                                            },
            { name="Ruler",                    command="lightscreen",                                            },
            { name="Magnifer",                 command="lightscreen",                                            },
        }
    }
    module.mapp["Multimedia"] = {
        -- imdb database guisas
        icon = beautiful.mapp["multimedia"],
        items = {
            { name="Kdenlive",                 command="kdenlive",             icon=path.."/app/kdenlive.png"    },
            { name="Minitube",                 command="minitube"                                                },
            { name="FeFF",                     command="feff",                 icon=path.."/app/feff.png"        },
            { name="Minitube",                 command="minitube"                                                }
        }
    }
    module.mapp["Office"] = {
        icon = beautiful.mapp["office"],
        items = {
            { name="yEd",                      command="yEd",                  icon=path.."/app/yEd.png"         },
            { name="Qpdf",                     command="qpdf",                 icon=path.."/app/qpdf.png"        },
            { name="FreePlane",                command="freeplane",            icon=path.."/app/freeplane.png"   },
            { name="Gephi",                    command="gephi",                icon=path.."/app/gephi.png"       },
            { name="zNotes",                   command="znotes",               icon=path.."/app/znotes.png"      }
        }
    }
    module.mapp["System"] = {
        -- Virus total, lucky backup
        icon = beautiful.mapp["system"],
        items = {
            { name="VirtualBox",               command="virtualbox",           icon=path.."/app/virtualbox.png"  },
            { name="qps",                      command="qps",                  icon=path.."/app/qps.png"         },
            { name="Highlight",                command="highlight-gui"                                           },
            { name="KCalc",                    command="kcalc"                                                   },
            { name="Porthole",                 command="porthole",             icon=path.."/app/porthole.png"    },
            { name="QDbusViewer",              command="qdbusviewer",          icon=path.."/app/qdbusviewer.png" },
            { name="Krename",                  command="krename",              icon=path.."/app/krename.png"     },
            { name="Kfind",                    command="kfind",                icon=path.."/app/kfind.png"       },
            { name="Screensaver",              command="xscreensaver-demo"                                       }
        }
    }
    module.mapp["Miscellaneous"] = {
        icon = beautiful.mapp["miscellaneous"],
        items = {
            { name="Name", command="" }
        }
    }
    module.mapp["Awesome"] = {
        icon = beautiful.mapp["awesome"],
        items = {
            { name="Restart", command="" },
            { name="Quit",    command="" }
        }
    }

    return module.mapp
end

--- Quick menu table.
module.qapp = {}
module.qapp["Terminal"]     = { command="urxvt",      key="T", icon=path.."/quick/terminal.svg",     tag=1 }
module.qapp["File Manager"] = { command="krusader",   key="F", icon=path.."/quick/file-manager.svg", tag=4 }
module.qapp["Web browser"]  = { command="firefox",    key="B", icon=path.."/quick/browser.svg",      tag=2 }
module.qapp["Editor"]       = { command="emacs",      key="E", icon=path.."/quick/editor.svg",       tag=1 }
module.qapp["eMail Reader"] = { command="claws-mail", key="M", icon=path.."/quick/email.svg",        tag=6 }
module.qapp["IDE"]          = { command="idea",       key="I", icon=path.."/quick/IDE.svg",          tag=3 }
module.qapp["Irc Client"]   = { command="kvirc4",     key="C", icon=path.."/quick/irc.svg",          tag=5 }
module.qapp["Task Manager"] = { command="qps",        key="P", icon=path.."/quick/proc.svg",         tag=0 }

module.timer={}
module.timer[1] = timer{timeout = beautiful.popup_time_out}
module.timer[1]:connect_signal("timeout", function()
    if module.menu_qapp.visible then
        module.menu_qapp.visible = false
        keygrabber.stop()
        module.timer[1]:stop()
    end
end)
function module.timer_stop()
    if module.timer[1].started then
        module.timer[1]:stop()
    end
end
function module.timer_start()
    if not module.timer[1].started then
        module.timer[1]:start()
    end
end

-- TODO: remove this shit!
local function tablelength(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

--- Main menu builder
module.menu_app = false
function module.main_app()
    if not module.menu_app then
        module.menu_app = radical.context({ enable_keyboard=true, filter=false, style=style, item_style=item_style })
        local function submenu(t)
            local items = radical.context({ style=style, item_style=item_style, enable_keyboard=false })
            for i,_ in pairs(t) do
                items:add_item({
                    text = t[i].name,
                    button1 = function()
                        awful.util.spawn_with_shell(t[i].command)
                        module.menu_app.visible = false
                        keygrabber.stop()
                    end,
                    icon = t[i].icon or beautiful.cm["none"]
                })
            end
            return items
        end
        for k,v in pairs(module.mitems()) do
            module.menu_app:add_item({ text=k, sub_menu=submenu(v.items), icon=v.icon })
        end
        module.menu_app.visible = true
    elseif module.menu_app.visible then
        module.menu_app.visible = false
        keygrabber.stop()
    else
        module.menu_app.visible = true
    end
end

--- Quick menu builder
module.menu_qapp = false
function module.main_qapp()
    if not module.menu_qapp then
        local tags = awful.tag.gettags(1)
        local items = module.qapp
        module.menu_qapp = radical.context({
            enable_keyboard = true,
            x = 105,
            y = screen[1].geometry.height - beautiful.wibox["main"].height - ((tablelength(items))*beautiful.menu_height) - 22,
            direction = "bottom",
        })
        for i,v in pairs(items) do
            module.menu_qapp:add_item({
                text = i or "N/A",
                button1 = function()
                    awful.util.spawn_with_shell(v.command)
                    if tags[v.tag] and tags[v.tag] ~= 0 then
                        awful.tag.viewonly(tags[v.tag])
                    end
                    module.timer_stop()
                    module.menu_qapp.visible = false
                end,
                icon = v.icon or beautiful.cm["none"],
                underlay = underlay(v.key)
            })
        end
        module.timer_start()
        module.menu_qapp.visible = true
    elseif module.menu_qapp.visible then
        module.menu_qapp.visible = false
        module.timer_stop()
    else
        module.menu_qapp.visible = true
        module.timer_start()
    end
end

-- Widget text
function module.text()
    return common.cwt({ text="MENU", width=50, b1=module.main_qapp, b3=module.main_app, font="Sci Fied 8" })
end

-- Widget icon
function module.icon()
    return common.cwi({ icon=beautiful.iw["menu"] })
end

-- Return widgets layout
local function new()
    local layout = wibox.layout.fixed.horizontal()
    layout:add(module.icon())
    layout:add(module.text())
    layout:add(common.arrow(6))
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })