local luasql = require("luasql.mysql")
local env = luasql.mysql()
local io = require("io")
local os = require("os")

local database = {
    currentHash = nil,
    _lastUpdate = os.clock(),

    auth = {
        name = nil,
        user = nil,
        pass = nil,
        host = nil,
    },

    _connection = nil
}

local funcs = {} -- local funcs

-- Function to execute a command and return its output
function funcs.exec(command)
    local handle = io.popen(command)
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result
    else
        error()    
    end
end

function database:init(dbTable)
    self.auth = dbTable
end

function database:connect()
    return env:connect(self.auth.dbName, self.auth.user, self.auth.password, self.auth.host)
end

function database:generateHash()
    local conn = self._connection or self:Connect()

    local schemaHashCommand = "echo '"
    local cursor = conn:execute("SHOW TABLES")
    local table, _ = cursor:fetch({}, "a")
    while table do
        local tableCursor = conn:execute("DESCRIBE " .. table[1])
        local field = tableCursor:fetch({}, "a")
        while field do
            schemaHashCommand = schemaHashCommand .. table[1] .. field.Field .. field.Type
            field = tableCursor:fetch(field, "a")
        end
        table, _ = cursor:fetch(table, "a")
    end
    schemaHashCommand = schemaHashCommand .. "' | openssl dgst -sha256"
    local schemaHash = funcs.exec(schemaHashCommand):match("%w+%s(%w+)")

    local dataCharCommand = "echo '"
    cursor = conn:execute("SELECT table_name, MAX(update_time) FROM information_schema.tables WHERE table_schema = '" .. self.auth.name .. "' GROUP BY table_name")
    local info = cursor:fetch({}, "a")
    while info do
        dataCharCommand = dataCharCommand .. info.table_name .. info['MAX(update_time)']
        info = cursor:fetch(info, "a")
    end
    dataCharCommand = dataCharCommand .. "' | openssl dgst -sha256"
    local dataCharHash = funcs.exec(dataCharCommand):match("%w+%s(%w+)")

    local finalHash = funcs.exec("echo '" .. schemaHash .. dataCharHash .. "' | openssl dgst -sha256"):match("%w+%s(%w+)")

    return finalHash
end

return database
