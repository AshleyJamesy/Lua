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
	myGUI 	= GUI(0, 0, 200, Screen.height)
	myView 	= GUI(200, 0, 400, Screen.height)

	camera 	= Camera(scene)
end)

hook.Add("love.update", "game", function()
	for k, v in pairs(scene) do
		if v.Update then
			v:Update()
		end
	end

	myGUI:Update()
	if GUI:Button(" a", GUIOption.Align("left")).onClick then

	end

	if GUI:Button(" b", GUIOption.Align("left")).onClick then

	end

	myView:Update()
end)

hook.Add("love.render", "game", function()
	myGUI:Render()
	myGUI:Show()

	myView:Render()
	myView:Show()

	camera:Render()
	camera:Show()
end)

hook.Add("KeyPressed", "game", function(key)
	if key == "escape" then
		love.event.quit()
	end
end)