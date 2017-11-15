backgroundFile = "background.png"
shaderFile = "material.fsh"
background = nil
shader = nil

function loadShader()
   local source = love.filesystem.read(shaderFile)
   shader = love.graphics.newShader(source)
   print(shader:getWarnings())
end

function love.load(args)
   background = love.graphics.newImage(backgroundFile)
   love.window.setMode(background:getWidth(), background:getHeight(), {fullscreen = false})
   loadShader()
end


function love.draw()
   shader:send("blurRadius", 3*math.pow(math.sin(love.timer.getTime()), 2))
   love.graphics.setShader(shader)
   love.graphics.draw(background)
   love.graphics.setShader()
end
