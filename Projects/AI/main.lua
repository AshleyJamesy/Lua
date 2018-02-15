BIT 	= require("bit")
FFI 	= require("ffi")
ENET 	= require("enet")

include("extensions/")
include("util/")
include("callbacks")
include("library/class")
include("library/containers/")
include("library/math/")
include("library/")
include("source/")

class.Load()

local function OnEnterCollision(a, b)
	local aud = a:getUserData()
	local bud = b:getUserData()

	if aud then aud:OnEnterCollision(b) end
	if bud then bud:OnEnterCollision(a) end
end

local function OnExitCollision(a, b)
	local aud = a:getUserData()
	local bud = b:getUserData()

	if aud then aud:OnExitCollision(b) end
	if bud then bud:OnExitCollision(a) end
end

local function sigmoid(value)
	return 1 / (1 + math.exp(-value))
end

hook.Add("love.load", "game", function(parameters)
	world = love.physics.newWorld()
	world:setCallbacks(OnEnterCollision, OnExitCollision, nil, nil)

	map = Map()
	map:Load("maps/test_map.map")

	love.math.setRandomSeed(os.time())

	agents = {}

	for i = 1, 50 do
		table.insert(agents, 1, Agent(-300, 200))
	end
end)

timer = 0.0
hook.Add("love.update", "game", function()
	world:update(Time.Delta)

	for k, v in pairs(agents) do
		v:Update()
	end

	timer = timer - Time.Delta

	if love.mouse.isDown(1) and timer <= 0.0 then
		map:Add(love.mouse.getX() - love.graphics.getWidth() * 0.5, love.mouse.getY() - love.graphics.getHeight() * 0.5)
		timer = 0.02
	end
end)

hook.Add("love.render", "game", function()
	love.graphics.push()
	love.graphics.translate(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)

	map:Render()
	
	for k, v in pairs(agents) do
		v:Render()
	end

	love.graphics.pop()
end)

hook.Add("KeyPressed", "game", function(key)
	if key == "r" then
		hook.Call("love.load")
	end

	if key == "s" then
		map:Save("maps/test_map.map")
	end

	if key == "space" then
		for k, v in pairs(agents) do
			v.active = true
		end
	end

	if key == "escape" then
		love.event.quit()
	end
end)