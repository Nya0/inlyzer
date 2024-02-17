local tcpServer = {}

function tcpServer.startServer(port)
    local socket = require("socket")
    local server = assert(socket.bind("*", port))
    server:settimeout(0.001) -- Non-blocking accept
    print("Server started. Waiting for clients on port " .. port .. "...")

    local clients = {} -- Store connected clients

    local function broadcast(message, sender)
        for i, client in ipairs(clients) do
            if client ~= sender then
                client:send(message)
            end
        end
    end

    while true do
        -- Accept new connections
        local client = server:accept()
        if client then
            client:settimeout(0) -- Non-blocking receive
            table.insert(clients, client)
            print("Client connected from: " .. client:getpeername())
        end

        -- Check for messages from clients
        for i = #clients, 1, -1 do
            local client = clients[i]
            local message, err = client:receive()
            if message then
                print("Received message from client " .. i .. ": " .. message)
                broadcast("Client " .. i .. " says: " .. message .. "\n", client)
            elseif err == "closed" then
                print("Client " .. i .. " disconnected")
                table.remove(clients, i)
                client:close()
            end
        end
    end
end

return tcpServer