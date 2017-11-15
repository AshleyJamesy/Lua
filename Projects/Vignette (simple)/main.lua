backgroundFile = "background.png"
shaderFile = "material.fsh"
background = nil
desaturationShader = nil

function loadShader()
   local source = love.filesystem.read(shaderFile)
   function loadSubstitutePrint(substitution)
      local substitutedSource = source:gsub("${{DESATURATION_METHOD}}", substitution)
      local shader = love.graphics.newShader(substitutedSource)
      print(shader:getWarnings())
      return shader
   end

   maxShader = loadSubstitutePrint("desaturateMax")
   minShader = loadSubstitutePrint("desaturateMin")
   lightnessShader = loadSubstitutePrint("desaturateLightness")
   meanShader = loadSubstitutePrint("desaturateMean")
   luminosityShader = loadSubstitutePrint("desaturateLuminosity")
   desaturationShader = luminosityShader -- default
end

function love.load(args)
   background = love.graphics.newImage(backgroundFile)
   love.window.setMode(background:getWidth(), background:getHeight(), {fullscreen = false})
   loadShader()
end


function love.draw()
   love.graphics.setShader(desaturationShader)
   love.graphics.draw(background)
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
