LOVE_POSTSHADER_BLURV 					= love.graphics.newShader("resources/shaders/blurv.glsl")
LOVE_POSTSHADER_BLURH 					= love.graphics.newShader("resources/shaders/blurh.glsl")
LOVE_POSTSHADER_CONTRAST 				= love.graphics.newShader("resources/shaders/contrast.glsl")
LOVE_POSTSHADER_CHROMATIC_ABERRATION 	= love.graphics.newShader("resources/shaders/chromatic_aberration.glsl")
LOVE_POSTSHADER_FOUR_COLOR 				= love.graphics.newShader("resources/shaders/four_colors.glsl")
LOVE_POSTSHADER_MONOCHROM 				= love.graphics.newShader("resources/shaders/monochrom.glsl")
LOVE_POSTSHADER_SCANLINES 				= love.graphics.newShader("resources/shaders/scanlines.glsl")
LOVE_POSTSHADER_TILT_SHIFT 				= love.graphics.newShader("resources/shaders/tilt_shift.glsl")
LOVE_POSTSHADER_GLOW					= love.graphics.newShader("resources/shaders/glow.glsl")
--[[
love.postshader = {}

love.postshader.setBuffer = function(path)
	if path == "back" then
		love.graphics.setCanvas(LOVE_POSTSHADER_BUFFER_BACK)
	else
		love.graphics.setCanvas(LOVE_POSTSHADER_BUFFER_RENDER)
	end
	LOVE_POSTSHADER_LAST_BUFFER = love.graphics.getCanvas()
end

love.postshader.addEffect = function(shader, ...)
	args = {...}
	LOVE_POSTSHADER_LAST_BUFFER = love.graphics.getCanvas()
	
	love.graphics.setCanvas(LOVE_POSTSHADER_BUFFER_BACK)
	love.graphics.setBlendMode("alpha")

	if shader == "bloom" then
		-- Bloom Shader
		LOVE_POSTSHADER_BLURV:send("screen", {love.graphics.getWidth(), love.graphics.getHeight()})
		LOVE_POSTSHADER_BLURH:send("screen", {love.graphics.getWidth(), love.graphics.getHeight()})
		LOVE_POSTSHADER_BLURV:send("steps", args[1] or 2.0)
		LOVE_POSTSHADER_BLURH:send("steps", args[1] or 2.0)

		love.graphics.setShader(LOVE_POSTSHADER_BLURV)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_RENDER)

		love.graphics.setShader(LOVE_POSTSHADER_BLURH)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_BACK)

		love.graphics.setShader(LOVE_POSTSHADER_CONTRAST)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_BACK)

		love.graphics.setCanvas(LOVE_POSTSHADER_LAST_BUFFER)
		love.graphics.setShader()
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_RENDER)
		love.graphics.setBlendMode("additive")
		love.graphics.setColor(255, 255, 255, (args[2] or 0.25) * 255)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_BACK)
		love.graphics.setBlendMode("alpha")
	elseif shader == "blur" then
		-- Blur Shader
		LOVE_POSTSHADER_BLURV:send("screen", {love.graphics.getWidth(), love.graphics.getHeight()})
		LOVE_POSTSHADER_BLURH:send("screen", {love.graphics.getWidth(), love.graphics.getHeight()})
		LOVE_POSTSHADER_BLURV:send("steps", args[1] or 2.0)
		LOVE_POSTSHADER_BLURH:send("steps", args[2] or 2.0)

		love.graphics.setShader(LOVE_POSTSHADER_BLURV)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_RENDER)

		love.graphics.setShader(LOVE_POSTSHADER_BLURH)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_BACK)
	elseif shader == "chromatic" then
		-- Chromatic Shader
		LOVE_POSTSHADER_CHROMATIC_ABERRATION:send("redStrength", {args[1] or 0.0, args[2] or 0.0})
		LOVE_POSTSHADER_CHROMATIC_ABERRATION:send("greenStrength", {args[3] or 0.0, args[4] or 0.0})
		LOVE_POSTSHADER_CHROMATIC_ABERRATION:send("blueStrength", {args[5] or 0.0, args[6] or 0.0})
		love.graphics.setCanvas(LOVE_POSTSHADER_BUFFER_BACK)
		love.graphics.setShader(LOVE_POSTSHADER_CHROMATIC_ABERRATION)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_RENDER)
	elseif shader == "4colors" then
		-- 4 Color Shader
		for i = 1, 4 do
			for k = 1, 3 do
				args[i][k] = args[i][k] / 255.0
			end
		end
		LOVE_POSTSHADER_FOUR_COLOR:send("palette", args[1], args[2], args[3], args[4])
		love.graphics.setShader(LOVE_POSTSHADER_FOUR_COLOR)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_RENDER)
	elseif shader == "monochrom" then
		-- Monochrom Shader
		for i = 1, 3 do
			if args[i] then
				args[i] = args[i] / 255.0
			end
		end
		LOVE_POSTSHADER_MONOCHROM:send("tint", {args[1] or 1.0, args[2] or 1.0, args[3] or 1.0})
		LOVE_POSTSHADER_MONOCHROM:send("fudge", args[4] or 0.1)
		LOVE_POSTSHADER_MONOCHROM:send("time", args[5] or love.timer.getTime())
		love.graphics.setShader(LOVE_POSTSHADER_MONOCHROM)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_RENDER)
	elseif shader == "scanlines" then
		-- Scanlines Shader
		LOVE_POSTSHADER_SCANLINES:send("screen", {love.graphics.getWidth(), love.graphics.getHeight()})
		LOVE_POSTSHADER_SCANLINES:send("strength", args[1] or 2.0)
		LOVE_POSTSHADER_SCANLINES:send("time", args[2] or love.timer.getTime())
		love.graphics.setShader(LOVE_POSTSHADER_SCANLINES)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_RENDER)
	elseif shader == "tiltshift" then
		-- Blur Shader
		LOVE_POSTSHADER_BLURV:send("screen", {love.graphics.getWidth(), love.graphics.getHeight()})
		LOVE_POSTSHADER_BLURH:send("screen", {love.graphics.getWidth(), love.graphics.getHeight()})
		LOVE_POSTSHADER_BLURV:send("steps", args[1] or 2.0)
		LOVE_POSTSHADER_BLURH:send("steps", args[1] or 2.0)

		love.graphics.setShader(LOVE_POSTSHADER_BLURV)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_RENDER)

		love.graphics.setShader(LOVE_POSTSHADER_BLURH)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_BACK)

		LOVE_POSTSHADER_TILT_SHIFT:send("imgBuffer", LOVE_POSTSHADER_BUFFER_RENDER)
		love.graphics.setShader(LOVE_POSTSHADER_TILT_SHIFT)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_BACK)
	end

	if shader ~= "bloom" then
		love.graphics.setBlendMode("alpha")
		love.graphics.setCanvas(LOVE_POSTSHADER_LAST_BUFFER)
		love.graphics.setShader()
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(LOVE_POSTSHADER_BUFFER_BACK)
	end
end

love.postshader.draw = function()
	if LOVE_POSTSHADER_LAST_BUFFER then
		love.graphics.setBackgroundColor(0, 0, 0)
		love.graphics.setBlendMode("alpha")
		love.graphics.setCanvas()
		love.graphics.setShader()
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(LOVE_POSTSHADER_LAST_BUFFER)
	end
end

love.postshader.refreshScreenSize = function()
	LOVE_POSTSHADER_BUFFER_RENDER = love.graphics.newCanvas()
	LOVE_POSTSHADER_BUFFER_BACK = love.graphics.newCanvas()
end
]]