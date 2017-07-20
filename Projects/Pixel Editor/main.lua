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
include("Time")
include("composition/scene/SceneManager")
include("composition/GameObject")

function GameLoad()

end

function love.load()
	SceneManager.CreateScene("scene")

	GameLoad()

	SceneManager.RunFunction("SceneLoaded", nil, SceneManager.GetActiveScene())
end

function love.keypressed(key, scancode, isrepeat)
	SceneManager.RunFunction("KeyPressed", nil,  key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
	SceneManager.RunFunction("KeyReleased", nil, key, scancode)
end

function love.mousemoved(x, y, dx, dy, istouch)
	SceneManager.RunFunction("MouseMoved", nil, x, y, dx, dy, istouch)
end

function love.mousepressed(x, y, button, istouch)
	SceneManager.RunFunction("MousePressed", nil, x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
	SceneManager.RunFunction("MouseReleased", nil, x, y, button, istouch)
end

function love.update(dt)
	SceneManager.Update(dt)
	SceneManager.RunFunction("LateUpdate", nil, dt)
end

function love.draw()
	SceneManager.RunFunction("Render")
	SceneManager.RunFunction("Gizmos")

	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end







