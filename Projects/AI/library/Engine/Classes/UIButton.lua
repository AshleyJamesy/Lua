local Class = class.NewClass("UIButton")

local capture = false

function Class:New(w, h)
    self.state = "Up"
    self.label = "Button"
    
    self.position = Vector2(0.0, 0.0)
    self.anchor   = Vector2(0.0, 0.0)
    self.stretch  = Vector2(0.0, 0.0)
    self.min      = Vector2(w or 0.0, h or 0.0)
    self.max      = Vector2(math.huge, math.huge)
    
    self.rect = {
        x = 0.0,
        y = 0.0,
        w = 0.0,
        h = 0.0
    }
    
    self.colours            = {}
    self.colours.background = Colour(100, 100, 100, 255)
    self.colours.text       = Colour(0, 0, 0, 255)
    
    self.image = nil
end

function Class:CalculateRect()
    local rect = self.rect
    rect.w = 
        math.clamp(self.stretch.x * love.graphics.getWidth(), self.min.x, self.max.x)
    rect.h = 
        math.clamp(self.stretch.y * love.graphics.getHeight(), self.min.y, self.max.y)
    
    rect.x = self.position.x - rect.w * self.anchor.x
    rect.y = self.position.y - rect.h * self.anchor.y
end

function Class:Update()
    if self.state == "Released" then
        self.state == "Up"
    end
    
    if self.state == "Down" and not love.mouse.isDown(1) then
        self.state == "Released"
        
        for k, v in pairs(self.onClick) do
            v(self)
        end
    end
    
    if self.state == "Pressed" then
        self.state = "Down"
    end
    
    if self.state == "Up" and love.mouse.isDown(1) and capture == nil then
        self.state = "Pressed"
        capture    = self
    end
    
end

function Class:RenderUI()
    local rect = self.rect
    
    love.graphics.setColour(self.colours.background:GetTable())
    love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h)
    love.graphics.setColour(self.colours.text:GetTable())
    
end