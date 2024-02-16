local Lummander = require("lummander")

local cli = Lummander.new{
    title = "Inlyzer", 
    tag = "inlyzer", 
    description = "Intrusion Detection Analyzer blah blah",
    version = "0.1",
    author = "Cyberzone",
    theme = "black", 
    flag_prevent_help = false
}

-- Add commands
local commands = {
    dashboard = cli:command("dashboard <state>", "Starts the dashboard"),
    sum = cli:command("sum <value1> <value2>", "Sum 2 values")
}

commands.dashboard:action(function(parsed, command, app)
    if parsed.state == "on" then

    elseif parsed.state == "off" then

    end
end)


commands.sum:option("option1","o","Option1 description",nil,"normal","option_default_value")
commands.sum:action(function(parsed, command, app)
    print("".. parsed.value1.. "+"..parsed.value2.." = " ..tostring(tonumber(parsed.value1) + tonumber(parsed.value2)))
end)

cli:parse(arg)

