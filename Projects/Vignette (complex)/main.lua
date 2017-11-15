backgroundFile = "background.png"
shaderFile = "material.fsh"
background = nil
shader = nil
canvas = nil

function loadShader()
   local source = love.filesystem.read(shaderFile)
   shader = love.graphics.newShader(source)
   print(shader:getWarnings())
end

function love.load(args)
   background = love.graphics.newImage(backgroundFile)
   love.window.setMode(background:getWidth(), background:getHeight(), {fullscreen = false})
   canvas = love.graphics.newCanvas()
   loadShader()
end


function love.draw()
   love.graphics.setCanvas(canvas)
   shader:send("distortionFactor", 0.05)
   shader:send("vignetteEndpoints", {.75 + 0.003*math.sin(love.timer.getTime()*100), .4 + 0.002*math.sin(love.timer.getTime()*80)})
   love.graphics.draw(background,
			 -300 + 300*math.sin(love.timer.getTime()/2),
			 -200 + 200*math.cos(love.timer.getTime()/2),
		      0, 1.5, 1.5)
   love.graphics.setCanvas()
   love.graphics.setShader(shader)
   love.graphics.draw(canvas)
   love.graphics.setShader()
end

function love.keypressed(key, isrepeat)
   if key == "a" then
      desaturationShader = maxShader
   end
   if key == "s" then
      desaturationShader = minShader
   end
   if key == "d" then
      desaturationShader = lightnessShader
   end
   if key == "f" then
      desaturationShader = meanShader
   end
   if key == "g" then
      desaturationShader = luminosityShader
   end
end
