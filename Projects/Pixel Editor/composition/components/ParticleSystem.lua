include("class")
include("Time")
include("math/Vector2")
include("math/Vector4")

local Class, BaseClass = class.NewClass("ParticleSystem", "MonoBehaviour")
ParticleSystem = Class

function Class:Awake(image, max)
    self.max            = max or 5
    --self.batch          = love.graphics.newSpriteBatch(image, self.max, "stream")
    self.lifespan       = 15.0
    self.ssize          = Vector2(4.0, 4.0)
    self.esize          = Vector2(2.0, 2.0)
    self.sc             = Vector4(255, 255, 255, 255)
    self.ec             = Vector4(255, 255, 255, 0)
    self.lifetimespeed  = 5.0
    self.particles      = {}
    self.offset         = Vector2(25,-3)

    for i = 1, self.max, 1 do
        self.particles[i] = Particle()
    end
end

function Class:Update()
    local dt = Time.delta

    for k, v in pairs(self.particles) do
        v.lifespan = v.lifespan - dt * self.lifetimespeed
        
        if v.lifespan <= 0 then
            v.lifespan = math.random() * self.lifespan
            v.position:Set(self.transform.position.x + self.offset.x, self.transform.position.y + self.offset.y)
            v.velocity:Set(0,0)
            v.acceleration:Set(0, -math.random() + -1)
        else
            v.velocity = v.velocity + v.acceleration
            v.position = v.position + v.velocity * dt
        end
        
        --self.batch:setColor(255,255,255,255)
        --self.batch:set(v.id, v.quad, v.position.x, v.position.y, 0, v.size.x, v.size.y)
    end
end

function Class:Render()
    love.graphics.pop()

    for k, v in pairs(self.particles) do
        local c = Vector4.Lerp(self.ec, self.sc, v.lifespan / self.lifespan)
        local s = Vector2.Lerp(self.esize, self.ssize, v.lifespan / self.lifespan)
        love.graphics.setColor(c.x, c.y, c.z, c.w)
        love.graphics.circle("line", v.position.x, v.position.y, s.x)
    end

    love.graphics.push()

    --self.batch:flush()
end