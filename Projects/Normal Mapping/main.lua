
local function captionf(...)
   love.graphics.setCaption(string.format(...))
end

local function distance (x1, y1, x2, y2)
   return ((x1 - x2)^2 + (y1 - y2)^2)^0.5
end

local sz = 3
local z = 0
local function update_light_vector()
   local x, y = love.mouse.getPosition()
   y = 600 - y -- glsl works from bottom left rather than top left
   x = x/sz
   y = y/sz
   mouse = {x=x, y=600/sz-y}
   effect:send("light_vec", {x, y, 0})
end

function love.load ()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setBackgroundColor(35, 30, 65)

	stump 			= love.graphics.newImage "treestump.png"
	stump_lines 	= love.graphics.newImage "treestump_lines.png"
	stump_diffuse 	= love.graphics.newImage "treestump_diffuse.png"
	globe 			= love.graphics.newImage "globe.png"
	effect 			= love.graphics.newShader "gooch.glsl"
	love.graphics.setShader(effect)
	update_light_vector()

	fb 				= love.graphics.newCanvas(800 / sz, 600 / sz)

	effect:send("diffuse", stump_diffuse)
end

time = 0
function love.update (dt)
   update_light_vector()

   time = time+dt
   --z = z + math.cos(time)/3
end

local r = math.random
function love.draw ()
   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.setCanvas(fb)
   love.graphics.clear(255,0,0,255)
   math.randomseed(2)
   love.graphics.setShader(effect)

   for x = 20, (800-34)/sz, 34 do
      for y = 20, (600-34)/sz, 34 do
         if r() > 0.7 then
            love.graphics.draw(stump, x, y, 0, 1, 1, 16, 16)
            love.graphics.setShader()
            local q = 0.3
            love.graphics.setColor(145*q, 75*q, 39*q)
            love.graphics.draw(stump_lines, x, y, 0, 1, 1, 16, 16)
            love.graphics.setShader(effect)
         end
      end
   end

   love.graphics.setShader()
   love.graphics.setColor(255, 255, 255)
   love.graphics.draw(globe, mouse.x, mouse.y-z, 0, 1, 1, 8, 8)
   love.graphics.setCanvas()
   love.graphics.draw(fb, 0, 0, 0, sz, sz)
end
