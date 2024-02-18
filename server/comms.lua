local module_path = "./lua_modules"
package.path = string.format("%s/share/lua/5.3/?.lua;%s/share/lua/5.3/?/init.lua;./?.lua;", module_path, module_path)
package.cpath = string.format("%s/lib/lua/5.3/?.so;;", module_path)

local IPC = require('server.classes.FifoIpc')

local luv = require("luv")
-- Initialize the client IPC to connect to the server
-- Create a server
local server = IPC.new('/tmp/ipc.sock') -- For Windows, you might use something like "\\.\pipe\ipc_pipe"

server:createServer(function(client)
    print("Client connected")
    -- Handle client
    server:send(client, "Hello from server")

    client:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
            print("Received from client:", chunk)
        else
            server:close(client)
        end
    end)
end)

luv.run()
