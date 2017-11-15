-- filenames
backgroundFile = "gfx/background.jpg"
skymapFile = "gfx/skymap.jpg"

addlayerFile = "gfx/add-layer.png"
mullayerFile = "gfx/mul-layer.png"
toplayerFile = "gfx/top-layer.png"
geometryFile = "gfx/geo-layer.png"
blendFile = "gfx/blend-layer.png"

shaderFile = "material.fsh"

-- image objects
background = nil
skymap = nil

addlayer = nil
mullayer = nil
toplayer = nil
blendlayer = nil
geometry = nil

canvas = nil
shader = nil

function loadImages()
   background = love.graphics.newImage(backgroundFile)
   skymap = love.graphics.newImage(skymapFile)
   blendlayer = love.graphics.newImage(blendFile)
   --addlayer = love.graphics.newImage(addlayerFile)
   --mullayer = love.graphics.newImage(mullayerFile)
   --toplayer = love.graphics.newImage(toplayerFile)
   geometry = love.graphics.newImage(geometryFile)
end

function loadShader()
   shader = love.graphics.newShader(shaderFile)
   print(shader:getWarnings())

   shader:send("geometryMap", geometry)
   shader:send("geometrySize", {geometry:getWidth(), geometry:getHeight()})
   shader:send("reflectionStrength", 200)
   shader:send("backgroundSize", {canvas:getWidth(), canvas:getHeight()})
   shader:send("skymap", skymap)
end

function love.load(args)
   --love.graphics.setDefaultFilter("nearest","nearest")
   major, minor, revision, codename = love.getVersion()
   if not (major == 0 and minor == 9 and revision == 1) then
      print("Warning: needs love 0.9.1!")
   end
   loadImages()
   love.window.setMode(background:getWidth(), background:getHeight(), {fullscreen = false})
   canvas = love.graphics.newCanvas(background:getWidth(), background:getHeight())
   loadShader()
   love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

mouseX, mouseY = nil, nil
function love.update(dt)
   mouseX, mouseY = love.mouse.getPosition()
   
end

function love.draw()
   love.graphics.setCanvas(canvas)
   love.graphics.draw(background)
   love.graphics.setCanvas()
   love.graphics.draw(canvas)

   love.graphics.setShader(shader)
   shader:send("geometryOffset", {mouseX/canvas:getWidth(), mouseY/canvas:getHeight()})
   love.graphics.draw(geometry, mouseX, mouseY)
   love.graphics.setShader()
end

function love.keypressed(key)
   if key == "r" then
      loadImages()
      loadShader()
   end
   if key == "escape" then
      love.event.push("quit")
   end
end
