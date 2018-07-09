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

local gate = GateAction("Arithmetic", "Add")
gate.input        = { "A", "B", "C", "D", "E", "F", "G", "H" }
gate.input_types  = {}
gate.output       = {}
gate.output_types = {}

gate.Output = function(gate, ...)
    local out = 0.0
    for k, v in ipairs({ ... }) do
        if v then
            out = out + v 
        end
    end
    
    return out
end

local ent_Gate = Gate()
ent_Gate.action = GateAction("Arithmetic", "Add")

hook.Add("love.load", "game", function(parameters)
    
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