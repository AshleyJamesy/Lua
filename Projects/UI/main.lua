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
	--Screen.Flip()
	camera 	= Camera(scene)
end)

combo_field = {
	index 	= 1,
	array 	= { 
		"tan_bricks.png",
		"emission.png",
		"emission_01.png",
		"floor.png",
		"noise.png"
	}
}

images = {}

hook.Add("love.update", "game", function()
	for k, v in pairs(scene) do
		if v.Update then
			v:Update()
		end
	end
	
	GUI:BeginArea(0, 0, 500, 500)
	GUI:Space(10)
	
	local selection = GUI:ComboBox(combo_field, GUIOption.Width(150))
	if images[selection] == nil then
		images[selection] = love.graphics.newImage(selection)
	end
	
	GUI:Image(images[selection])
end)

hook.Add("love.render", "game", function()
	GUI:Render()
	GUI:Show()

	camera:Render()
	camera:Show()
end)

hook.Add("KeyPressed", "game", function(key)
	if key == "escape" then
		love.event.quit()
	end
end)