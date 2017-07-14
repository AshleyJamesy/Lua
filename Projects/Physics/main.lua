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

local networkThread = love.thread.newThread(git .. "network.lua")
local channel = love.thread.getChannel("network")
networkThread:start(channel)

include("extensions/table")
include("types")
include("class")
include("Time")
include("math/Vector2")
include("math/Vector3")
include("math/Vector4")
include("World")
include("Collider")
include("Circle")
include("AABB")
include("RigidBody")

function love.load()
    MyBody = RigidBody(100, 100)
    Shape  = Circle(25)
    MyBody.collider = Shape
    
    MyBody2 = RigidBody(100, 500)
    MyBody2.collider = Shape
    MyBody2.static = true
    
    MyWorld = World()
    MyWorld:Add(MyBody)
    MyWorld:Add(MyBody2)
end

function love.update(dt)
    Time.deltaTime = dt
    MyWorld:Update()
end

function love.draw()
    MyWorld:Draw()
end








