local mongo = require('mongo')
local io = require("io")
local os = require("os")

local md5 = require("md5")

-- Common variables
local id = mongo.ObjectID()

local Database = {
    currentHash = nil,
    _lastUpdate = os.clock(),

    mongo = {
        host = nil,
        database = nil,
        collection = nil,
    },

    _client = nil
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

function Database:init(mongoTable)
    self.mongo = mongoTable
    self._client = self:connect()
end

function Database:connect()
    return mongo.Client(self.mongo.host)
end


function Database:generateHash()
    local collection = self._client:getCollection(self.mongo.database, self.mongo.collection)
    local count = collection:count({})
    
    local options = { ["sort"] = { updatedAt = -1 }, ["limit"] = 1 }
    local cursor = collection:find({}, options)
    local lastUpdatedDoc = cursor:next()
    local lastUpdateTime = lastUpdatedDoc and lastUpdatedDoc.updatedAt

    local baseString = tostring(count) .. "-" .. tostring(lastUpdateTime)
    
    local hashValue = md5.sumhexa(baseString)
    self.currentHash = hashValue
    
    return self.currentHash
end


return Database
