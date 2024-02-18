-- worst workaround
local module_path = "./lua_modules"
package.path = string.format("%s/share/lua/5.3/?.lua;%s/share/lua/5.3/?/init.lua;./?.lua;", module_path, module_path)
package.cpath = string.format("%s/lib/lua/5.3/?.so;;", module_path)

-- test

-- requires
local lfs = require("lfs")

local Lummander = require("lummander")
local Dashboard = require("libs.dashboard")
local Database = require("libs.database")

local CommunicationModule = require("libs.comms")

local serversList = {"127.0.0.1:12346", "127.0.0.1:12347"} -- Example server list

CommunicationModule:init(serversList)

-- Now you can use the module to broadcast messages or perform other operations


-- config
local config = {
    commPort = 4010,
    dashPort = 4080,

    db = {
        host = 'mongodb://127.0.0.1',
        database = 'inlyzer',
        collection = 'logs',
    },
}

-- main code
local cli = Lummander.new{
    title = "Inlyzer", 
    tag = "inlyzer", 
    description = "Intrusion Detection Analyzer blah blah",
    version = "0.1",
    author = "Cyberzone",
    root_path = "/home/nya/inlyzer",
    flag_prevent_help = true
}

local theme = require("libs.theme")

cli:apply_theme(theme)
cli:commands_dir("libs/commands")

-- parser init
Database:init(config.db)
print(Database:generateHash())
cli:parse(arg)
