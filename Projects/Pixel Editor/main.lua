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
include("math/Vector2")
include("math/Vector3")
include("math/Vector4")

function love.load()
    log = ""
    a = {1, 3, 5, 10}
    
    if table.isSequenced(a) then
        log = "is sequenced"
    end
end

function love.update(dt)
    
end

function love.draw()
    love.graphics.print(log, 0, 0, 0, 2, 2)
end








