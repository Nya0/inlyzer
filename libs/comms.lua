local uv = require('luv')
local md5 = require("md5") 

local CommunicationModule = {
    serversList = {},
    tcpHandles = {}
}

function CommunicationModule:createServer(host, port, onConnection)
    local server = uv.new_tcp()
    server:bind(host, port)

    server:listen(128, function(err)
        assert(not err, err)
        local client = uv.new_tcp()
        server:accept(client)
        onConnection(client)
    end)

    return server
end

function CommunicationModule:init(serversList)
    self.serversList = serversList

    local echoServer = self:createServer("0.0.0.0", 0, function(client)
        client:read_start(function(err, chunk)
            assert(not err, err)
            if chunk then
                client:write(chunk)
            else
                client:close()
            end
        end)
    end)

    print("Server listening on port " .. echoServer:getsockname().port)
end

-- placeholder for starting the module
function CommunicationModule:start()
    uv.run()
end

return CommunicationModule
