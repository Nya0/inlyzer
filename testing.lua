local module_path = "./lua_modules"
package.path = string.format("%s/share/lua/5.3/?.lua;%s/share/lua/5.3/?/init.lua;./?.lua;", module_path, module_path)
package.cpath = string.format("%s/lib/lua/5.3/?.so;;", module_path)



local luv = require('luv')

local socket_path = "/tmp/my_service.socket"
-- Remove the socket file if it already exists
os.remove(socket_path)

local server = luv.new_pipe(false)
server:bind(socket_path)
server:listen(128, function(err)
    assert(not err, err)
    local client = luv.new_pipe(false)
    server:accept(client)
    client:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
            -- Process command here
            print("Received command:", chunk)
        else
            client:close()
        end
    end)
end)

-- Main event loop
luv.run()
