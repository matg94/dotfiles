local awful   = require("awful")
local naughty = require("naughty")
local gears   = require("gears")
local wibox   = require("wibox")

local function factory(args)
    local args = args or {}

    local device = {
        widget   = args.widget,
        settings = args.settings,
        timeout  = args.timeout or 30,
        timer    = gears.timer,
        state    = "",
    }

    function device:disable()
        awful.spawn.easy_async(args.disable_func,
            function()
                self:update()
            end
        )
    end

    function device:enable()
        awful.spawn.easy_async(args.enable_func,
            function()
                self:update()
            end
        )
    end

    function device:toggle()
        if args.toggle_func then
            awful.spawn.easy_async(args.toggle_func,
                function()
                    self:update()
                end
            )
        else
            if self.state == "off" then
                self:enable()
            else
                self:disable()
            end
        end
    end

    function device:pressed(button)
        if button == 1 then
            self:toggle()
        end
    end

    function device:update()
        -- Check that timer has started
        if self.timer.started then
            self.timer:emit_signal("timeout")
        end
    end

    -- Read `amixer get Capture` command and try to `grep` all "[on]" lines.
    --   - If there are lines with "[on]" then assume microphone is "unmuted".
    --   - If there are NO lines with "[on]" then assume microphone is "muted".
    device, device.timer = awful.widget.watch(
        args.get_status_func,
        device.timeout,
        function(self, stdout, stderr, exitreason, exitcode)
            local current_device_state = "error"

            if exitcode == 1 then
                -- Exit code 1 - no line selected
                current_device_state = "off"
            elseif exitcode == 0 then
                -- Exit code 0 - a line is selected
                current_device_state = "on"
            else
                -- Other exit code (2) - error occurred
                current_device_state = "error"
            end

            -- Compare new and old state
            if current_device_state ~= self.state then
                -- Store new microphone state
                self.state = current_device_state
            end

            -- Call user/theme defined function
            self:settings()
        end,
        device  -- base_widget (passed in callback function as first parameter)
    )

    -- add mouse click
    device.widget:connect_signal("button::press", function(c, _, _, button)
        device:pressed(button)
    end)

    return device
end

return factory
