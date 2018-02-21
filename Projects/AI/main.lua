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
mainFont = love.graphics.newFont(love.window.getPixelScale() * 12)

hook.Add("love.load", "game", function(parameters)
	Screen.Flip()

	camera = Camera(scene)
	
	local w = Screen.width * 0.30
	local h = Screen.height * 0.05

	local button = UIButton(0.0, h * 0.0, w, h, "Menu")
	scene["btn_menu"] = button
	button:Hook(
		function(button)
			if button.toggle then
				scene["btn_save"].visible 	= true
				scene["btn_load"].visible 	= true
				scene["btn_editor"].visible = true
			else
				scene["btn_save"].visible 	= false
				scene["btn_load"].visible 	= false
				scene["btn_editor"].visible = false
			end
		end
	)

	local button = UIButton(0.0, h * 1.0, w, h, "Save")
	scene["btn_save"] = button
	button.stretch:Set(0.15, 0.0)
	button:Hook(
		function(button)
			print("save")
		end
	)
	button.visible = false

	local button = UIButton(0.0, h * 2.0, w, h, "Load")
	scene["btn_load"] = button
	button:Hook(
		function(button)
			print("load")
		end
	)
	button.visible = false

	local button = UIButton(0.0, h * 3.0, w, h, "Editor")
	scene["btn_editor"] = button
	button:Hook(
		function(button)
			print("editor")
		end
	)
	button.visible = false
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