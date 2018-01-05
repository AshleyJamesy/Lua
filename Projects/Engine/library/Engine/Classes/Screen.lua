local Class = class.NewClass("Screen")
Class.dimensions = { 
    love.graphics.getWidth(), 
    love.graphics.getHeight()
}

Class.width      = love.graphics.getWidth()
Class.height     = love.graphics.getHeight()
Class.flipped    = false

function Class.Flip(flip)
    Class.flipped = flip or not Class.flipped
    
    if Class.flipped then
        hook.Call("WindowResize", love.graphics.getHeight(), love.graphics.getWidth())
    else
        hook.Call("WindowResize", love.graphics.getWidth(), love.graphics.getHeight())
    end
end

function Class.GetPoint(x, y)
    if Class.flipped then
        return Screen.width - y, x
    else
        return x, y
    end
end

function Class.Print(text, x, y, sx, sy)
    if Screen.flipped then
        graphics.print(text, y, Class.width - x, math.rad(-90), sx, sy)
    else
        graphics.print(text, x, y, 0, sx, sy)
    end
end

function Class.Draw(object, x, y, r, ...)
    if Screen.flipped then
        graphics.draw(object, y, Class.width - x, math.rad(-90) + r, ...)
    else
        graphics.draw(object, x, y, r, ...)
    end
end

hook.Add("WindowResize", "Screen", function(w, h)
	Class.dimensions[1] = w
	Class.dimensions[2] = h
	Class.width         = w
	Class.height        = h
end)