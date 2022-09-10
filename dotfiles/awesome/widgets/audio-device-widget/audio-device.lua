
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local buttons = require("widgets.buttons.buttons")

local HOME = os.getenv('HOME')
local ICON_DIR = HOME .. '/.config/awesome/widgets/audio-device-widget/icons/'

local fg_normal = "#f8f8f2" -- widget font
local fg_focus = "#8AB4F8" -- not sure
local bg_normal = "#101012" -- background - main

local speaker_button = buttons.create_button(
    "蓼",
    fg_normal,
    bg_normal,
    fg_focus, -- border color on hover
    ""
)

local audio_device_widget = wibox.widget {
    speaker_button,
    shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background,
}


local popup = awful.popup {
    ontop = true,
    visible = false,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 10)
    end,
    border_width = 1,
    border_color = beautiful.bg_focus,
    maximum_width = 400,
    offset = { y = 0, x = 0 },
    widget = {}
}

local function worker(user_args)
    local rows = { layout = wibox.layout.fixed.vertical }

    local args = user_args or {}

    local font = args.font or beautiful.font

    local onheadphones = args.onlock or function() awful.spawn.with_shell("pacmd set-default-sink alsa_output.pci-0000_0c_00.4.analog-stereo") end
    local onspeakers = args.onreboot or function() awful.spawn.with_shell("pacmd set-default-sink alsa_output.pci-0000_0a_00.1.hdmi-stereo") end

    local menu_items = {
        { name = 'Speakers', icon_name = 'audio_icon.svg', command = onspeakers },
        { name = 'Headphones', icon_name = 'headphones_icon.svg', command = onheadphones }
    }

    for _, item in ipairs(menu_items) do

        local row = wibox.widget {
            {
                {
                    {
                        image = ICON_DIR .. item.icon_name,
                        resize = false,
                        widget = wibox.widget.imagebox
                    },
                    {
                        text = item.name,
                        font = font,
                        widget = wibox.widget.textbox
                    },
                    spacing = 12,
                    layout = wibox.layout.fixed.horizontal
                },
                margins = 8,
                layout = wibox.container.margin
            },
            bg = beautiful.bg_normal,
            widget = wibox.container.background
        }

        row:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_focus) end)
        row:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.bg_normal) end)

        local old_cursor, old_wibox
        row:connect_signal("mouse::enter", function()
            local wb = mouse.current_wibox
            old_cursor, old_wibox = wb.cursor, wb
            wb.cursor = "hand1"
        end)
        row:connect_signal("mouse::leave", function()
            if old_wibox then
                old_wibox.cursor = old_cursor
                old_wibox = nil
            end
        end)

        row:buttons(awful.util.table.join(awful.button({}, 1, function()
            popup.visible = not popup.visible
            audio_device_widget:set_bg('#00000000')
            item.icon_name = "headphones_icon.svg"
            item.command()
        end)))

        table.insert(rows, row)
    end
    popup:setup(rows)

    audio_device_widget:buttons(
            awful.util.table.join(
                    awful.button({}, 1, function()
                        if popup.visible then
                            popup.visible = not popup.visible
                        else
                            popup:move_next_to(mouse.current_widget_geometry)
                        end
                    end)
            )
    )

    return audio_device_widget

end

return setmetatable(audio_device_widget, { __call = function(_, ...) return worker(...) end })
