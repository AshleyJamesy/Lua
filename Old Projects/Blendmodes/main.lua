
x, y, w, h, alpha, white = 0, 0, 1, 1, 128, false

function createRectImage(w, h, r, g, b, a)
  local data = love.image.newImageData(w, h)
  data:mapPixel(function() return r, g, b, a end)
  return love.graphics.newImage(data)
end

pal = {
  {    0,  0,  0 },
  {    0,  0, 85 },
  {    0,  0,170 },
  {    0,  0,255 },
  {    0, 85,  0 },
  {    0, 85, 85 },
  {    0, 85,170 },
  {    0, 85,255 },
  {    0,170,  0 },
  {    0,170, 85 },
  {    0,170,170 },
  {    0,170,255 },
  {    0,255,  0 },
  {    0,255, 85 },
  {    0,255,170 },
  {    0,255,255 },
  {   85,  0,  0 },
  {   85,  0, 85 },
  {   85,  0,170 },
  {   85,  0,255 },
  {   85, 85,  0 },
  {   85, 85, 85 },
  {   85, 85,170 },
  {   85, 85,255 },
  {   85,170,  0 },
  {   85,170, 85 },
  {   85,170,170 },
  {   85,170,255 },
  {   85,255,  0 },
  {   85,255, 85 },
  {   85,255,170 },
  {   85,255,255 },
  {  170,  0,  0 },
  {  170,  0, 85 },
  {  170,  0,170 },
  {  170,  0,255 },
  {  170, 85,  0 },
  {  170, 85, 85 },
  {  170, 85,170 },
  {  170, 85,255 },
  {  170,170,  0 },
  {  170,170, 85 },
  {  170,170,170 },
  {  170,170,255 },
  {  170,255,  0 },
  {  170,255, 85 },
  {  170,255,170 },
  {  170,255,255 },
  {  255,  0,  0 },
  {  255,  0, 85 },
  {  255,  0,170 },
  {  255,  0,255 },
  {  255, 85,  0 },
  {  255, 85, 85 },
  {  255, 85,170 },
  {  255, 85,255 },
  {  255,170,  0 },
  {  255,170, 85 },
  {  255,170,170 },
  {  255,170,255 },
  {  255,255,  0 },
  {  255,255, 85 },
  {  255,255,170 },
  {  255,255,255 },
}

images = {}
for i = 1, 64 do
  local c = pal[i]
  images[i] = createRectImage(32, 32, c[1], c[2], c[3], 255)
end

blendmode = 1
blendmodes = {
  "alpha", "add", "subtract", "multiply"
}

function love.draw()
  love.graphics.setBlendMode( blendmodes[blendmode] )
  love.graphics.setColor( 255, 255, 255, math.floor(alpha) )
  if white then
    love.graphics.setBackgroundColor(255, 255, 255)
  else
    love.graphics.setBackgroundColor(0, 0, 0)
  end
  love.graphics.clear()
  for i = 1, #images do
    love.graphics.draw(images[i], 16+((i-1)%8)*64, 16+math.floor((i-1)/8)*64, 0, w, h, 0, 0, x, y)
  end
  love.graphics.setBlendMode("alpha")
  if white then 
    love.graphics.setColor( 0, 0, 0, 255 )
  else
    love.graphics.setColor( 255, 255, 255, 255 )
  end
  love.graphics.print(
    ("%.1f %.1f %.1f %.1f %i %s %s"):format(x, y, w, h, alpha, white and "white" or "black",
    blendmodes[blendmode]), 2, 2)
end

function love.update(dt)
  if love.keyboard.isDown("pagedown") then y = y - dt
  elseif love.keyboard.isDown("pageup") then y = y + dt end
  if love.keyboard.isDown("home") then x = x - dt
  elseif love.keyboard.isDown("end") then x = x + dt end
  if love.keyboard.isDown("up") then h = h - dt
  elseif love.keyboard.isDown("down") then h = h + dt end
  if love.keyboard.isDown("left") then w = w - dt
  elseif love.keyboard.isDown("right") then w = w + dt end
  if love.keyboard.isDown("a") then alpha = math.max(alpha - (128*dt), 0)
  elseif love.keyboard.isDown("z") then alpha = math.min(alpha + (128*dt), 255) end
end

function love.keypressed(k)
  if k == "space" then
    if love.keyboard.isDown("lshift", "rshift") then
      blendmode = blendmode - 1
      if blendmode <= 0 then blendmode = #blendmodes end
    else
      blendmode = blendmode + 1
      if blendmode > #blendmodes then blendmode = 1 end
    end
  elseif k == "w" then
    white = not white
  end
end

