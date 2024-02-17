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

-- config
local config = {
    commPort = 4010,
    dashPort = 4080,

    db = {
        name = "inlyzerDB",
        user = "inlyzerADMIN",
        pass = "testpass",
        host = "localhost",
    }
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
cli:parse(arg)
