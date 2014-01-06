--[[
        File:      widgets/menu.lua
        Date:      2014-01-06
      Author:      Mindaugas <mindeunix@gmail.com> http://minde.gnubox.com
   Copyright:      Copyright (C) 2014 Free Software Foundation, Inc.
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

local path = beautiful.ICONS.."/launcher"

-- Main menu table
module.mapp = {}
module.mapp["Network"] = {
    icon = path.."/network.svg",
    items = {
        { name="Firefox",                  command="firefox",              icon=path.."/app/firefox.png"     },
        { name="Wireshark",                command="wireshark",            icon=path.."/app/wireshark.png"   },
        { name="ZenMap",                   command="zenmap",               icon=path.."/app/zenmap.png"      },
        { name="QNetStatView",             command="qnetstatview",         icon=path.."/app/netstat.png"     },
        { name="BurpSuite",                command="burpsuite",            icon=path.."/app/burpsuite.png"   },
        { name="CrossFTP",                 command="crossftp",             icon=path.."/app/crossftp.png"    },
        { name="Tixati",                   command="tixati",               icon=path.."/app/tixati.png"      },
        { name="Deskzilla",                command="deskzilla",            icon=path.."/app/deskzilla.png"   },
        { name="EiskaltDC++",              command="eiskaltdcpp-qt",       icon=path.."/app/eiskaltdcpp.png" },
        { name="modRana",                  command="modrana",              icon=path.."/app/modrana.png"     }
    }
}
module.mapp["Development"] = {
    icon = path.."/development.svg",
    items = {
        { name="gdb promp",                command="prompt_gdb",           icon=path.."/app/gdb.png"         },
        { name="Python shell",             command="prompt_python",        icon=path.."/app/python.png"      },
        { name="Perl shell",               command="prompt_perl",          icon=path.."/app/perl.png"        },
        { name="Lua shell",                command="prompt_lua",           icon=path.."/app/lua.png"         },
        { name="Tcl/Tk shell",             command="tkcon",                icon=path.."/app/tcl-tk.png"      },
        { name="IDEA",                     command="idea",                 icon=path.."/app/idea.png"        },
        { name="PyCrham",                  command="pycharm",              icon=path.."/app/pycharm.png"     },
        { name="PhpStorm",                 command="phpstorm",             icon=path.."/app/phpstorm.png"    },
        { name="Sqlite GUI",               command="tksqlite",             icon=path.."/app/sqlite.png"      },
        { name="DBeaver",                  command="dbeaver",              icon=path.."/app/dbeaver.png"     },
        { name="KCachegrind",              command="kcachegrind",          icon=path.."/app/cachegrind.png"  },
        { name="IDA Hex-Rays",             command="ida",                  icon=path.."/app/ida.png"         },
        { name="Beyond Compare",           command="bcompare",             icon=path.."/app/diff.png"        },
        { name="Visual REgex",             command="visual_regexp",        icon=path.."/app/regex.png"       }
    }
}
module.mapp["Messenger"] = {
    icon = path.."/messenger.svg",
    items = {
        { name="Kvirc",                    command="kvirc4",               icon=path.."/app/kvirc.png"       },
        { name="Kopete",                   command="kopete",               icon=path.."/app/kopete.png"      },
        { name="Skype",                    command="skype",                icon=path.."/app/skype.png"       }
    }
}
module.mapp["Reader"] = {
    icon = path.."/reader.svg",
    items = {
        { name="QuiteRSS",                 command="quiterss",             icon=path.."/app/quiterss.png"    },
        { name="Ebook Reader",             command="qpdf",                 icon=path.."/app/ebook.png"       },
        { name="Deskzilla",                command="deskzilla",            icon=path.."/app/deskzilla.png"   },
        { name="Thunderbird",              command="thunderbird",          icon=path.."/app/thunderbird.png" }
    }
}
module.mapp["Graphics"] = {
    icon = path.."/graphics.svg",
    items = {
        { name="digiKam",                  command="digikam",              icon=path.."/app/digikam.png"     },
        { name="Gimp",                     command="gimp-2.8",             icon=path.."/app/gimp.png"        },
        { name="showFoto",                 command="showfoto",             icon=path.."/app/showfoto.png"    },
        { name="5up",                      command="5up",                  icon=path.."/app/5up.png"         },
        { name="Color Chooser",            command="ccolor",               icon=path.."/app/ccolor.png"      },
        { name="XnView",                   command="xnview",               icon=path.."/app/xnview.png"      }
    }
}
module.mapp["Multimedia"] = {
    icon = path.."/multimedia.svg",
    items = {
        { name="Kdenlive",                 command="kdenlive",             icon=path.."/app/kdenlive.png"    },
        { name="Youtube Player",           command="minitube",             icon=path.."/app/youtube.png"     },
        { name="Ffmpeg",                   command="feff",                 icon=path.."/app/ffmpeg.png"      },
        { name="Record Desktop",           command="qx11grab",             icon=path.."/app/record.png"      },
        { name="Jack control",             command="qjackctl",             icon=path.."/app/qjackctl.png"    },
        { name="Ardour",                   command="ardour3",              icon=path.."/app/ardour.png"      },
        { name="Japa",                     command="japa -J",              icon=path.."/app/japa.png"        },
        { name="Cantata",                  command="cantata",              icon=path.."/app/cantata.png"     },
        { name="Sound Mixer",              command="mixtray",              icon=path.."/app/alsa.png"        }
    }
}
module.mapp["Office"] = {
    icon = path.."/office.svg",
    items = {
        { name="yEd",                      command="yEd",                  icon=path.."/app/yEd.png"         },
        { name="Qpdf",                     command="qpdf",                 icon=path.."/app/ebook.png"       },
        { name="Thunderbird",              command="thunderbird",          icon=path.."/app/thunderbird.png" }
    }
}
module.mapp["System"] = {
    icon = path.."/system.svg",
    items = {
        { name="Nvidia Settings",          command="nvidia-settings",      icon=path.."/app/nvidia.png"      },
        { name="VirtualBox",               command="virtualbox",           icon=path.."/app/virtualbox.png"  },
        { name="Process Manager",          command="qps",                  icon=path.."/app/system.png"      },
        { name="Porthole",                 command="porthole",             icon=path.."/app/porthole.png"    },
        { name="Dbus Viewer",              command="qdbusviewer",          icon=path.."/app/qdbusviewer.png" },
        { name="Gparted",                  command="gparted",              icon=path.."/app/gparted.png"     },
        { name="Apol",                     command="apol",                 icon=path.."/app/apol.png"        },
        { name="SeAudit",                  command="seaudit",              icon=path.."/app/seaudit.png"     },
        { name="Selinux config",           command="config-selinux",       icon=path.."/app/selinux.png"     },
        { name="Screensaver",              command="xscreensaver-demo",    icon=path.."/app/screen.png"      },
        { name="Configure wine",           command="q4wine",               icon=path.."/app/wine.png"        }
    }
}
module.mapp["Miscellaneous"] = {
    icon = path.."/miscellaneous.svg",
    items = {
        { name="Terminal",                 command="urxvt",                icon=path.."/app/terminal.svg"    },
        { name="speedcrunch",              command="speedcrunch",          icon=path.."/app/speedcrunch.svg" },
        { name="Virus Total",              command="virustotal",           icon=path.."/app/virustotal.png"  },
        { name="Comodo AV",                command="comodo_start",         icon=path.."/app/comodo.png"      },
        { name="ClamTk",                   command="clamtk",               icon=path.."/app/clamtk.png"      },
        { name="Krusader",                 command="krusader",             icon=path.."/app/krusader.png"    },
        { name="Kate",                     command="kate",                 icon=path.."/app/kate.png"        },
        { name="Copyq",                    command="copyq",                icon=path.."/app/copyq.png"       }
    }
}

-- Quick menu table.
module.qapp = {}
module.qapp["Terminal"]     = { command="urxvt",       key="T", icon=path.."/quick/terminal.svg",     tag=1 }
module.qapp["File Manager"] = { command="krusader",    key="F", icon=path.."/quick/file-manager.svg", tag=4 }
module.qapp["Web browser"]  = { command="firefox",     key="B", icon=path.."/quick/browser.svg",      tag=2 }
module.qapp["Editor"]       = { command="emacs",       key="E", icon=path.."/quick/editor.svg",       tag=1 }
module.qapp["Thunderbird"]  = { command="thunderbird", key="M", icon=path.."/quick/thunderbird.svg",  tag=6 }
module.qapp["IDE"]          = { command="vs",          key="I", icon=path.."/quick/IDE.svg",          tag=3 }
module.qapp["Irc Client"]   = { command="kvirc4",      key="C", icon=path.."/quick/irc.svg",          tag=5 }
module.qapp["Task Manager"] = { command="qps",         key="P", icon=path.."/quick/proc.svg",         tag=0 }

local function spawn(cmd)
    awful.util.spawn(cmd)
end

-- Main menu builder
module.menu_visible = false
function module.main_app()
    if module.menu_visible and module.menu_app then
        module.menu_app:hide()
        module.menu_visible = false
        return
    elseif not module.menu_visible and not module.menu_app then
        local menu_items = {}
        local function submenu(t)
            local submenus = {}
            for i,_ in pairs(t) do
                table.insert(submenus,{t[i].name, t[i].command, t[i].icon or beautiful.cm["none"]})
            end
            return submenus
        end
        for k,v in pairs(module.mapp) do
            table.insert(menu_items, {k, submenu(v.items), v.icon})
        end
        module.menu_app = awful.menu.new({items=menu_items,theme={height=18,width=140}})
    end
    module.menu_app:show()
    module.menu_visible = true
end

-- Quick menu builder
module.menu_qapp = false
function module.main_qapp()
    if not module.menu_qapp then
        local tags = awful.tag.gettags(1)
        module.menu_qapp = radical.context({
            filer = false, enable_keyboard = true, direction = "bottom", x = 105,
            y = screen[1].geometry.height - beautiful.wibox["main"].height - ((#awful.util.table.keys(module.qapp))*beautiful.menu_height) - 22
        })
        for i,v in pairs(module.qapp) do
            module.menu_qapp:add_item({
                button1 = function()
                    spawn(v.command)
                    if tags[v.tag] and tags[v.tag] ~= 0 then
                        awful.tag.viewonly(tags[v.tag])
                    end
                    common.hide_menu(module.menu_qapp)
                end,
                text = i or "N/A", icon = v.icon or beautiful.cm["none"],underlay = underlay(v.key)
            })
        end
        common.reg_menu(module.menu_qapp)
    elseif module.menu_qapp.visible then
        common.hide_menu(module.menu_qapp)
    else
        common.show_menu(module.menu_qapp)
    end
end

-- Return widgets layout
local function new()
    local layout = wibox.layout.fixed.horizontal()
    layout:add(common.imagebox({icon=beautiful.iw["menu"]}))
    layout:add(common.textbox({text="MENU", width=50, b1=module.main_qapp, b3=module.main_app }))
    layout:add(common.arrow(6))
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
