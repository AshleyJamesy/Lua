include("class")
include("ui/UIObject")

local Class, BaseClass = class.NewClass("UILabel", "UIObject")
UILabel = Class
UILabel.defaultFont = love.graphics.getFont()
UILabel.newFont 	= love.graphics.newFont(GetProjectDirectory() .. "resources/fonts/Roboto-Regular.ttf", 40)

function Class:New(x,y,text)
	BaseClass.New(self,x,y,0,0)
	self.text 		= text
	self.font 		= UILabel.newFont
	self.size 		= Vector2(0.4, 0.4)
	self.align 		= Vector2(0.5,0.5)
end

function Class:SetText(text)
	self.text = text
end

function Class:SetFont(font)
	self.font = font
end

function Class:Draw(x,y)
	local fw = self.font:getWidth(self.text)
	local fh = self.font:getHeight()
	love.graphics.setFont(self.font)
	
	--local xp = x + (self.align.x * self.parent.rect.w) - (fw * 0.5 * self.size.x)
	--local yp = y + (self.align.y * self.parent.rect.h) - (fh * 0.5 * self.size.y)
	local xp = x
	local yp = y
	
	love.graphics.print(self.text, xp, yp, 0, self.size.x, self.size.y)
end

function Class:Paint(x,y)
	self:Draw(x,y)
	BaseClass.Paint(self,x,y)
end