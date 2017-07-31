module("ui", package.seeall)

local Objects = {
	"UICanvas",
	"Frame",
	"Button",
	"Label"
}

local canvas = Canvas()

love.mouse.setVisible(bool)

function Create(name, parent)
	if table.HasValue(Objects, name) then
		local object 	= class.New(name)
		object.parent 	= parent or canvas

		if object.parent then
			table.insert(object.parent.children, object)
		end

		return object
	end
	
	return nil
end

--Default Render
RenderCursor = function(x, y)
	love.graphics.circle("line", x, y, 2)
end

Debug 	= false
Cursor 	= false

function Update()
	canvas:Update()
end

function Render()
	canvas:Render()
	
	local colour = Colour(love.graphics.getColor())
	
	if Cursor then
		love.mouse.setVisible(true)
	else
		if RenderCursor then
			love.mouse.setVisible(false)

			local x, y = love.mouse.getPosition()
			ui.RenderCursor(x,y)
		else
			love.mouse.setVisible(true)
		end
	end
	
	love.graphics.setColor(colour:Unpack())
end

function love.resize(w, h)
	hook.Call("OnWindowResize", w, h)
end

function love.textinput(char)
	hook.Call("OnTextInput", char)
end

function love.mousemoved(x, y, dx, dy, istouch)
	hook.Call("OnMouseMoved", x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
	hook.Call("OnMouseWheel", x, y)
end

function love.mousepressed(x, y, button, istouch)
	hook.Call("OnMousePressed", x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
	hook.Call("OnMouseReleased", x, y, button, istouch)
end