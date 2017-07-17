include("class")
include("Time")
include("math/Vector2")

local Class, BaseClass = class.NewClass("Particle")
Particle = Class

function Class:New(batch)
    self.batch        = batch
    self.position     = Vector2()
    self.velocity     = Vector2()
    self.acceleration = Vector2()
    self.size         = Vector2(1,1)
    self.lifespan     = 0.0
    local w, h        = batch:getTexture():getDimensions()
    self.quad         = love.graphics.newQuad(0,0, w, h, w, h)
    batch:setColor(255,255,255,0)
    self.id           = batch:add(self.quad, self.position.x, self.position.y, 0)
end