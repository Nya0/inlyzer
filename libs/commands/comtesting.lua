local DashModule  = require("libs.dashboard")

local command = {}

command.command = "dashboard <action>"
command.description = "Dashboard CLI controls"

command.action = function(parsed, command, app) --
    if parsed.state == "on" then
        DashModule.actions.on()
    elseif parsed.state == "off" then
        DashModule.actions.off()
    end
end

return command