include("class")
include("composition/MonoBehaviour")
include("Colour")

local Class, BaseClass = class.NewClass("Camera", "MonoBehaviour")
Camera = Class

function Class:Awake()
    self.culling    = {}
    self.background = Colour(0,0,0,255)
    self.size       = Vector2(1,1)
end

function Class:Render()
    love.graphics.push()
    
    local vec = Vector2(0,0)
    vec.x = canvas:getWidth() * self.transform.scale.x * 0.5
    vec.y = canvas:getHeight() * self.transform.scale.y * 0.5
    
    love.graphics.scale(1 / self.transform.scale.x, 1 / self.transform.scale.y)
    love.graphics.translate(vec.x, vec.y)
    love.graphics.rotate(-self.transform.rotation)
    love.graphics.translate(-self.transform.position.x, -self.transform.position.y)
    
    for id, layer in pairs(SceneManager.GetActiveScene().layers)
        if self.culling[id] then
        else
            for k, object in pairs(layer.objects) do
                if object.layer ~= id then
                    --remove object from layer
                    --add object to new layer
                else
                    love.graphics.push()
                    love.graphics.translate(transform.position.x, transform.position.y)
                    love.graphics.push()
                    love.graphics.rotate(transform.rotation)
                    
                    
                    
                    love.graphics.pop()
                    love.graphics.pop()
                end
            end
        end
    end
    
    love.graphics.pop()
end