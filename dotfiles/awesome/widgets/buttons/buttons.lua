local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local buttons = {}

function buttons.create_button(icon, icon_color, background_color, hover_color, command)
    local button = wibox.widget {
        {
            {
                font = "Ubuntu Mono 13",
                markup = ' <span color="'.. icon_color ..'">' .. icon .. '</span> ',
                resize = true,
                align  = 'center',
                valign = 'center',
                widget = wibox.widget.textbox,
                id = "main_button"
            },
            id = "widget",
            top = 1, bottom = 1, left = 4, right = 4,
            widget = wibox.container.margin
        },
        bg = background_color, -- basic
        shape_border_width = 1, shape_border_color = background_color, -- outline
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 6)
        end,
        widget = wibox.container.background
        
    }
    button:connect_signal("button::press", function(c, _, _, bt) 
        if bt == 1 then awful.spawn(command)
        end
    end)
    button:connect_signal("mouse::enter", function(c) c:get_children_by_id("main_button")[1]:set_markup(' <span color="'.. hover_color ..'">' .. icon .. '</span> ') end)
    button:connect_signal("mouse::leave", function(c) c:get_children_by_id("main_button")[1]:set_markup(' <span color="'.. icon_color ..'">' .. icon .. '</span> ') end)
    return button
    
end

return buttons