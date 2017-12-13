include("class")
include("math/Vector2")
include("ui/UIObject")

local Class, BaseClass = class.NewClass("UIFrame", "UIObject")
UIFrame = Class

function Class:New(x,y,w,h)
	BaseClass.New(self,x,y,w,h)
	self.scroll = Vector2(0,0)
end

function Class:Draw(x,y)
	love.graphics.rectangle("fill", x, y, self.rect.w, self.rect.h)
end

function Class:Paint(x,y)
	self:Draw(x,y)

	local sx, sy, sw, sh = love.graphics.getScissor()
	love.graphics.setScissor(x, y, self.rect.w, self.rect.h)
	
	BaseClass.Paint(self, x - self.scroll.x, y - self.scroll.y)

	love.graphics.setScissor(sx,sy,sw,sh)
end