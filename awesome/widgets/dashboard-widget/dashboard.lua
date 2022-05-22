local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local HOME = os.getenv('HOME')
local ICON_DIR = HOME .. '/.config/awesome/widgets/logout-menu-widget/icons/'


local dashboard_widget = wibox.widget {
    {
        {
            image = ICON_DIR .. 'power_w.svg',
            resize = true,
            widget = wibox.widget.imagebox,
        },
        margins = 7,
        layout = wibox.container.margin
    },
    shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background,
}

local dashboard = awful.popup {
    ontop = true,
    visible = false,
    shape = gears.shape.rounded_rect,
    border_width = 1,
    border_color = beautiful.bg_focus,
    maximum_width = 1000,
    offset = { y = 5 },
    widget = {}
}

local function worker(args)

    local rows = { layout = wibox.layout.fixed.vertical }
    -- add contents to dashboard here
    local test_item = wibox.widget {
        {
            {
                {
                    text = "Hello, world!",
                    font = beautiful.font,
                    widget = wibox.widget.textbox
                },
                spacing = 7,
                layout = wibox.layout.fixed.horizontal
            },
            margins = 8,
            layout = wibox.container.margin
        },
        bg = beautiful.bg_normal,
        widget = wibox.container.background
    }

    table.insert(rows, test_item)

    dashboard:setup(rows)


    dashboard_widget:buttons(
        awful.util.table.join(
                awful.button({}, 1, function()
                    if dashboard.visible then
                        dashboard.visible = not dashboard.visible
                        dashboard_widget:set_bg('#00000000')
                    else
                        dashboard:move_next_to(mouse.current_widget_geometry)
                        dashboard_widget:set_bg(beautiful.bg_focus)
                    end
                end)
        )
    )

    return dashboard_widget

end

return setmetatable(dashboard_widget, { __call = function(_, ...) return worker(...) end })