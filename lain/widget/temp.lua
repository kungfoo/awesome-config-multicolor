--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Luca CPZ

--]]

local helpers  = require("lain.helpers")
local wibox    = require("wibox")
local open     = io.open
local tonumber = tonumber

-- coretemp
local function factory(args)
    local temp     = { widget = wibox.widget.textbox() }
    local args     = args or {}
    local timeout  = args.timeout or 2
    local tempfile = args.tempfile
    local settings = args.settings or function() end

    function temp.find_package_temp_zone()
        if tempfile then
            return tempfile
        end
        
        return "/sys/class/thermal/thermal_zone1/temp"
    end

    function temp.update()
        local f = open(self.find_package_temp_zone())
        if f then
            coretemp_now = tonumber(f:read("*all")) / 1000
            f:close()
        else
            coretemp_now = "N/A"
        end

        widget = temp.widget
        settings()
    end

    helpers.newtimer("coretemp", timeout, temp.update)

    return temp
end


return factory
