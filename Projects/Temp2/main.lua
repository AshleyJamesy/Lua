include("extensions/")
include("util/")
include("classes/class")
include("classes/math/")
include("classes/containers/")
include("classes/Object")
include("classes/Component")
include("classes/Behaviour")
include("classes/MonoBehaviour")
include("classes/")

class.Load()

include("source/")

function love.load()
	--[[
	gameObject = {}
	setmetatable(gameObject, {__mode = "v"})
	gameObject.x = Vector2()

	a = {}
	setmetatable(a, {__mode = "v"})
	a.x = gameObject.x

	print(gameObject.x)

	collectgarbage()

	print(gameObject.x)
	]]

	gameObjectlist = Array{
		test1 = GameObject(),
		test2 = GameObject()
	}

	componentList = {
		test1 = gameObjectlist.test1.transform,
		test2 = gameObjectlist.test2.transform
	}

	gameObjectlist.test1:AddComponent("SpriteRenderer")
	
	--for k, v in pairs(SpriteRenderer) do
	--	print(k, v)
	--end
end

function love.fixedupdate(dt)
	
end

function love.update(dt)
	Timer.Update()
	Transform.Root:Update()
end

function love.draw()
	
end

function love.keypressed(key, scancode, isrepeat)
	
end

function love.mousepressed(x, y, button, istouch)
	
end