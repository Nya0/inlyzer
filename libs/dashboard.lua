local dashboard = {}
dashboard.actions = {}
dashboard.settings = {
    port = 4000
}

function dashboard._init()

end

local actions = dashboard.actions

function actions.on()
    print("what we on!")
end

function actions.off()
    print("what we off")
end

return dashboard