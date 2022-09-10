
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local buttons = require("widgets.buttons.buttons")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local string, os = string, os

local theme = {}
theme.default_dir = require("awful.util").get_themes_dir() .. "default"
theme.icon_dir = os.getenv("HOME") .. "/.config/awesome/themes/modern_theme/icons"
theme.wallpaper = os.getenv("HOME") .. "/.config/awesome/themes/modern_theme/wall.png"
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
theme.widget_pihole_icon = theme.icon_dir .. "/pihole.svg"
theme.tailscale_icon = theme.icon_dir .. "/tailscale_icon_cloud.svg"
theme.vpn_icon = theme.icon_dir .. "/vpn.svg"
theme.useless_gap = dpi(4)
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

local markup = require("widgets.util.markup")

-- local markup = lain.util.markup
local space3 = markup.font("Roboto 3", " ")

-- Tags
awful.util.tagnames = theme.tag_names
awful.layout.layouts = {
    awful.layout.suit.tile
}

-- Clock
local mytextclock = wibox.widget.textclock(markup(theme.fg_normal, space3 .. " %H:%M - %d %b"))
mytextclock.font = "Ubuntu Monospace Bold 12"
local clock_icon = wibox.widget.imagebox(theme.clock)
local clockbg = wibox.container.background(mytextclock, theme.bg_normal, gears.shape.rectangle)
local clockwidget = wibox.container.margin(clockbg, dpi(20), dpi(3), dpi(5), dpi(5))

-- widgets
local logout_menu_widget = require("widgets.logout-menu-widget.logout-menu")
local audio_menu_widget = require("widgets.audio-device-widget.audio-device")

-- Microphone button
local microphone_button = buttons.create_button(
    "",
    theme.fg_normal,
    theme.bg_normal,
    theme.fg_focus, -- border color on hover
    ""
)

-- Microphone Widget
local toggle = require("widgets.toggle-widget.toggle")

theme.mic =
    toggle(
    {
        widget = microphone_button,
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

-- pihole button
local pihole_button = buttons.create_button(
    "",
    theme.fg_normal,
    theme.bg_normal,
    theme.fg_focus, -- border color on hover
    ""
)

-- pihole widget
theme.pihole =
    toggle(
    {
        widget = pihole_button,
        enable_func = {"utils", "pihole", "-enable"},
        disable_func = {"utils", "pihole", "-disable"},
        get_status_func = {"zsh", "-c", "utils pihole | grep 'enabled'"},
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
local widget_pihole = theme.pihole.widget


-- Wifi Menu Button
local wifibutton = buttons.create_button(
    "",
    theme.fg_normal,
    theme.bg_normal,
    theme.fg_focus, -- border color on hover
    "wifimenu"
)

-- Tailscale Button
local tailscale_button = buttons.create_button(
    "",
    theme.fg_normal,
    theme.bg_normal,
    theme.fg_focus, -- border color on hover
    ""
)

-- Tailscale Widget
theme.tailscale =
    toggle(
    {
        widget = tailscale_button,
        enable_func = {"tailscale", "up"},
        disable_func = {"tailscale", "down"},
        get_status_func = {"zsh", "-c", "tailscale status | grep '100'"},
        timeout = 10,
        settings = function(self)
            if self.state == "off" then
                self.widget:set_bg(theme.bg_normal)
            else
                self.widget:set_bg(theme.light_green)
            end
        end
    }
)
local widget_tailscale = theme.tailscale.widget

-- NordVPN button
local nordvpn_button = buttons.create_button(
    "",
    theme.fg_normal,
    theme.bg_normal,
    theme.fg_focus, -- border color on hover
    ""
)

-- NordVPN Widget

theme.nordvpn =
    toggle(
    {
        widget = nordvpn_button,
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

-- ALSA volume bar
local alsabar = require("widgets.volume-bar-widget.alsabar")
theme.volume =
    alsabar(
    {
        notification_preset = {font = "Ubuntu Monospace 9"},
        --togglechannel = "IEC958,3",
        width = dpi(100),
        height = dpi(7),
        border_width = dpi(2),
        colors = {
            background = theme.bg_focus,
            unmute = theme.light_green,
            mute = theme.fg_urgent
        }
    }
)
theme.volume.bar.paddings = dpi(0)
theme.volume.bar.margins = dpi(5)
local volumewidget = wibox.container.background(theme.volume.bar, theme.bg_normal, gears.shape.rounded_rect)
volumewidget = wibox.container.margin(volumewidget, dpi(0), dpi(0), dpi(5), dpi(5))

-- Separators
local first = wibox.widget.textbox('<span font="Roboto 7"> </span>')
local separator = wibox.widget.imagebox(theme.my_separator)

function theme.at_screen_connect(s)
    -- -- Quake application
    -- s.quake = lain.util.quake({app = awful.util.terminal})

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    local tags = require("widgets.util.tags")
    tags.CreateTags(s, 4)
    -- Create a taglist widget
    s.mytaglist = tags.CreateTagList(s, theme.taglist_normal, theme.taglist_active, theme.taglist_occupied)

    local mytaglistcont = wibox.container.background(s.mytaglist, theme.bg_normal, gears.shape.rectangle)
    s.mytag = wibox.container.margin(mytaglistcont, dpi(0), dpi(0), dpi(6), dpi(6))

    -- Create the wibox
    s.mywibox =
        awful.wibar(
        {
            position = "top",
            type = "dock",
            screen = s,
            height = dpi(36),
            width = dpi(2250),
            opacity = 0.95,
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
            widget_tailscale,
            first,
            widget_mic,
            first,
            widget_pihole,
            first,
            wifibutton,
            first,
            logout_menu_widget(),
            first,
            first,
            first,
        }
    }
end

return theme
