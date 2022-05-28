local helpers  = require("lain.helpers")
local wibox    = require("wibox")
local awful    = require("awful")

local function ip(args)

    local ip_data = { ip = "0.0.0.0", widget = args.widget or wibox.widget.textbox() }

    local settings = args.settings or function() end

    function ip_data.update()
        awful.spawn.easy_async("curl ifconfig.me", function(new_ip)
            ip_data.ip = new_ip
            ip_now = ip_data.ip
            widget = ip_data.widget
        
            settings()
        end)
    end
    
    helpers.newtimer("ip", 2, ip_data.update)

    return ip_data
end

return ip
