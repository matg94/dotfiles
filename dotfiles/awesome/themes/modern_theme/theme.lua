
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local dpi = require("beautiful.xresources").apply_dpi

local string, os = string, os

local theme = {}
theme.default_dir = require("awful.util").get_themes_dir() .. "default"
theme.icon_dir = os.getenv("HOME") .. "/.config/awesome/themes/dracula_theme/icons"
theme.wallpaper = os.getenv("HOME") .. "/.config/awesome/themes/dracula_theme/wall.png"
theme.font = "Ubuntu Monospace 12"
theme.fg_normal = "#f8f8f2" -- widget font
theme.fg_focus = "#8AB4F8" -- not sure
theme.bg_focus = "#646a73" -- widgets background
theme.bg_normal = "#101012" -- background - main
theme.fg_urgent = "#cf6679" -- Color of tag when notification on tag
theme.bg_urgent = "#cf6679"
theme.light_green = "#a5d6a7"
theme.taglist_active = "#8AB4F8"
theme.taglist_normal = "#646a73"
theme.taglist_occupied = "#a5d6a7"
theme.border_width = dpi(1)
theme.border_normal = "#646a73" -- Window border non-focused
theme.border_focus = "#8AB4F8" -- Window border focused
theme.menu_height = dpi(20)
theme.menu_width = dpi(160)
theme.menu_icon_size = dpi(32)
theme.my_separator = theme.icon_dir .. "/separator-04.png"
theme.taglist_squares_unsel = theme.icon_dir .. "/radio_button.svg"
theme.icon_occupied = theme.icon_dir .. "/mic_active.svg"
theme.widget_micUnmuted = theme.icon_dir .. "/mic_active.svg"
theme.vpn_icon = theme.icon_dir .. "/vpn.svg"
theme.useless_gap = dpi(5)
theme.tag_names = {"1", "2", "3", "4"}

-- notifications
theme.notification_font = "Ubuntu Monospace 12"
theme.notification_bg = theme.bg_normal
theme.notification_fg = theme.fg_normal
theme.notification_border_color = theme.light_green
theme.notification_width = dpi(300)
theme.notification_height = dpi(75)
theme.notification_shape = gears.shape.rounded_rect
theme.notification_icon_size = dpi(64)
naughty.config.defaults.ontop       = true
naughty.config.defaults.screen      = awful.screen.focused()
naughty.config.defaults.timeout     = 3
naughty.config.defaults.title       = ""
naughty.config.defaults.position    = "top_right"


-- naughty critical preset
naughty.config.presets.critical.bg = theme.bg_normal
naughty.config.presets.critical.border_color = theme.fg_urgent
naughty.config.presets.warn =   naughty.config.presets.critical

theme.musicplr = string.format("%s -e ncmpcpp", awful.util.terminal)

local markup = lain.util.markup
local space3 = markup.font("Roboto 3", " ")

-- Tags
awful.util.tagnames = theme.tag_names
awful.layout.layouts = {
    awful.layout.suit.tile
}

-- Clock
local mytextclock = wibox.widget.textclock(markup(theme.fg_normal, space3 .. "%H:%M - %d %b"))
mytextclock.font = "Ubuntu Monospace Bold 12"
local clock_icon = wibox.widget.imagebox(theme.clock)
local clockbg = wibox.container.background(mytextclock, theme.bg_normal, gears.shape.rectangle)
local clockwidget = wibox.container.margin(clockbg, dpi(20), dpi(3), dpi(5), dpi(5))

-- widgets
local logout_menu_widget = require("widgets.logout-menu-widget.logout-menu")
local audio_menu_widget = require("widgets.audio-device-widget.audio-device")

-- Microphone Widget
local toggle = require("widgets.toggle-widget.toggle")

theme.mic =
    toggle(
    {
        widget = wibox.widget {
            {
                {
                    image = theme.widget_micUnmuted,
                    resize = true,
                    widget = wibox.widget.imagebox
                },
                margins = 7,
                layout = wibox.container.margin
            },
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 4)
            end,
            widget = wibox.container.background
        },
        toggle_func = {"amixer", "set", "Capture", "toggle"},
        get_status_func = {"bash", "-c", "amixer get Capture | grep '\\[on\\]'"},
        timeout = 10,
        settings = function(self)
            if self.state == "off" then
                self.widget:set_bg(theme.fg_urgent)
            else
                self.widget:set_bg(theme.bg_normal)
            end
        end
    }
)
local widget_mic = theme.mic.widget

