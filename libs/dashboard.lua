local Dashboard = {}
Dashboard.actions = {}
Dashboard.settings = {
    port = 4000
}

function Dashboard._init()

end

local actions = Dashboard.actions

function actions.on()
    print("what we on!")
end

function actions.off()
    print("what we off")
end

return Dashboard