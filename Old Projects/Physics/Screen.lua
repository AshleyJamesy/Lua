include("class")
include("math/Vector2")

local Class, BaseClass = class.NewClass("Screen")
Screen = Class

Class.Center = 0.5 * Vector2(love.graphics.getWidth(), love.graphics.getHeight())