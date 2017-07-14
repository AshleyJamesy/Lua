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



function SendToAll(message)
    schannel:push({"all", message})
end

function love.load()
    log = "Log:\n"

    local settings          = serialiser.DeSerialise(git .. "config.json")
    local networkThread     = love.thread.newThread(git .. "network.lua")
    local rchannel          = love.thread.getChannel("network_receive")
    local schannel          = love.thread.getChannel("network_send")

    if MOBILE then
        networkThread:start(rchannel, schannel, settings.ip, 6789, false)
    else
        networkThread:start(rchannel, schannel, settings.ip, 6789, settings.server == "true" and true or false)
    end
end

function love.update(dt)
    Time.deltaTime = dt

    v = rchannel:pop()
    if v then
        if v[1] == "message" then
            log = log .. tostring(v[2]) .. ": " .. tostring(v[3]) .. "\n"
        else
            log = log .. tostring(v[1]) .. ": " .. tostring(v[2]) .. "\n"
        end
    end
end

function love.draw()
    love.graphics.print(log, 0, 0, 0, 1.5, 1.5)
end








