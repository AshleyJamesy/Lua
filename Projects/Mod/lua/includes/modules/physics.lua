module("physics", package.seeall)

local world 	= love.physics.newWorld(0.0, 0.0, true)
local channel 	= love.thread.newChannel()
local thread 	= love.thread.newThread([[
		world, channel = ...
		require("love.event")
		require("love.physics")
		
		function callback_StartTouch(a, b, c)
			love.event.push("StartTouch", a, b, c)
		end
		
		function callback_EndTouch(a, b, c)
			love.event.push("EndTouch", a, b, c)
		end
		
		world:setCallbacks(callback_StartTouch, callback_EndTouch, nil, nil)
		
		while true do
			local dt = channel:demand()
			world:update(dt)
			
			channel:supply(true)
		end
]])

function Init()
	if not thread:isRunning() then
		thread:start(world, channel)
	end
end

function Update(dt)
	channel:supply(dt)
end

local objects = {}
function AddPhysicsBody(x, y, type)
	local id = #objects + 1

	objects[id] = love.physics.newBody(world, x, y, type)
	
	return objects[id]
end

function WaitForPhysicsUpdate()
	channel:demand()
end

function love.handlers.StartTouch(a, b, contact)
	
end

function love.handlers.EndTouch(a, b, contact)
	
end