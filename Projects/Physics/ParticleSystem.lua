include("class")
include("Time")
include("math/Vector2")
include("math/Vector4")

local Class, BaseClass = class.NewClass("ParticleSystem")
ParticleSystem = Class

function Class:New(image, max)
    self.position       = Vector2(Screen.Center)
    self.max            = max or 10
    self.batch          = love.graphics.newSpriteBatch(image, self.max, "stream")
    self.lifespan       = 6.0
    self.ssize          = Vector2(20.0, 5.0) * 2
    self.esize          = Vector2(0.0, 5.0)
    self.sc = Vector4(255, 100, 0, 255)
    self.ec = Vector4(255, 255, 50, 255)
    self.lifetimespeed  = 5.0
    self.particles      = {}
    for i = 1, self.max, 1 do
        self.particles[i] = Particle(self.batch)
    end
end

function Class:Update()
    local dt = Time.deltaTime    
    
    math.randomseed(Time.timeElapsed)
    
    for k, v in pairs(self.particles) do
        v.lifespan = v.lifespan - dt * self.lifetimespeed
        
        if v.lifespan <= 0 then
            v.lifespan = math.random() * self.lifespan
            v.position:Set(self.position)
            v.velocity:Set(math.random() * -300 * 2, math.random() * 100 - 50)
            v.acceleration:Set(math.random() * 10 * 2, 0)
        else
            v.velocity = v.velocity + v.acceleration
            v.position = v.position + v.velocity * dt
        end
        
        --self.batch:setColor(255,255,255,255)
        --self.batch:set(v.id, v.quad, v.position.x, v.position.y, 0, v.size.x, v.size.y)
    end
end

function Class:Draw()
    for k, v in pairs(self.particles) do
        local c = Vector4.Lerp(self.ec, self.sc, v.lifespan / self.lifespan)
        local s = Vector2.Lerp(self.esize, self.ssize, v.lifespan / self.lifespan)
        love.graphics.setColor(c.x, c.y, c.z, c.w)
        love.graphics.circle("fill", v.position.x, v.position.y, s.x)
    end

    --self.batch:flush()
end