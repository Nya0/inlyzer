return {
    command = "dashboard <action>",
    description = "Dashboard CLI controls", -- Command description

    hide = false, -- hide from help command
    main = false, -- do this command default action to CLI if true. Default = nil = false
    action = function(parsed, command, app) -- same command:action(function)
        print("yhayhhyahyha")
    end
}