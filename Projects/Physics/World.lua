include("class")
include("Time")
include("math/Vector2")

local Class, BaseClass = class.NewClass("World")
World = Class

function Class:New()
    self.gravity = Vector2(0, 9.8)
    self.bodies = {}
end

function Class:Add(body)
    if TypeOf(body) == "RigidBody" then
        table.insert(self.bodies, body)
    end
end

function Class:Update()
    --for k, v in pairs(self.bodies) do
    --    v.velocity = v.velocity + self.gravity
    --    v:Update()
    --end
    
    self:CheckCollisions()
end

function Class:CheckCollisions()
    for i = 1, #self.bodies, 1 do
        local bodyA = self.bodies[i]
        for j = i + 1, #self.bodies, 1 do
            local bodyB = self.bodies[j]
            
            local func = TypeOf(bodyA.collider) .. "Vs" .. TypeOf(bodyB.collider)
            if Class[func] then
                Class[func](bodyA, bodyB)
            end
        end
        
        --testing
        bodyA.velocity = bodyA.velocity + self.gravity
        bodyA:Update()
    end
end

function Class.CircleVsCircle(a, b)
    if a.static and b.static then
        return
    end
    
    local length = a.collider.radius + b.collider.radius
    if (a.position - b.position):Magnitude() < length then
        if a.static then
            b.velocity = Vector2()
            return
        end
        if b.static then
            a.velocity = Vector2()
            return
        end
        
        --Calculate impulse and direction
        a.velocity = Vector2()
    end
end

function Class.CircleVsAABB(a, b)

end

function Class.AABBVsCircle(a, b)
    Class.CircleVsAABB(b, a)
end

function Class.AABBVsAABB(a, b)
    
end

function Class:Draw()
    for k, v in pairs(self.bodies) do
        v:Draw()
    end
end




