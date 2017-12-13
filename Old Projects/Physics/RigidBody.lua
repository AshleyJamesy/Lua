include("class")
include("Time")
include("math/Vector2")
include("Circle")

local Class, BaseClass = class.NewClass("RigidBody")
RigidBody = Class

function Class:New(x, y)
    self.static   = false
    self.position = Vector2(x, y)
    self.velocity = Vector2(0, 0)
    self.collider = nil
end

function Class:AddCollider(collider)
    table.insert(self.colliders, collider)
end

function Class:Update()
    if not self.static then
        self.position = self.position + self.velocity * Time.deltaTime
    end
end

function Class:Draw()
    love.graphics.points(self.position.x, self.position.y)
    
    if self.collider then
        self.collider:Draw(self.position.x, self.position.y)
    end
end