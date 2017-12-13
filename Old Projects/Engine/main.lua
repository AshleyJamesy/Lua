include("extensions/")
include("util/")
include("classes/class")
include("classes/")

class.Load()

include("systems/")
include("source/")

function love.load()

end

function love.update(dt)
	Time.delta 		= dt
	Time.elapsed 	= Time.elapsed + dt

	for k, v in pairs(Scene.main.layers) do
		v:CallFunctionOnType("Update", "Transform", nil, dt)
	end

	for k, v in pairs(Scene.main.layers) do
		v:CallFunctionOnAll("Update", { "Transform" }, nil, dt)
	end
end

function love.draw()
	for k, v in pairs(Scene.main.layers) do
		v:CallFunctionOnType("Render", "Camera")
	end

	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
	love.graphics.print("Delta: " .. string.format("%.5f", Time.delta), 10, 25)
end