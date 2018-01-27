local Class = class.NewClass("Font")
Class.Fonts = {
    default = setmetatable({
        font = graphics.getFont(),
        size = 12,
        ascent = graphics.getFont():getAscent(),
        descent = graphics.getFont():getDescent(),
        baseline = graphics.getFont():getBaseline(),
        height = graphics.getFont():getHeight()
    }, Class)
}

Class.Stack = {
    Class.Fonts.default
}

function Class:New(path, size)
    if Class.Fonts[path] then
        return Class.Fonts[path]
    end
    
    local status, font = pcall(graphics.newFont, GetProjectDirectory() .. path, size or 12)
    if not status then
        print("unable to load font: ", GetProjectDirectory() .. path, font)
        
        font = Font("default").font
    end
    
    self.font = font
    
    self.size       = size or 12
    self.ascent     = font:getAscent()
    self.descent    = font:getDescent()
    self.baseline   = font:getBaseline()
    self.height     = font:getHeight()
    
    Class.Fonts[path] = self
end

function Class:Push()
    graphics.setFont(self.font)
    
    table.insert(Class.Stack, 1, self)
end

function Class:Pop()
    if #Class.Stack > 1 then
        table.remove(Class.Stack, 1)
        
        graphics.setFont(Class.Stack[1].font)
    end
end