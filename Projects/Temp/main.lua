include("extensions/")
include("util/")
include("classes/class")
include("classes/math/")
include("classes/")

class.Load()

include("source/")

function love.load()
	triangle 	= { 0.0, -0.55, 0.5, 0.45, -0.5, 0.45 }
	square 		= { -0.5, -0.5, 0.5, -0.5, 0.5, 0.5,-0.5, 0.5 }
	
	spartial = SpartialHash()

	mouse = Polygon(triangle)
	mouse.scale = 50.0

	spartial:Insert(mouse)

	local time = os.clock()

	local a = Vector2(0,0)
	for i = 1, 100000 do
		a = a * Vector2(1,1)
	end

	print(os.clock() - time .. "ms")
	print(a)
end

switch = false

function love.update(dt)
	mouse.x = love.mouse.getX()
	mouse.y = love.mouse.getY()

	if love.mouse.isDown(1) then
		local object = Polygon(triangle)
		object.x = love.mouse.getX()
		object.y = love.mouse.getY()
		object.scale = math.random() * 50
		object.group = math.floor(math.random() * 3)
		spartial:Insert(object)
	end
	
	if switch then
		spartial:Clear()
		
		for k, v in pairs(spartial.list) do
			spartial:Insert(v, v:GetAABB())
		end
		
		for bucket_key, bucket in pairs(spartial.hash) do
			for i = 1, #bucket do
				for j = i, #bucket do
					local objectA = bucket[i]
					local objectB = bucket[j]

					if objectA ~= objectB and objectA.group ~= objectB.group then
						local result, mx, my = Polygon.Overlapping(objectA, objectB)
						if result then
							objectA.x = objectA.x - mx * 0.5
							objectA.y = objectA.y - my * 0.5
							objectB.x = objectB.x + mx * 0.5
							objectB.y = objectB.y + my * 0.5
						end
					end
				end
			end
		end
	else
		for i = 1, #spartial.list do
			for j = i, #spartial.list do
				local objectA = spartial.list[i]
				local objectB = spartial.list[j]

				if objectA ~= objectB and objectA.group ~= objectB.group then
					local result, mx, my = Polygon.Overlapping(objectA, objectB)
					if result then
						objectA.x = objectA.x - mx * 0.5
						objectA.y = objectA.y - my * 0.5
						objectB.x = objectB.x + mx * 0.5
						objectB.y = objectB.y + my * 0.5
					end
				end
			end
		end
	end
end

function love.fixedupdate(dt)
	--[[
	for bucket_key, bucket in pairs(spartial.hash) do

		for i = 1, #bucket do
			for j = i, #bucket do
				local objectA = bucket[i]
				local objectB = bucket[j]

				if objectA ~= objectB then
					local result, mx, my = Collision.Overlapping(objectA, objectB)
					if result then
						objectA.x = objectA.x - mx * 0.5
						objectA.y = objectA.y - my * 0.5
						objectB.x = objectB.x + mx * 0.5
						objectB.y = objectB.y + my * 0.5
					end
				end
			end
		end
	end
	]]
end

