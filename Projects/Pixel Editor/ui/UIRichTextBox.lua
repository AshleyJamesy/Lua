include("class")
include("ui/UIObject")

local Class, BaseClass = class.NewClass("UIRichTextBox", "UIObject")
UIRichTextBox = Class

function Class:New(x,y,w,h)
	BaseClass.New(self,x,y,w,h)
	self.scroll  = Vector2(0,0)
	self.count   = 0
	self.height  = 10
	self.padding = 2

	--self.label  = UILabel(self.rect.x, self.rect.y, "")
	--self.label:SetColour(255,255,255,255)
	--self:AddObject(self.label)
end

function Class:Label()
	return self.label
end

function Class:AddToList(name)
	local button = UIButton(self.padding, self.padding + (self.count * self.height) + (self.count * self.padding), self.rect.w - self.padding * 4, self.height * 2)
	button:SetColour(25,25,25,255)
	button:Label():SetText(name)
	self:AddObject(button)
	self.count = self.count + 1
end

function Class:GetBottom()
	return self.padding + (self.count * self.height) + (self.count * self.padding)
end

function Class:Draw(x,y)
	love.graphics.rectangle("fill", x, y, self.rect.w, self.rect.h)
end

function Class:Paint(x,y)
	self:Draw(x,y)

	local sx, sy, sw, sh = love.graphics.getScissor()
	love.graphics.setScissor(x, y, self.rect.w, self.rect.h)
	
	--BaseClass.Paint(self, x - self.scroll.x, y - self.scroll.y)

	for k,v in pairs(self.children) do
		love.graphics.setColor(v.colour.r, v.colour.g, v.colour.b, v.colour.a)
		v:Paint(x + v.rect.x, y + v.rect.y)
	end

	love.graphics.setScissor(sx,sy,sw,sh)
end