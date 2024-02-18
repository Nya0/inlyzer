local module_path = "./lua_modules"
package.path = string.format("%s/share/lua/5.3/?.lua;%s/share/lua/5.3/?/init.lua;./?.lua;", module_path, module_path)
package.cpath = string.format("%s/lib/lua/5.3/?.so;;", module_path)

local IPC = require('server.classes.FifoIpc')
local luv = require('luv')


-- Create a client and connect to the server
local client = IPC.new('/tmp/ipc.sock') -- For Windows, you might use something like "\\.\pipe\ipc_pipe"

client:createClient(function(pipe)
    client:send(pipe, "Hello from client")
end, function(data)
    print("Received from server:", data)
end)

luv.run()
