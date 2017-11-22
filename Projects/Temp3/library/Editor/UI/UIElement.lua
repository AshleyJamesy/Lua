local Class = class.NewClass("UIElement")

function Class:New(parent)
	self.visible		= true
	self.active			= true
	self.draggable		= true
	
	self:SetParent(parent)

	self.children = {}
	
	self.rects 	= {
		native 	= Rect(0,0,0,0),
		global 	= Rect(0,0,0,0)
	}

	self.anchor = Vector2(0,0)

	self.colours = {
		default = Colour(255,255,255,255)
	}
	self.colour	= self.colours.default
	
	self.__drag			= false
	self.__hover		= false
	self.__destroy 		= false
	self.__destroys 	= {}
end

function Class:SetParent(parent)
	if parent then
		if IsType(parent, "UIElement") then
			parent:AddChild(self)
		end
	end
end

function Class:AddChild(child)
	if child then
		if IsType(child, "UIElement") then
			if table.HasValue(self.children, child) then
			else
				child.root 		= self.root or self
				child.parent 	= self
				
				table.insert(self.children, 1, child)
				
				self:RePaint()
			end
		end
	end
end

function Class:Destroy()
	if not self.__destroy then
		table.insert(self.root.__destroys, 1, self)
	end

	self.__destroy = true
end

function Class:Paint()
	if self.visible then
		love.graphics.push()
		
		self.rects.global.x = self.rects.native.x - (self.rects.native.w * self.anchor.x)
		self.rects.global.y = self.rects.native.y - (self.rects.native.h * self.anchor.y)
		self.rects.global.w = self.rects.native.w
		self.rects.global.h = self.rects.native.h

		if self.parent then
			self.rects.global.x = self.parent.rects.global.x + self.rects.native.x - (self.rects.native.w * self.anchor.x)
			self.rects.global.y = self.parent.rects.global.y + self.rects.native.y - (self.rects.native.h * self.anchor.y)
		end

		self:RenderElement()
		
		for key, element in pairs(self.children) do
			love.graphics.setColor(element.colour.r, element.colour.g, element.colour.b, element.colour.a)
			element.index = key
			element:Paint()
		end
		
		love.graphics.pop()
	end
	
	love.graphics.setColor(255,255,255,255)
end

function Class:RePaint()
	self.root.__paint = true
end

function Class:MousePressed(x, y, button, istouch)
	if self.visible then
		if math.inrange(x, self.rects.global.x, self.rects.global.x + self.rects.global.w) and math.inrange(y, self.rects.global.y, self.rects.global.y + self.rects.global.h) then
			local exit = false
			for key, element in pairs(self.children) do
				if element:MousePressed(x, y, button, istouch) then
					exit = true
					break
				end
			end
			
			if not exit then
				self.__drag = true
				self:OnPress(x, y, button, istouch)
			end

			if self.active then
				return true
			end
		end
	end
end

function Class:TextInput(char)
	if self.active and self.visible then
		for k, v in pairs(self.children) do
			v:OnTextInput(char)
			v:TextInput(char)
		end
	end
end

function Class:KeyPressed(key, scancode, isrepeat)
	if self.active and self.visible then
		for k, v in pairs(self.children) do
			v:OnKeyPress(key, scancode, isrepeat)
			v:KeyPressed(key, scancode, isrepeat)
		end
	end
end

function Class:MouseReleased(x, y, button, istouch)
	if self.__drag then
		self.__drag = false
	end

	self:OnRelease(x, y, button, istouch)

	for key, element in pairs(self.children) do
		element:MouseReleased(x, y, button, istouch)
	end
end

function Class:MouseMoved(x, y, dx, dy, istouch)
	if self.visible then
		if self.draggable then
			if self.__drag then
				self:OnDrag(x, y, istouch)
			end
		end

		if math.inrange(x, self.rects.global.x, self.rects.global.x + self.rects.global.w) and math.inrange(y, self.rects.global.y, self.rects.global.y + self.rects.global.h) then
			if self.__hover == false then
				self:OnHoverEnter(x, y, istouch)
			end

			self.__hover = true
		else
			if self.__hover == true then
				self:OnHoverExit(x, y, istouch)
			end

			self.__hover = false
		end

		for key, element in pairs(self.children) do
			element:MouseMoved(x, y, dx, dy, istouch)
		end
	end
end

function Class:DoDestroy()
	for key, element in pairs(self.__destroys) do
		table.remove(element.parent.children, element.index)
	end
end

function Class:DoHover(x, y)
	if self.__hover then
		self:OnHover(x, y)
		
		for key, element in pairs(self.children) do
			element:DoHover(x, y)
		end
	end
end

function Class:OnPress(x, y, button, istouch)
end
function Class:OnHoverEnter(x, y)
end
function Class:OnTextInput(char)
end
function Class:OnKeyPress(key, scancode, isrepeat)
end
function Class:OnHover(x, y, istouch)
end
function Class:OnHoverExit(x, y, istouch)
end
function Class:OnDrag(x, y, istouch)
end
function Class:OnRelease(x, y, button, istouch)
end
function Class:RenderElement()
end