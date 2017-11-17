local Class = class.NewClass("Handles")
Class.colour = Colour(255,255,255,255)

function Class.Slider(position, direction, size, snap)
	love.graphics.setLineWidth(3.0)
	love.graphics.setColor(Class.colour:Unpack())
	love.graphics.line(position.x, position.y, position.x + direction.x * size or 1, position.y + direction.y * size or 1)
	love.graphics.setLineWidth(1.0)
	love.graphics.setColor(255,255,255,255)
	
	return position
end

local isDown = false
function Class.RotationHandle(position, rotation, radius)
	love.graphics.setLineWidth(3.0)
	love.graphics.setColor(Class.colour:Unpack())
	love.graphics.circle("line", position.x, position.y, radius)
	love.graphics.setLineWidth(1.0)
	love.graphics.setColor(255,255,255,255)
	
	local x, y = Camera.main:ToWorld(love.mouse.getPosition())
	local v = position - Vector2(x, y)

	if love.mouse.isDown(1) and not isDown then
		local m = v:Magnitude()

		if m > radius - 2 and m < radius then
			isDown = true
		end
	elseif isDown then
		return v:ToAngle()
	end

	return rotation
end

local function mousePressed(x, y, button, istouch)
	
end
hook.Add("MousePressed", "handle", mousePressed)

local function mouseReleased(x, y, button, istouch)
	isDown = false
end
hook.Add("MouseReleased", "handle", mouseReleased)

