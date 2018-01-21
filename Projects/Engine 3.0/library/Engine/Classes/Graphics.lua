local Class = class.NewClass("Graphics")
Class.ID 	= 1
Class.Stack =
{
	canvas = {},
	colour = {},
	shader = {}

}

function Class.SetShader()

end

function Class.SetColour()

end

function Class.SetCanvas()

end

function Class.Push()
	Class.Stack.canvas[Class.ID] = graphics.getCanvas()
	Class.Stack.colour[Class.ID] = { graphics.getColor() }
	Class.Stack.shader[Class.ID] = graphics.getShader()

	Class.ID = Class.ID + 1
end

function Class.Pop()
	Class.Stack.canvas[Class.ID] = nil
	Class.Stack.colour[Class.ID] = nil
	Class.Stack.shader[Class.ID] = nil
	
	Class.ID = Class.ID - 1
	
	graphics.setCanvas(Class.Stack.canvas[Class.ID])
	graphics.setColor(Class.Stack.colour[Class.ID])
	graphics.setShader(Class.Stack.shader[Class.ID])
end