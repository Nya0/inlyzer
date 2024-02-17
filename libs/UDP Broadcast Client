local socket = require("socket")

-- Create a UDP socket
local udp = assert(socket.udp())

-- Set the broadcast address and port
udp:setoption("broadcast", true)
udp:setpeername("255.255.255.255", 12345)

-- Send a broadcast message
udp:send("Hello, this is a broadcast message")

print("Broadcast message sent.")
