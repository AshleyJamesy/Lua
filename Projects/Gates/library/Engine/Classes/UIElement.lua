local Class = class.NewClass("UIElement")

function Class:New(x, y, w, h)
	self.position 	= Vector2(x, y)
	self.size 		= Vector2(w, h)

	self.enable 	= true
	self.visible 	= true
	self.draggable 	= false

	self.children = {}
end

function Class:OnMousePress(button, x, y)
	for k, v in pairs(self.children) do
		v:OnMousePress(button, x, y)
	end
end

function Class:OnMouseDown(button, x, y)
	for k, v in pairs(self.children) do
		v:OnMouseDown(button, x, y)
	end
end

function Class:OnMouseRelease(button, x, y)
	for k, v in pairs(self.children) do
		v:OnMouseRelease(button, x, y)
	end
end

function Class:Paint(x, y, w, h)
	
end

function Class:Render(x, y)
	self:Paint(self.x, self.y, self.w, self.h)
	
	for k, v in pairs(self.children) do
		v:Render()
	end
end