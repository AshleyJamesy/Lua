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
include("Screen")
include("math/Vector2")
include("math/Vector3")
include("math/Vector4")
include("World")
include("Collider")
include("Circle")
include("AABB")
include("RigidBody")
include("Particle")
include("ParticleSystem")

function love.load()
    image = love.graphics.newImage(GetProjectDirectory() .. "particle.png")
    MyParticleSystem = ParticleSystem(image, 1000)
    System = ParticleSystem(image, 100)
end

function love.touchmoved(id, x, y)
    MyParticleSystem.position:Set(x,y)
end

function love.update(dt)
    Time.deltaTime = dt
    Time.timeElapsed = Time.timeElapsed + dt
    
    MyParticleSystem:Update()
    System:Update()
end

function love.draw()
    MyParticleSystem:Draw()
    System:Draw()
    love.graphics.setColor(255,255,255,255)
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10, 0, 3, 3)
end








