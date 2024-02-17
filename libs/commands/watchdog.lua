local Watchdog  = require("libs.dashboard")

local command = {}

command.command = "watchdog <action>"
command.description = "Inlyzer watchdog controls"

command.action = function(parsed, command, app) --
    if parsed.state == "on" then
        Watchdog.actions.on()
    elseif parsed.state == "off" then
        Watchdog.actions.off()
    end
end

return command