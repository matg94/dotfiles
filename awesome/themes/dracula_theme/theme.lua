--[[

     Holo Awesome WM theme 3.0
     github.com/lcpz

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local string, os = string, os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.default_dir                               = require("awful.util").get_themes_dir() .. "default"
theme.icon_dir                                  = os.getenv("HOME") .. "/.config/awesome/themes/dracula_theme/icons"
theme.wallpaper                                 = os.getenv("HOME") .. "/.config/awesome/themes/dracula_theme/wall.png"
theme.font                                      = "Ubuntu monospace 10"
theme.taglist_font                              = "Ubuntu monospace 8"
theme.fg_normal                                 = "#f8f8f2" -- widget font
theme.fg_focus                                  = "#44475a" -- not sure
theme.bg_focus                                  = "#282a36" -- widgets background 
theme.bg_normal                                 = "#282a36" -- background - main
theme.fg_urgent                                 = "#ff5555" -- Color of tag when notification on tag
theme.bg_urgent                                 = "#44475a"
theme.border_width                              = dpi(1)
theme.border_normal                             = "#44475a" -- Window border non-focused
theme.border_focus                              = "#bd93f9" -- Window border focused
theme.taglist_fg_focus                          = "#ff79c6" -- selected tag number font
theme.tasklist_bg_normal                        = "#ff79c6"
theme.tasklist_fg_focus                         = "#ff79c6"
theme.menu_height                               = dpi(20)
theme.menu_width                                = dpi(160)
theme.menu_icon_size                            = dpi(32)
theme.my_separator                              = theme.icon_dir .. "/separator-04.png"
theme.taglist_squares_sel                       = theme.icon_dir .. "/tag_select-03.png"
theme.taglist_squares_unsel                     = theme.icon_dir .. "/tag_select-03.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = dpi(5)

theme.musicplr = string.format("%s -e ncmpcpp", awful.util.terminal)

local markup = lain.util.markup
local blue   = "#80CCE6"
local space3 = markup.font("Roboto 3", " ")

-- Clock
local mytextclock = wibox.widget.textclock(markup(theme.fg_normal, space3 .. "%H:%M"))
mytextclock.font = theme.font
local clock_icon = wibox.widget.imagebox(theme.clock)
local clockbg = wibox.container.background(mytextclock, theme.bg_focus, gears.shape.rectangle)
local clockwidget = wibox.container.margin(clockbg, dpi(0), dpi(3), dpi(5), dpi(5))

-- Calendar
local mytextcalendar = wibox.widget.textclock(markup.fontfg(theme.font, theme.fg_normal, space3 .. "%d %b"))
local calbg = wibox.container.background(mytextcalendar, theme.bg_focus, gears.shape.rectangle)
local calendarwidget = wibox.container.margin(calbg, dpi(0), dpi(0), dpi(5), dpi(5))
theme.cal = lain.widget.cal({
    attach_to = { mytextclock, mytextcalendar },
    notification_preset = {
        fg = theme.fg_normal,
        bg = theme.bg_normal,
        position = "top_middle",
        font = "Ubuntu Monospace 10"
    }
})

-- ALSA volume bar
theme.volume = lain.widget.alsabar({
    notification_preset = { font = "Monospace 9"},
    --togglechannel = "IEC958,3",
    width = dpi(80), height = dpi(10), border_width = dpi(0),
    colors = {
        background = "#44475a",
        unmute     = "#50fa7b",
        mute       = "#ff5555"
    },
})
theme.volume.bar.paddings = dpi(0)
theme.volume.bar.margins = dpi(5)
local volumewidget = wibox.container.background(theme.volume.bar, theme.bg_focus, gears.shape.rectangle)
volumewidget = wibox.container.margin(volumewidget, dpi(0), dpi(0), dpi(5), dpi(5))

-- CPU
local cpu_icon = wibox.widget.imagebox(theme.cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(space3 .. markup.font(theme.font, "CPU " .. cpu_now.usage
                          .. "% ") .. markup.font("Roboto 5", " "))
    end
})
local cpubg = wibox.container.background(cpu.widget, theme.bg_focus, gears.shape.rectangle)
local cpuwidget = wibox.container.margin(cpubg, dpi(0), dpi(0), dpi(5), dpi(5))

-- Launcher
local mylauncher = awful.widget.button({ image = theme.awesome_icon_launcher })
mylauncher:connect_signal("button::press", function() awful.util.mymainmenu:toggle() end)

-- Separators
local first = wibox.widget.textbox('<span font="Roboto 7"> </span>')
local separator = wibox.widget.imagebox(theme.my_separator)

local barcolor  = gears.color({
    type  = "linear",
    from  = { dpi(32), dpi(0) },
    to    = { dpi(32), dpi(32) },
    stops = { {0.5, theme.bg_focus}, {1, "#ff79c6"} }
})

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons, { bg_focus = barcolor })

    local mytaglistcont = wibox.container.background(s.mytaglist, theme.bg_focus, gears.shape.rectangle)
    s.mytag = wibox.container.margin(mytaglistcont, dpi(0), dpi(0), dpi(5), dpi(5))

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, { bg_focus = theme.bg_focus, shape = gears.shape.rectangle, shape_border_width = 5, shape_border_color = theme.tasklist_bg_normal, align = "center" })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(32) })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            first,
            first,
            s.mytag,
        },
        { -- Middle widgets
            layout = wibox.layout.fixed.horizontal,
            clockwidget,
            separator,
            calendarwidget,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
--            cpu_icon,
            volumewidget,
            first,
            first,
            first,
        },
    }

end

return theme
