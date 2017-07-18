include("class")
include("ui/UIObject")
include("ui/UILabel")

local Class, BaseClass = class.NewClass("UIButton", "UIObject")
UIButton = Class

function Class:New(x,y,w,h)
	BaseClass.New(self,x,y,w,h)
	self.rect.w = w
	self.rect.h = h
	self.label  = UILabel(self.rect.x, self.rect.y, "Button")
	self.label:SetColour(255,255,255,255)
	self:AddObject(self.label)
	self.fill = true
end

function Class:Label()
	return self.label
end

function Class:Draw(x,y)
	love.graphics.rectangle(self.fill and "fill" or "line", x + self.rect.x, y + self.rect.y, self.rect.w, self.rect.h)
end

function Class:Paint(x, y)
	self:Draw(x,y)
	BaseClass.Paint(self,x,y)
end