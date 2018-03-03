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

local checkbox 	= false
local slider 	= 0.5

local combo_field = {
	index = 1,
	array = {
		"emission.png",
		"emission_01.png",
		"floor.png",
		"noise.png",
		"tan_bricks.png"
	}
}
local input_default = {
	text 		= "",
	candidate 	= "input"
}

local input_password = {
	text 		= "",
	candidate 	= "password",
	password 	= true
}

local images = {}

hook.Add("love.update", "game", function()
	for k, v in pairs(scene) do
		if v.Update then
			v:Update()
		end
	end
	
	GUI:BeginArea(0,0,220,270)
		GUI:Label("Label")
		GUI:BeginHorizontal()
			GUI:Label("Button:")
			GUI:Button("Button", GUIOption.ExpandWidth(true))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Label("CheckBox:")
			checkbox = GUI:CheckBox(checkbox)
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
		GUI:Label("Slider: " .. string.format("%0.2f", slider))
		slider = GUI:Slider(slider, false, GUIOption.ExpandWidth(true))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
		GUI:Label("Input:")
		GUI:Input(input_default, GUIOption.ExpandWidth(true))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
		GUI:Label("Password:")
		GUI:Input(input_password, GUIOption.ExpandWidth(true))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
		GUI:Label("ComboBox:")
		local source = GUI:ComboBox(combo_field, GUIOption.ExpandWidth(true))
		GUI:EndHorizontal()

		if images[source] == nil then
			images[source] = love.graphics.newImage(source)
		end

		GUI:Label("Image:")
		GUI:Image(images[source])
	GUI:EndArea()
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