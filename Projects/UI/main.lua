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
	Screen.Flip()
	camera 	= Camera(scene)
end)

local image = love.graphics.newImage(git .. "tan_bricks.png")
local text = ""
local sliders = {
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0
}

local checkboxes = {
    false,
    false
}
hook.Add("love.update", "game", function()
	for k, v in pairs(scene) do
		if v.Update then
			v:Update()
		end
	end
	--TODO: Fix Horizonal Code, Custom Rect Positioning
	--GUI:BeginHorizontal()
	GUI:BeginArea(200, 500, GUIOption.ExpandHeight(false))
		GUI:Label(" DEBUG MENU", GUIOption.ExpandWidth(true), GUIOption.Align("center"))
		
		GUI:Label(" LABELS")
		GUI:BeginHorizontal()
			GUI:Space(10)
			GUI:Label("Slider 1: " .. string.format("%0.2f", sliders[1]))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Space(10)
			GUI:Label("Slider 2: " .. string.format("%0.2f", sliders[2]))
		GUI:EndHorizontal()

		GUI:Label(" CHECKBOXES")
		GUI:BeginHorizontal()
			GUI:Space(10)
			GUI:Label("Checkbox 1:")
			checkboxes[1] = GUI:CheckBox(checkboxes[1])
			GUI:Space(10)
			GUI:Label(checkboxes[1] and "On" or "Off")
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Space(10)
			GUI:Label("Checkbox 2:")
			checkboxes[2] = GUI:CheckBox(checkboxes[2])
			GUI:Space(10)
			GUI:Label(checkboxes[2] and "On" or "Off")
		GUI:EndHorizontal()

		GUI:Label(" BUTTONS")
		GUI:BeginHorizontal()
			GUI:Space(10)
			if GUI:Button("Button 1") then
				checkboxes[1] = not checkboxes[1]
			end
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Space(10)
			if GUI:Button("Button 2") then
				checkboxes[2] = not checkboxes[2]
			end
		GUI:EndHorizontal()

		GUI:Label(" SLIDERS")
		GUI:BeginHorizontal()
			GUI:Space(10)
			sliders[1] = GUI:Slider(sliders[1], false, GUIOption.Width(104))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Space(10)
			sliders[2] = GUI:Slider(sliders[2], true, GUIOption.Width(20), GUIOption.Height(100))
			sliders[3] = GUI:Slider(sliders[3], true, GUIOption.Width(20), GUIOption.Height(100))
			sliders[4] = GUI:Slider(sliders[4], true, GUIOption.Width(20), GUIOption.Height(100))
			sliders[5] = GUI:Slider(sliders[5], true, GUIOption.Width(20), GUIOption.Height(100))
			sliders[6] = GUI:Slider(sliders[6], true, GUIOption.Width(20), GUIOption.Height(100))
		GUI:EndHorizontal()

		GUI:Label(" IMAGES")
		GUI:BeginHorizontal()
			GUI:Space(10)
			GUI:Image(image, GUIOption.Width(50 + sliders[2] * 50),  GUIOption.Height(50 + sliders[3] * 50))
		GUI:EndHorizontal()
		GUI:Space(5)
		GUI:BeginHorizontal()
			GUI:Image(image, GUIOption.ExpandWidth(true), GUIOption.Option("keepaspect", true))
		GUI:EndHorizontal()
	GUI:EndArea()
	
	sliders[1] = GUI:Slider(sliders[1])
	
	--GUI:EndHorizontal()
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