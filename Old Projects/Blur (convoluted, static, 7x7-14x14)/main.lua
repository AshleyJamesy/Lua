--backgroundFile = "slightly-ubuntu-saturated.png"
backgroundFile = "Cappadocia_Balloon_Inflating_Wikimedia_Commons.JPG"
--backgroundFile = "vertical-test.JPG"
--backgroundFile = "horizontal-test.JPG"
--backgroundFile = "background.png"
background = nil
horizontalShader = nil
verticalShader = nil
canvas = nil

function loadShader()
   local horizontalVertexSource = love.filesystem.read("material-horizontal.vsh")
   local verticalVertexSource = love.filesystem.read("material-vertical.vsh")
   local fragmentSource = love.filesystem.read("material.fsh")
   horizontalShader = love.graphics.newShader(horizontalVertexSource, fragmentSource)
   verticalShader = love.graphics.newShader(verticalVertexSource, fragmentSource)
   print(horizontalShader:getWarnings())
   print(verticalShader:getWarnings())
end

function love.load(args)
   background = love.graphics.newImage(backgroundFile)
   love.window.setMode(background:getWidth(), background:getHeight(), {fullscreen = false, vsync=false})
   loadShader()
   canvas = love.graphics.newCanvas()
end

frame = 0
function love.draw()
   frame = frame+1
   local prescalerCoefficient = 1 - math.sin(love.timer.getTime())*math.sin(love.timer.getTime())
   -- how much the prescaler can be stretched before it starts looking bad depends on the kernel size.
   -- with kernel size 8x8, 1.5 seems to be fairly artefact-free
   -- with kernel size 30x30, 3.5 seems to be fairly artefact-free
   horizontalShader:send("prescaler", prescalerCoefficient*2.0)
   verticalShader:send("prescaler", prescalerCoefficient*2.0)
   
   love.graphics.setCanvas(canvas)
   love.graphics.setShader(horizontalShader)
   love.graphics.draw(background)
   love.graphics.setShader()
   love.graphics.setCanvas()
   love.graphics.setShader(verticalShader)
   love.graphics.draw(canvas)
   love.graphics.setShader()
   if frame % 100 == 0 then
      print(1000/love.timer.getFPS())
   end
end