function love.draw()
	spartial:Draw()

	for k, v in pairs(spartial.list) do
		v:Draw(false)
	end

	love.graphics.print("FPS: ".. tostring(love.timer.getFPS()), 10, 10)
	love.graphics.print("Count:" .. tostring(#spartial.list), 10, 25)
end

function love.keypressed(key, scancode, isrepeat)
	if key == "up" 		then spartial.power = spartial.power + 1 end
	if key == "down" 	then spartial.power = spartial.power - 1 end

	if key == "d" then
		switch = not switch
	end
end

function love.mousepressed(x, y, button, istouch)
	if button == 2 then
		local object = Collision(triangle)
		object.x = love.mouse.getX()
		object.y = love.mouse.getY()
		object.scale = math.random() * 50
		object.group = math.floor(math.random() * 3)
		spartial:Insert(object)
	end
end

--[[
myShader = love.graphics.newShader("resources/shaders/myshader.glsl")

function love.load()
	image = love.graphics.newImage("resources/led3.png")
	image:setFilter("nearest", "nearest")

	image2 = love.graphics.newImage("resources/led_glow3.png")
	image2:setFilter("nearest", "nearest")
end

time = 0
function love.update(dt)
	hook.Call("Update", dt)
	time = time + dt
end

love.graphics.canvases 			= {}
love.graphics.canvases.blur 	= love.graphics.newCanvas()
love.graphics.canvases.colour 	= love.graphics.newCanvas()
love.graphics.canvases.emission = love.graphics.newCanvas()
love.graphics.canvases.bloom 	= love.graphics.newCanvas()
love.graphics.canvases.post 	= love.graphics.newCanvas()
love.graphics.canvases.glow 	= love.graphics.newCanvas()

keyboard = {}

function love.keypressed(key, scancode, isrepeat)
	hook.Call("KeyPressed", key, scancode, isrepeat)

	keyboard[key] = 1
end

function love.keyreleased(key, scancode)
	hook.Call("KeyReleased", key, scancode)

	keyboard[key] = 0
end

function love.draw()
	love.graphics.setCanvas()
	love.graphics.clear()
	love.graphics.setShader()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255,255,255,255)
	
	--COLOUR
	love.graphics.setCanvas(love.graphics.canvases.colour)
	love.graphics.clear()
	love.graphics.setShader()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255, 255, 255, 255)
	--draw normal stuff here
	love.graphics.draw(image, 50, 50, 0, 1, 1)
	
	love.graphics.setCanvas(love.graphics.canvases.emission)
	love.graphics.clear()
	love.graphics.setShader(LOVE_POSTSHADER_CONTRAST)
	love.graphics.setBlendMode("screen")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(image2, 50, 50, 0, 1, 1)
	
	--BLOOM
	love.graphics.setCanvas(love.graphics.canvases.bloom)
	love.graphics.clear()
	love.graphics.setShader()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(love.graphics.canvases.emission)
	blur(4, 4)
	
	--GLOW
	love.graphics.setCanvas(love.graphics.canvases.glow)
	love.graphics.clear()
	love.graphics.setShader()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(image2, 50, 50, 0, 1, 1)

	--POST PROCESSING
	love.graphics.setCanvas(love.graphics.canvases.post)
	love.graphics.clear()
	love.graphics.setShader()
	love.graphics.setBlendMode("alpha")

	if toggle["j"] then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(love.graphics.canvases.colour)
	end
	if toggle["k"] then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setBlendMode("screen")
		love.graphics.draw(love.graphics.canvases.emission)
	end
	if toggle["l"] then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setBlendMode("screen")
		love.graphics.draw(love.graphics.canvases.bloom)
	end
	if toggle["g"] then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setBlendMode("screen")
		love.graphics.draw(love.graphics.canvases.glow)
	end

	--RENDERING IT ALL
	love.graphics.setCanvas()
	love.graphics.setShader()
	love.graphics.setBlendMode("alpha")

	love.graphics.draw(love.graphics.canvases.post)
end

function blur(x, y)
	local target 			= love.graphics.getCanvas()
	local shader 			= love.graphics.getShader()
	local mode, alphamode 	= love.graphics.getBlendMode()
	local r,g,b,a 			= love.graphics.getColor()

	love.graphics.setCanvas(love.graphics.canvases.blur)
	love.graphics.clear()
	love.graphics.setShader()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255,255,255,255)

	LOVE_POSTSHADER_BLURV:send("screen", {love.graphics.getWidth(), love.graphics.getHeight()})
	LOVE_POSTSHADER_BLURV:send("steps", x and x > 0 and x or 1.0)
	love.graphics.setShader(LOVE_POSTSHADER_BLURV)
	love.graphics.draw(target)

	love.graphics.setCanvas(target)
	LOVE_POSTSHADER_BLURH:send("screen", {love.graphics.getWidth(), love.graphics.getHeight()})
	LOVE_POSTSHADER_BLURH:send("steps", y and y > 0 and y or 1.0)
	love.graphics.setShader(LOVE_POSTSHADER_BLURH)

	love.graphics.draw(love.graphics.canvases.blur)

	love.graphics.setCanvas(target)
	love.graphics.setShader(shader)
	love.graphics.setBlendMode(mode, alphamode)
	love.graphics.setColor(r,g,b,a)
end
]]