-- NordVPN Widget
local toggle = require("widgets.toggle-widget.toggle")

theme.nordvpn =
    toggle(
    {
        widget = wibox.widget {
            {
                {
                    image = theme.vpn_icon,
                    resize = true,
                    widget = wibox.widget.imagebox
                },
                margins = 7,
                layout = wibox.container.margin
            },
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 4)
            end,
            widget = wibox.container.background
        },
        enable_func = {"nordvpn", "c"},
        disable_func = {"nordvpn", "d"},
        get_status_func = {"bash", "-c", "nordvpn status | grep 'Connected'"},
        timeout = 60,
        settings = function(self)
            if self.state == "off" then
                self.widget:set_bg(theme.bg_normal)
            else
                self.widget:set_bg(theme.light_green)
            end
        end
    }
)
local widget_nordvpn = theme.nordvpn.widget

-- Calendar
local mytextcalendar = wibox.widget.textclock(markup.fontfg(theme.font, theme.fg_normal, space3 .. "%d %b"))
local calbg = wibox.container.background(mytextcalendar, theme.bg_normal, gears.shape.rectangle)
local calendarwidget = wibox.container.margin(calbg, dpi(0), dpi(0), dpi(5), dpi(5))
theme.cal =
    lain.widget.cal(
    {
        attach_to = {mytextclock, mytextcalendar},
        notification_preset = {
            fg = theme.fg_normal,
            bg = theme.bg_normal,
            default_title = '',
            position = "top_left",
            height = 125,
            font = "Ubuntu Monospace 10"
        }
    }
)

-- ALSA volume bar
theme.volume =
    lain.widget.alsabar(
    {
        notification_preset = {font = "Monospace 9"},
        --togglechannel = "IEC958,3",
        width = dpi(80),
        height = dpi(10),
        border_width = dpi(0),
        colors = {
            background = theme.bg_focus,
            unmute = theme.light_green,
            mute = theme.fg_urgent
        }
    }
)
theme.volume.bar.paddings = dpi(0)
theme.volume.bar.margins = dpi(5)
local volumewidget = wibox.container.background(theme.volume.bar, theme.bg_normal, gears.shape.rectangle)
volumewidget = wibox.container.margin(volumewidget, dpi(0), dpi(0), dpi(5), dpi(5))

-- Launcher
local mylauncher = awful.widget.button({image = theme.awesome_icon_launcher})
mylauncher:connect_signal(
    "button::press",
    function()
        awful.util.mymainmenu:toggle()
    end
)

-- Separators
local first = wibox.widget.textbox('<span font="Roboto 7"> </span>')
local separator = wibox.widget.imagebox(theme.my_separator)

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({app = awful.util.terminal})

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    local tags = require("themes.modern_theme.tags")
    tags.CreateTags(s, 4)
    -- Create a taglist widget
    s.mytaglist = tags.CreateTagList(s, theme.taglist_normal, theme.taglist_active, theme.taglist_occupied)

    local mytaglistcont = wibox.container.background(s.mytaglist, theme.bg_normal, gears.shape.rectangle)
    s.mytag = wibox.container.margin(mytaglistcont, dpi(0), dpi(0), dpi(5), dpi(5))

    -- Create the wibox
    s.mywibox =
        awful.wibar(
        {
            position = "top",
            type = "dock",
            screen = s,
            height = dpi(32),
            width = dpi(1800),
            opacity = 0.9,
            shape = gears.shape.rounded_rect
        }
    )

    -- wibar placement
    awful.placement.top(s.mywibox, {margins = 5 * 2})
    s.mywibox:struts {top = s.mywibox.height + 5 * 2}

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            first,
            clockwidget
        },
        {
            -- Middle widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytag
        },
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            volumewidget,
            first,
            audio_menu_widget(),
            first,
            widget_nordvpn,
            first,
            widget_mic,
            first,
            logout_menu_widget(),
            first,
            first,
            first,
        }
    }
end

return theme
