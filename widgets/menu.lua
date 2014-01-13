--[[
        File:      widgets/menu.lua
        Date:      2014-01-12
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

-- Main menu table
module.mapp = {}
module.mapp["Network"] = {
    icon = "network.svg",
    items = {
        { name="Firefox",                  command="firefox",              icon="firefox.png"     },
        { name="Wireshark",                command="wireshark",            icon="wireshark.png"   },
        { name="ZenMap",                   command="zenmap",               icon="zenmap.png"      },
        { name="QNetStatView",             command="qnetstatview",         icon="netstat.png"     },
        { name="BurpSuite",                command="burpsuite",            icon="burpsuite.png"   },
        { name="CrossFTP",                 command="crossftp",             icon="crossftp.png"    },
        { name="Tixati",                   command="tixati",               icon="tixati.png"      },
        { name="Deskzilla",                command="deskzilla",            icon="deskzilla.png"   },
        { name="EiskaltDC++",              command="eiskaltdcpp-qt",       icon="eiskaltdcpp.png" },
        { name="modRana",                  command="modrana",              icon="modrana.png"     }
    }
}
module.mapp["Development"] = {
    icon = "development.svg",
    items = {
        { name="gdb promp",                command="prompt_gdb",           icon="gdb.png"         },
        { name="Python shell",             command="prompt_python",        icon="python.png"      },
        { name="Perl shell",               command="prompt_perl",          icon="perl.png"        },
        { name="Lua shell",                command="prompt_lua",           icon="lua.png"         },
        { name="Tcl/Tk shell",             command="tkcon",                icon="tcl-tk.png"      },
        { name="IDEA",                     command="idea",                 icon="idea.png"        },
        { name="PyCrham",                  command="pycharm",              icon="pycharm.png"     },
        { name="PhpStorm",                 command="phpstorm",             icon="phpstorm.png"    },
        { name="Sqlite GUI",               command="sqlitestudio",         icon="sqlite.png"      },
        { name="DBeaver",                  command="dbeaver",              icon="dbeaver.png"     },
        { name="KCachegrind",              command="kcachegrind",          icon="cachegrind.png"  },
        { name="IDA Hex-Rays",             command="ida",                  icon="ida.png"         },
        { name="Beyond Compare",           command="bcompare",             icon="diff.png"        },
        { name="Visual REgex",             command="visual_regexp",        icon="regex.png"       }
    }
}
module.mapp["Messenger"] = {
    icon = "messenger.svg",
    items = {
        { name="Kvirc",                    command="kvirc4",               icon="kvirc.png"       },
        { name="Kopete",                   command="kopete",               icon="kopete.png"      },
        { name="Skype",                    command="skype",                icon="skype.png"       }
    }
}
module.mapp["Reader"] = {
    icon = "reader.svg",
    items = {
        { name="QuiteRSS",                 command="quiterss",             icon="quiterss.png"    },
        { name="Ebook Reader",             command="qpdf",                 icon="ebook.png"       },
        { name="Deskzilla",                command="deskzilla",            icon="deskzilla.png"   },
        { name="Thunderbird",              command="thunderbird",          icon="thunderbird.png" }
    }
}
module.mapp["Graphics"] = {
    icon = "graphics.svg",
    items = {
        { name="digiKam",                  command="digikam",              icon="digikam.png"     },
        { name="Gimp",                     command="gimp-2.8",             icon="gimp.png"        },
        { name="showFoto",                 command="showfoto",             icon="showfoto.png"    },
        { name="5up",                      command="5up",                  icon="5up.png"         },
        { name="Color Chooser",            command="ccolor",               icon="ccolor.png"      },
        { name="XnView",                   command="xnview",               icon="xnview.png"      }
    }
}
module.mapp["Multimedia"] = {
    icon = "multimedia.svg",
    items = {
        { name="Kdenlive",                 command="kdenlive",             icon="kdenlive.png"    },
        { name="Youtube Player",           command="minitube",             icon="youtube.png"     },
        { name="Ffmpeg",                   command="feff",                 icon="ffmpeg.png"      },
        { name="Record Desktop",           command="qx11grab",             icon="record.png"      },
        { name="Jack control",             command="qjackctl",             icon="qjackctl.png"    },
        { name="Ardour",                   command="ardour3",              icon="ardour.png"      },
        { name="Japa",                     command="japa -J",              icon="japa.png"        },
        { name="Cantata",                  command="cantata",              icon="cantata.png"     },
        { name="Sound Mixer",              command="mixtray",              icon="alsa.png"        }
    }
}
module.mapp["Office"] = {
    icon = "office.svg",
    items = {
        { name="yEd",                      command="yEd",                  icon="yEd.png"         },
        { name="Qpdf",                     command="qpdf",                 icon="ebook.png"       },
        { name="Thunderbird",              command="thunderbird",          icon="thunderbird.png" }
    }
}
module.mapp["System"] = {
    icon = "system.svg",
    items = {
        { name="Nvidia Settings",          command="nvidia-settings",      icon="nvidia.png"      },
        { name="VirtualBox",               command="virtualbox",           icon="virtualbox.png"  },
        { name="Process Manager",          command="qps",                  icon="system.png"      },
        { name="Porthole",                 command="porthole",             icon="porthole.png"    },
        { name="Dbus Viewer",              command="qdbusviewer",          icon="qdbusviewer.png" },
        { name="Gparted",                  command="gparted",              icon="gparted.png"     },
        { name="Apol",                     command="apol",                 icon="apol.png"        },
        { name="SeAudit",                  command="seaudit",              icon="seaudit.png"     },
        { name="Selinux config",           command="config-selinux",       icon="selinux.png"     },
        { name="Screensaver",              command="xscreensaver-demo",    icon="screen.png"      },
        { name="Configure wine",           command="q4wine",               icon="wine.png"        }
    }
}
module.mapp["Miscellaneous"] = {
    icon = "miscellaneous.svg",
    items = {
        { name="Terminal",                 command="urxvt",                icon="terminal.svg"    },
        { name="speedcrunch",              command="speedcrunch",          icon="speedcrunch.svg" },
        { name="Virus Total",              command="virustotal",           icon="virustotal.png"  },
        { name="Comodo AV",                command="comodo_start",         icon="comodo.png"      },
        { name="ClamTk",                   command="clamtk",               icon="clamtk.png"      },
        { name="Krusader",                 command="krusader",             icon="krusader.png"    },
        { name="Kate",                     command="kate",                 icon="kate.png"        },
        { name="Copyq",                    command="copyq",                icon="copyq.png"       }
    }
}

-- Quick menu table.
module.qapp = {}
module.qapp["Terminal"]     = { command="urxvt",       key="T", icon="terminal.svg",     tag=1 }
module.qapp["File Manager"] = { command="krusader",    key="F", icon="file-manager.svg", tag=4 }
module.qapp["Web browser"]  = { command="firefox",     key="B", icon="browser.svg",      tag=2 }
module.qapp["Editor"]       = { command="emacs",       key="E", icon="editor.svg",       tag=1 }
module.qapp["Thunderbird"]  = { command="thunderbird", key="M", icon="thunderbird.svg",  tag=6 }
module.qapp["IDE"]          = { command="vs",          key="I", icon="IDE.svg",          tag=3 }
module.qapp["Irc Client"]   = { command="kvirc4",      key="C", icon="irc.svg",          tag=5 }
module.qapp["Calculator"]   = { command="speedcrunch", key="K", icon="calculator.svg",   tag=0 }
module.qapp["Task Manager"] = { command="qps",         key="P", icon="proc.svg",         tag=0 }

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
                table.insert(submenus,{t[i].name, t[i].command, beautiful.path.."/launcher/app/"..t[i].icon or beautiful.unknown})
            end
            return submenus
        end
        for k,v in pairs(module.mapp) do
            table.insert(menu_items, {k, submenu(v.items), beautiful.path.."/launcher/"..v.icon or beautiful.unknown})
        end
        module.menu_app = awful.menu.new({items=menu_items,theme={height=18,width=140}})
    end
    module.menu_app:show()
    module.menu_visible = true
end

-- Action
local function run(data)
    local tags = awful.tag.gettags(1)
    awful.util.spawn(data.command)
    if tags[data.tag] then awful.tag.viewonly(tags[data.tag]) end
    common.hide_menu(module.menu_qapp)
end

-- Quick menu builder
module.menu_qapp = false
function module.main_qapp()
    if not module.menu_qapp then
        module.menu_qapp = radical.context({
            filer = false, enable_keyboard = true, direction = "bottom", x = 105,
            y = screen[1].geometry.height - beautiful.wibox.height - ((#awful.util.table.keys(module.qapp))*beautiful.menu_height) - 22
        })
        for i,v in pairs(module.qapp) do
            module.menu_qapp:add_key_hook({}, string.lower(v.key), "press", function() run(v) end)
            module.menu_qapp:add_item({
                button1 = function() run(v) end,
                text = i or "N/A", underlay = underlay(v.key),
                icon = beautiful.path.."/launcher/quick/"..v.icon or beautiful.unknown
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
    layout:add(common.imagebox({icon=beautiful.dist_icon}))
    layout:add(common.textbox({text="MENU", width=50, b1=module.main_qapp, b3=module.main_app }))
    layout:add(common.arrow(1))
    return layout
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
