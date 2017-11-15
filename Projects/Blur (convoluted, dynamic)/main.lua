--backgroundFile = "slightly-ubuntu-saturated.png"
backgroundFile = "Cappadocia_Balloon_Inflating_Wikimedia_Commons.JPG"
--backgroundFile = "vertical-test.JPG"
--backgroundFile = "horizontal-test.JPG"
--backgroundFile = "background.png"
background = nil
horizontalShader = nil
verticalShader = nil
canvas = nil
blurActivated = true

function gaussianSquared(x, size)
   local radius = size/2
   local sigma = radius
   local value = (1/(sigma*math.sqrt(2*math.pi)))
      * math.exp((-x*x)/(2*sigma*sigma))
   return value*value
end

function generateHorizontalCoordinateOffsets(number)
   local substitutionString = ""
   -- vBlurOffsets[ 6] = VertexTexCoord.xy + prescaler*vec2(-1, 0.0)/love_ScreenSize.x;
   local index = 0
   for i = 0,number,1 do
      if i ~= number/2 then
	 -- note that this expression uses both "i" and "index"
	 substitutionString = substitutionString .. "vBlurOffsets[" .. tostring(index) .. "] = VertexTexCoord.xy + prescaler*vec2(" .. tostring(i - number/2) .. ", 0.0)/love_ScreenSize.x;\n"
	 index = index+1
      end
   end
   return substitutionString
end
function generateVerticalCoordinateOffsets(number)
   local substitutionString = ""
   -- vBlurOffsets[ 0] = VertexTexCoord.xy + prescaler*vec2(0.0, -7)/love_ScreenSize.y;
   local index = 0
   for i = 0,number,1 do
      if i ~= number/2 then
	 -- note that this expression uses both "i" and "index"
	 substitutionString = substitutionString .. "vBlurOffsets[" .. tostring(index) .. "] = VertexTexCoord.xy + prescaler*vec2(0.0, " .. tostring(i - number/2) .. ")/love_ScreenSize.y;\n"
	 index = index+1
      end
   end
   return substitutionString
end

function normalize(weights)
   local sum = 0
   for i,v in ipairs(weights) do
      sum = sum + v
   end
   for i,v in ipairs(weights) do
      weights[i] = v*(1/sum)
   end
end

function generateBlurWeights(number)
   local weights = {}
   for i = 1, number+1 do
      weights[i] = gaussianSquared((i-1) - number/2, number)
   end
   normalize(weights)
   local sum = 0
   for i,v in ipairs(weights) do
      sum = sum + v
   end
   print("sum: " .. tostring(sum) .. " (should be 1)")
   
   local substitutionString = ""
   -- pixelColor += Texel(currentTexture, vBlurOffsets[13])*0.0044299121055113265;
   local index = 0
   local inserted = false
   local stepsize = 1
   for i = 0,number,1 do
      if index+1 > number/2 and not inserted then
	 substitutionString = substitutionString .. "pixelColor += Texel(currentTexture, texCoords       )*".. tostring(weights[number/2]) ..";\n"
	 inserted = true
      else
	 -- note that this expression uses both "i" and "index"
	 substitutionString = substitutionString .. "pixelColor += Texel(currentTexture, vBlurOffsets[" .. tostring(index) .."])*" .. tostring(weights[i+1]) .. ";\n"
	 index = index+1
      end
   end
   return substitutionString
end

function loadShader()
   local blurSamples = 16 -- has to be even, 30 is max on nvidia hardware, 16 on ES2.0 hardware.
   local horizontalVertexSource = love.filesystem.read("material-horizontal.vsh")
   horizontalVertexSource = horizontalVertexSource:gsub("${{POPULATE_BLUR_OFFSETS}}", generateHorizontalCoordinateOffsets(blurSamples))
   horizontalVertexSource = horizontalVertexSource:gsub("${{NUM_BLUR_SAMPLES}}", blurSamples)
   
   local verticalVertexSource = love.filesystem.read("material-vertical.vsh")
   verticalVertexSource = verticalVertexSource:gsub("${{POPULATE_BLUR_OFFSETS}}", generateVerticalCoordinateOffsets(blurSamples))
   verticalVertexSource = verticalVertexSource:gsub("${{NUM_BLUR_SAMPLES}}", blurSamples)
   
   print(horizontalVertexSource)
   print(verticalVertexSource)
   
   local fragmentSource = love.filesystem.read("material.fsh")
   fragmentSource = fragmentSource:gsub("${{GENERATE_BLUR_WEIGHTINGS}}", generateBlurWeights(blurSamples))
   fragmentSource = fragmentSource:gsub("${{NUM_BLUR_SAMPLES}}", blurSamples)
   print(fragmentSource)
   
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
   local prescalerCoefficient = 1 - math.sin(love.timer.getTime())*math.sin(love.timer.getTime())
   -- how much the prescaler can be stretched before it starts looking bad depends on the kernel size.
   -- with kernel size 8x8, 1.5 seems to be fairly artefact-free
   -- with kernel size 30x30, 3.5 seems to be fairly artefact-free
   horizontalShader:send("prescaler", prescalerCoefficient*2.5)
   verticalShader:send("prescaler", prescalerCoefficient*2.5)
   
   frame = frame+1
   love.graphics.setCanvas(canvas)
   if blurActivated then
      love.graphics.setShader(horizontalShader)
   end
   love.graphics.draw(background)
   love.graphics.setShader()
   love.graphics.setCanvas()
   if blurActivated then
      love.graphics.setShader(verticalShader)
   end
   love.graphics.draw(canvas)
   love.graphics.setShader()
   if frame % 100 == 0 then
      print("frametime: " .. tostring(1000/love.timer.getFPS()) .. "ms")
   end
end

function love.keypressed(key, isrepeat)
   if key == "a" then
      blurActivated = not blurActivated
   end
end
