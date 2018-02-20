BIT 	= require("bit")
FFI 	= require("ffi")
ENET 	= require("enet")

include("extensions/")
include("util/")
include("callbacks")
include("library/class")
include("library/containers/")
include("library/math/")
include("library/")
include("source/")

class.Load()

local scene = {}

hook.Add("love.load", "game", function(parameters)
    camera = Camera(scene)
    
    scene["btn_save"] = UIButton(50, 150)
    scene["btn_save"].anchor:Set(0.0, 1.0)
    scene["btn_save"].position:Set(0.0, love.graphics.getHeight())
    scene["btn_save"].stretch:Set(1.0, 0.0)
end)

hook.Add("love.update", "game", function()
    for k, v in pairs(scene) do
        if v.Update then
            v:Update()
        end
    end
end)

hook.Add("love.render", "game", function()
    camera:Render()
    camera:Show()
end)

hook.Add("KeyPressed", "game", function(key)
	if key == "escape" then
		love.event.quit()
	end
end)