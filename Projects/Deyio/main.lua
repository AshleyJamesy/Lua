FFI = require("ffi")
BIT = require("bit")

Graphics = love.graphics

include("extensions/")
include("util/")
include("callbacks")
include("library/class")
include("library/math/")
include("library/")
include("source/")

class.Load()

hook.Add("love.load", "game", function()
    State("Preload", "state_Preload")
    State("Menu", "state_Menu")
    State("Level", "state_Level")
    State("Credits", "state_Credits")
end)

hook.Add("love.update", "game", function()
    
end)

hook.Add("love.render", "game", function()
    
end)