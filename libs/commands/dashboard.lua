local DashModule  = require("libs.dashboard")

local command = {}

command.command = "dashboard <action>"
command.description = "Dashboard CLI controls"

command.action = function(parsed, command, app) --
    if parsed.state == "on" then
        DashModule.on()
    elseif parsed.state == "off" then
        DashModule.off()
    end
end

return command