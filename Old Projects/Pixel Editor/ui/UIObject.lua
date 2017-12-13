include("class")
include("math/Vector2")
include("math/Rect")
include("Colour")

local Class, BaseClass = class.NewClass("UIObject")
UIObject = Class

function Class:New(x,y,w,h)
	self.parent		= nil
	self.children	= {}
	self.rect 		= Rect(x,y,w,h)
	self.center 	= Vector2(0,0)
	self.offset 	= Vector2(0,0)
	self.colour		= Colour(255)
end

function Class:SetColour(r,g,b,a)
	self.colour = Colour(r,g,b,a)
end

function Class:SetCenter(x,y)
	self.offset.x = x or self.offset.x
	self.offset.y = y or self.offset.y
end

function Class:AddObject(uiobject)
	table.insert(self.children, uiobject)
	uiobject.parent = self
end

function Class:Draw(x,y)
	
end

function Class:Paint(x,y)
	for k,v in pairs(self.children) do
		love.graphics.setColor(v.colour.r, v.colour.g, v.colour.b, v.colour.a)
		v:Paint(x + v.rect.x, y + v.rect.y)
	end
end

function Class:Render()
	local r, g, b, a = love.graphics.getColor()
	
	love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b, self.colour.a)
	self:Paint(self.rect.x, self.rect.y)
	
	love.graphics.setColor(r,g,b,a)
end