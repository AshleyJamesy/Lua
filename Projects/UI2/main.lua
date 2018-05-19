BIT  = require("bit")
FFI  = require("ffi")
ENET = require("enet")

include("extensions/")
include("util/")
include("callbacks")
include("library/class")
include("library/containers/")
include("library/math/")
include("library/")
include("source/")
    
class.Load()

--TODO:
--hash all components
--get all components in camera(s) view
--sort them back to front with function indexOrder^17 * layer^17 + id
--render

hook.Add("love.load", "game", function(parameters)
    Screen.Flip()
    SceneManager:GetActiveScene()
    
    hashtable = HashTable()
   
    local go = GameObject()
    go:AddComponent("Camera")
    go:GetComponent("Camera").cameraType = CameraType.Game
    
    gameCam = go:GetComponent("Camera")
    
    for i = 1, 1000 do
        local go = GameObject()
        go:AddComponent("ShapeRenderer")
        go:AddComponent("Ball")
        
        go.transform.position.x = math.random() * 1000 - 500
        go.transform.position.y = math.random() * 1000 - 500
    end
end)

hook.Add("love.update", "game", function()
    Input.Update()
    SceneManager.activeScene:Update()
    
    GUI:Label(love.timer.getFPS(), GUIOption.Width(100), GUIOption.Height(25))
    
    SceneManager.activeScene:LateUpdate()
    
    Renderer.Batch()
end)

hook.Add("love.render", "game", function()
    SceneManager.activeScene:Render()
    
    Screen.Draw(Camera.main.buffers.post.source, 0, 0, 0)
    
    GUI:Render()
    GUI:Show()
    
    Input.LateUpdate()
end)

hook.Add("KeyPressed", "game", function(key)
    if key == "escape" then
	       love.event.quit()
    end
end)