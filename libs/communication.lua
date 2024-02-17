local socket = require("socket")

-- Create a TCP server socket
local server = assert(socket.bind("*", 11111))

-- Print server details
print("Server started. Waiting for clients on port 11111...")

-- Accept incoming connections and echo messages
while true do
    local client = server:accept()
    print("Client connected from: " .. client:getpeername())
    
    while true do
        local message = client:receive()
        if message then
            print("Received message: " .. message)
            client:send("Echo: " .. message .. "\n")
        else
            print("Client disconnected")
            client:close()
            break
        end
    end
end