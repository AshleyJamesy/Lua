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

hook.Add("love.load", "game", function(parameters)
    local input = Matrix(2, 1)
        input:Set(3, 3)
        
    local output = Matrix(
end)

hook.Add("love.update", "game", function()
    
end)

hook.Add("love.render", "game", function()
    
end)

hook.Add("KeyPressed", "game", function(key)
	if key == "escape" then
		love.event.quit()
	end
end)