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
	
	camera = Camera(scene)
	
	local h = Screen.height * 0.15

	scene["btn_menu"] = UIButton(0, h * 0.0, 150, 50, "Menu")
	scene["btn_menu"].stretch:Set(0.25, 0.15)
	scene["btn_menu"]:Hook(
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

	scene["btn_save"] = UIButton(0, h * 1.0, 150, 50, "Save")
	scene["btn_save"].stretch:Set(0.25, 0.15)
	scene["btn_save"]:Hook(
		function(button)
			print("save")
		end
	)
	scene["btn_save"].visible = false

	scene["btn_load"] = UIButton(0, h * 2.0, 150, 50, "Load")
	scene["btn_load"].stretch:Set(0.25, 0.15)
	scene["btn_load"]:Hook(
		function(button)
			print("load")
		end
	)
	scene["btn_load"].visible = false

	scene["btn_editor"] = UIButton(0, h * 3.0, 150, 50, "Editor")
	scene["btn_editor"].stretch:Set(0.25, 0.15)
	scene["btn_editor"]:Hook(
		function(button)
			print("editor")
		end
	)
	scene["btn_editor"].visible = false
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