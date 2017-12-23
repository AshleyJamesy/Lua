local Class = class.NewClass("Screen")
Class.Dimensions = { love.graphics.getWidth(), love.graphics.getHeight() }

hook.Add("WindowResize", "Screen", function(w, h)
	Class.Dimensions[1] = w
	Class.Dimensions[2] = h
end)