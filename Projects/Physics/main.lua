includes = {}

if not MOBILE then
    git = ""
end

function GetProjectDirectory()
    return git 
end

function include(file)
    local include_path  = string.gsub(GetProjectDirectory(), "/", ".")
    local file_path     = string.gsub(file, "/", ".")
    local full_path     = include_path .. file_path
    
    if includes[full_path] then 
        return
    end
    
    local file = require(full_path)
    
    includes[full_path] = true
    
    return file
end

include("extensions/table")
include("types")
include("class")
include("serialiser")
include("Time")
include("math/Vector2")
include("math/Vector3")
include("math/Vector4")
include("World")
include("Collider")
include("Circle")
include("AABB")
include("RigidBody")

local settings = serialiser.DeSerialise(git .. "config.json")

local networkThread = love.thread.newThread(git .. "network.lua")
local channel       = love.thread.getChannel("network")
networkThread:start(channel, settings.ip, 6789, settings.server == "true" and true or false)

function love.load()
    log = "Log:\n"
    i = {}
end

function love.update(dt)
    Time.deltaTime = dt

    v = channel:pop()
    if v then
        log = log .. tostring(v[1]) .. ", " .. tostring(v[2]) .. "\n"
    end
end

function love.draw()
    love.graphics.print(log, 0, 0, 0, 1.5, 1.5)
end








