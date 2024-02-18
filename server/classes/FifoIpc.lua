local uv = require('luv')

-- Define the SocketIPC class
local SocketIPC = {}
SocketIPC.__index = SocketIPC

-- Constructor
function SocketIPC:new(mode, address, port)
    local self = setmetatable({}, SocketIPC)
    self.mode = mode -- "server" or "client"
    self.address = address
    self.port = port
    self.socket = nil
    self.is_connected = false
    return self
end

-- Start the server
function SocketIPC:startServer(onReceive)
    assert(self.mode == "server", "This instance is not configured as a server")
    
    self.socket = uv.new_tcp()
    uv.tcp_bind(self.socket, self.address, self.port)
    local function on_new_connection(client, err)
        if not client then
            print("Failed to accept connection:", err)
            return
        end

        uv.read_start(client, function(err, chunk)
            if err then
                print("Read error:", err)
            elseif chunk then
                if onReceive then onReceive(chunk) end
            else
                uv.close(client)
            end
        end)
    end

    uv.listen(self.socket, 128, function(err)
        assert(not err, err)
        local client = uv.new_tcp()
        uv.accept(self.socket, client)
        on_new_connection(client)
    end)

    print("Server started on " .. self.address .. ":" .. self.port)
end

-- Connect as a client
function SocketIPC:connect()
    assert(self.mode == "client", "This instance is not configured as a client")

    self.socket = uv.new_tcp()
    uv.tcp_connect(self.socket, self.address, self.port, function(err)
        assert(not err, err)
        self.is_connected = true
        print("Connected to server")
    end)
end

-- Send message (usable by both server and client)
function SocketIPC:sendMessage(message)
    assert(self.is_connected or self.mode == "server", "Not connected or not a server")
    
    local formattedMessage = message .. "\n" -- Assuming messages are newline-delimited
    uv.write(self.socket, formattedMessage)
end

-- Close the connection/socket
function SocketIPC:close()
    if self.socket then
        uv.close(self.socket, function()
            print("Socket closed")
            self.is_connected = false
        end)
    end
end

return SocketIPC
