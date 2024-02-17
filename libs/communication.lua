local socket = require("socket")

-- Create a TCP server socket
local server = assert(socket.bind("*", 12345))

-- Set timeout to avoid blocking indefinitely
server:settimeout(0.001)

-- Print server details
print("Server started. Waiting for clients on port 12345...")

-- Table to store connected clients
local clients = {}

while true do
    -- Accept incoming connections
    local client = server:accept()
    if client then
        table.insert(clients, client)
        print("Client connected from: " .. client:getpeername())
    end
    
    -- Check for messages from clients
    for i, client in ipairs(clients) do
        local message, err = client:receive()
        if message then
            print("Received message from client " .. i .. ": " .. message)

            -- Broadcasting the message to all clients
            for j, otherClient in ipairs(clients) do
                if otherClient ~= client then
                    otherClient:send("Client " .. i .. " says: " .. message .. "\n")
                end
            end
        elseif err == "closed" then
            print("Client " .. i .. " disconnected")
            table.remove(clients, i)
        end
    end
end