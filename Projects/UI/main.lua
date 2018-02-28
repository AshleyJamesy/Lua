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

local open_menu = false
hook.Add("love.update", "game", function()
	for k, v in pairs(scene) do
		if v.Update then
			v:Update()
		end
	end
	--TODO: Fix Horizonal Code, Custom Rect Positioning
	if GUI:Button(open_menu and "Close" or "Menu", GUIOption.Width(200), GUIOption.Height(50)) then
	    open_menu = not open_menu
	end
	
	if open_menu then
    GUI:BeginArea(Screen.width * 0.5, 0, GUIOption.ExpandHeight(true))
        GUI:BeginHorizontal()
            GUI:Button("Hello")
            
            GUI:BeginVertical()
                
            for i = 1, 5 do
                GUI:Button("Hello")
            end
            
            GUI:EndVertical()
            
            GUI:Button("Hello")
        GUI:EndHorizontal()
        GUI:Button("Hello")
    GUI:EndArea()
 end
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