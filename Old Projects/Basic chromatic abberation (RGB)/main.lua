backgroundFile = "background.png"
shaderFile = "material.fsh"
background = nil

function loadShader()
   shader = love.graphics.newShader(shaderFile)
   print(shader:getWarnings())
end

function love.load(args)
   background = love.graphics.newImage(backgroundFile)
   love.window.setMode(background:getWidth(), background:getHeight(), {fullscreen = false})
   loadShader()
end


function love.draw()
   love.graphics.setShader(shader)
   strength = math.sin(love.timer.getTime()*2)
   shader:send("abberationVector", {strength*math.sin(love.timer.getTime()*7)/200, strength*math.cos(love.timer.getTime()*7)/200})
   love.graphics.draw(background)
   love.graphics.setShader()
end
