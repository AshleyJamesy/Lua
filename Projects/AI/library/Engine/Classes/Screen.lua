local Class = class.NewClass("Screen")

local graphics = love.graphics

Class.dimensions = { 
	love.graphics.getWidth(), 
	love.graphics.getHeight()
}

Class.width 	= love.graphics.getWidth()
Class.height 	= love.graphics.getHeight()
Class.aspect 	= Class.width / Class.height
Class.center 	= Vector2(graphics.getWidth(), graphics.getHeight()) * 0.5

Class.flipped 	= false

function Class.Flip(flip)
	Screen.flipped = flip or not Screen.flipped
	
	if Screen.flipped then
		hook.Call("WindowResize", graphics.getHeight(), graphics.getWidth())
	else
		hook.Call("WindowResize", graphics.getWidth(), graphics.getHeight())
	end
end

function Class.Point(x, y)
	if Screen.flipped then
		return Screen.width - y, x
	end
	
	return x, y
end

function Class.Print(text, x, y, sx, sy)
	if Screen.flipped then
		graphics.print(text, y, Screen.width - x, math.rad(-90), sx, sy)
	else
		graphics.print(text, x, y, 0, sx, sy)
	end
end

function Class.Draw(object, x, y, r, ...)
	if Screen.flipped then
		graphics.draw(object, y, Screen.width - x, math.rad(-90) + r, ...)
	else
		graphics.draw(object, x, y, r, ...)
	end
end

hook.Add("WindowResize", "Screen", function(w, h)
	Class.dimensions[1] = w
	Class.dimensions[2] = h
	Class.width 		= w
	Class.height 		= h
	Class.aspect 		= w / h

	Class.center:Set(w * 0.5, h * 0.5)
end)