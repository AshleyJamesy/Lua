backgroundFile = "background.png"
shaderFile = "material.fsh"
background = nil

function loadShader()
   shader = love.graphics.newShader(shaderFile)
   print(shader:getWarnings())
end

function love.load(args)
   background = love.graphics.newImage(backgroundFile)
   love.window.setMode(background:getWidth(), background:getHeight(), { fullscreen = false })
   loadShader()
end


function love.draw()
   love.graphics.setShader(shader)
   --strength = math.sin(love.timer.getTime()*2)
   strength = 0.05
   shader:send("abberationVector", {strength * 0.05, strength * 0.05})
   love.graphics.draw(background)
   love.graphics.setShader()
end
