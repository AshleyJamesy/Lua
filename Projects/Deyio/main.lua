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
    
    activeState = State("Preload")
end)

hook.Add("love.update", "game", function()
    activeState:Update()
end)

hook.Add("love.render", "game", function()
    activeState:Render()
end)