local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local tags = {}

function tags.CreateTags(screen, number_of_tags)
    awful.tag.add(
        " ",
        {
            layout = awful.layout.suit.tile,
            screen = screen,
            gap_single_client = true,
            gap = 5,
            selected = true
        }
    )
    for i = 1, number_of_tags - 1, 1 do
        awful.tag.add(
            " ",
            {
                layout = awful.layout.suit.max,
                screen = screen
            }
        )
    end
end

function tags.CreateTagList(s, background_normal, background_active, background_occupied)
    beautiful.taglist_bg_focus = background_active
    beautiful.taglist_bg_occupied = background_occupied
    beautiful.taglist_bg_empty = background_normal

    local taglist_buttons =
        gears.table.join(
        awful.button(
            {},
            1,
            function(t)
                t:view_only()
            end
        ),
        awful.button(
            {modkey},
            1,
            function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end
        ),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button(
            {modkey},
            3,
            function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end
        ),
        awful.button(
            {},
            4,
            function(t)
                awful.tag.viewnext(t.screen)
            end
        ),
        awful.button(
            {},
            5,
            function(t)
                awful.tag.viewprev(t.screen)
            end
        )
    )

    return awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        style = {shape = gears.shape.circle},
        layout = {spacing = dpi(8), layout = wibox.layout.fixed.horizontal},
        buttons = taglist_buttons,
        bg_focus = background_active,
        widget_template = {
            {
                {
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                        align = "center",
                        valign = "center"
                    },
                    margins = dpi(6),
                    widget = wibox.container.margin
                },
                widget = wibox.container.background
            },
            id = "background_role",
            bg = background_normal,
            widget = wibox.container.background
        }
    }
end

return tags
