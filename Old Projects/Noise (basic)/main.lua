linearShader = nil
simpleShader = nil
triangularShader = nil
current = nil

function loadShader()
   local source = love.filesystem.read("linear-noise.fsh")
   linearShader = love.graphics.newShader(source)
   print(linearShader:getWarnings())
   
   source = love.filesystem.read("nonoise.fsh")
   simpleShader = love.graphics.newShader(source)
   print(simpleShader:getWarnings())

   source = love.filesystem.read("triangular-noise.fsh")
   triangularShader = love.graphics.newShader(source)
   print(triangularShader:getWarnings())

   current = linearShader
end

function love.load(args)
   loadShader()
   love.window.setMode(1800, 400, {fullscreen = false})
   local vertices = {
      {1800, 100, 0,   0},
      {1800,   0, 0,   0},
      {0,      0, .15, 0},
      {0,    100, .15, 0}
   }
   mesh = love.graphics.newMesh(vertices)
end


function love.draw()
   -- remember that if you want to draw to canvases, you need to either
   -- dither each time you draw to a canvas, or use a hdr canvas and dither
   -- once at the end.
   current:send("seed", {math.sin(love.timer.getTime()), math.cos(love.timer.getTime())})
   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.setShader(current)
   love.graphics.draw(mesh)
   love.graphics.setShader(simpleShader)
   love.graphics.draw(mesh, 0, 100)
   love.graphics.setShader()
   
   love.graphics.setColor(0, 255, 0, 255)
   love.graphics.setShader(current)
   love.graphics.draw(mesh, 0, 200)
   love.graphics.setShader(simpleShader)
   love.graphics.draw(mesh, 0, 300)
   love.graphics.setShader()
end
   
function love.keypressed(key, isrepeat)
   if key == "l" then
      current = linearShader
   end
   if key == "t" then
      current = triangularShader
   end
end
