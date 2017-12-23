include("extensions/")
include("util/")
include("classes/class")
include("classes/math/")
include("classes/")

class.Load()

include("source/")

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
toggle = {}

function love.keypressed(key, scancode, isrepeat)
	hook.Call("KeyPressed", key, scancode, isrepeat)

	keyboard[key] = 1
	toggle[key] = not toggle[key]
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
	love.graphics.setColor(255, 0, 0, 255)
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