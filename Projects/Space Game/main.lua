include("extensions/")
include("util/")
include("classes/class")
include("classes/math/")
include("classes/")

class.Load()

include("source/")

--[[
--metatable to check if value is changed or added in table

local meta = 
{
	__newindex = function(t, key, new)
		if not rawget(t, "variables") then
			rawset(t, "variables", {})
		end

		local value = t.variables[key]
		if value then
			if value ~= new then
				t.variables[key] = new

				if t.ChangedValue then
					t.ChangedValue(t.variables, key, value, new)
				end
			end
		else
			t.variables[key] = new

			if t.NewValue then
				t.NewValue(t.variables, key, new)
			end
		end
	end,

	__index = function(t, key)
		return t.variables[key]
	end
}

local vars = setmetatable({}, meta)

function vars:NewValue(key, value)
	print("new value", key, value)
end

function vars:ChangedValue(key, value, new)
	print("value changed", key, value, new)
end

vars.x = 10
vars.y = 10
vars.x = 1
]]

function love.load()
	sprite = Sprite("resources/gfx/gui_icons.bmp")
	sprite:Save()

	for i = 1, 1000 do
		go2 = GameObject()
		go2:AddComponent("SpriteRenderer")
		go2:GetComponent("SpriteRenderer").sprite = sprite
		go2:GetComponent("SpriteRenderer").colour:Set(math.random() * 255, math.random() * 255, math.random() * 255, 255)
		go2.position:Set(math.random() * 500 - 250, math.random() * 500 - 250)
	end

	cam = GameObject()
	cam:AddComponent("Camera")
	cam:GetComponent("Camera").target = Canvas()

	cam2 = GameObject()
	cam2:AddComponent("Camera")
	cam2:GetComponent("Camera").target = Canvas()
end

function love.mousepressed(x, y, button, istouch)
	hook.Call("MousePressed", x, y, button, istouch)
end

function love.mousemoved(x, y, dx, dy, istouch)
	hook.Call("MouseMoved", x, y, dx, dy, istouch)
end

function love.keypressed(key, scancode, isrepeat)
	hook.Call("KeyPressed", key, scancode, isrepeat)
end

function love.update(dt)
	hook.Call("Update", dt)
end

function love.draw()
	hook.Call("Camera.Render")

	cam:GetComponent("Camera").target:Render()
end