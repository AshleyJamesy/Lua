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
end)

local value = 0.0

local input_field = {
	text 		= "john",
	candidate 	= "input field",
	password 	= false
}

local password_field = {
	text 		= "",
	candidate 	= "password field",
	password 	= true
}

local textbox_field = {
	text 		= "",
	multiline 	= true
}

local list_combobox = {
	index = 1,
	array = {
		"A",
		"B",
		"C",
		"D"
	}
}

local clicks 	= 0
local checkbox 	= false
local image 	= love.graphics.newImage("tan_bricks.png")

hook.Add("love.update", "game", function()
	Input.Update()

	for k, v in pairs(scene) do
		if v.Update then
			v:Update()
		end
	end
	
	GUI:BeginArea(0, 0, 350, 500, GUIOption.ExpandHeight(true))
		GUI:BeginHorizontal()
			GUI:Label(" Label", GUIOption.Width(150), GUIOption.Height(25))
			GUI:Label("Label", GUIOption.Width(150), GUIOption.Height(25), GUIOption.Option("align", "center"))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Label(" Button", GUIOption.Width(150), GUIOption.Height(25))
			if GUI:Button("Button", GUIOption.Width(150), GUIOption.Height(25)) then 
				clicks = clicks + 1
			end
			GUI:Label(" " .. clicks, GUIOption.Width(25), GUIOption.Height(25))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Label(" Checkbox", GUIOption.Width(150), GUIOption.Height(25))
			checkbox = GUI:CheckBox(checkbox, GUIOption.Width(25), GUIOption.Height(25))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Label(" Slider", GUIOption.Width(150), GUIOption.Height(25))
			value = GUI:Slider(value, 50, 100, GUIOption.Width(150), GUIOption.Height(25))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
		GUI:Space(150)
		GUI:Label(string.format(" %0.1f, min:%d, max:%d", value, 50, 100), GUIOption.Width(180), GUIOption.Height(25))
		GUI:EndHorizontal()

		GUI:Space(10)
		GUI:BeginHorizontal()
			GUI:Label(" Input", GUIOption.Width(150), GUIOption.Height(25))
			GUI:Input(input_field, GUIOption.Width(150), GUIOption.Height(25))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Label(" Password", GUIOption.Width(150), GUIOption.Height(25))
			GUI:Input(password_field, GUIOption.Width(150), GUIOption.Height(25))
		GUI:EndHorizontal()
		
		GUI:BeginHorizontal()
			GUI:Label(" RichTextBox", GUIOption.Width(150), GUIOption.Height(25))
			GUI:Input(textbox_field, GUIOption.Width(150), GUIOption.Height(100), GUIOption.Option("valign", "top"))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
		GUI:Space(151)
		if GUI:Button("Run", GUIOption.Width(150), GUIOption.Height(25)) then
			local func = loadstring(textbox_field.text)
			
			if func then
				local status output = pcall(func)
			end
		end
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Label(" ComboBox", GUIOption.Width(150), GUIOption.Height(25))
			GUI:ComboBox(list_combobox, GUIOption.Width(150), GUIOption.Height(25))
		GUI:EndHorizontal()

		GUI:BeginHorizontal()
			GUI:Label(" Image", GUIOption.Width(150), GUIOption.Height(25))
			GUI:Image(image, GUIOption.Width(150), GUIOption.Height(150))
		GUI:EndHorizontal()
	GUI:EndArea()
end)

hook.Add("love.render", "game", function()
	GUI:Render()
	GUI:Show()
	
	camera:Render()
	camera:Show()

	Input.LateUpdate()
end)

hook.Add("KeyPressed", "game", function(key)
	if key == "escape" then
		--love.event.quit()
	end
end)