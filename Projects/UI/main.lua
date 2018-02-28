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

local field_username = {
	text 		= "",
	candidate 	= "Username"
}

local field_password = {
	text 		= "",
	candidate 	= "Password",
	password 	= true
}

hook.Add("love.update", "game", function()
	for k, v in pairs(scene) do
		if v.Update then
			v:Update()
		end
	end

	GUI:BeginArea(0, 0, 500, 500)
	GUI:Space(10)
	GUI:Input(field_username)
	GUI:Input(field_password)
	field_password.password = 
		GUI:CheckBox(field_password.password)
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