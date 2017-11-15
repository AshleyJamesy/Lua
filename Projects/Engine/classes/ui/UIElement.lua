local Class = class.NewClass("UIElement")

function Class:New()
	self.visible		= true
	self.active			= true
	self.draggable		= true

	self.parent			= nil
	self.children		= {}

	self.anchor			= Vector2(0,0)
	self.border			= Vector2(0,0)
	self.padding		= Vector2(0,0)

	self.colours		= {
		default = Colour(255,255,255,255)
	}
	self.colour	= self.colours.default

	self.rects = 
	{
		native 	= Rect(0,0,0,0),
		global 	= Rect(0,0,0,0),
		border 	= Rect(0,0,0,0),
		padding = Rect(0,0,0,0),
	}
	self.rotation = 0	

	self.__drag			= false
	self.__hover		= false
end

function Class.Create(name, parent)
	local class = class.GetClass(name)

	if class then
		if class:IsType("UIElement") then
			local instance = class()

			if parent then
				if IsType(parent, "UIElement") then
					parent:AddChild(instance)
				end
			end

			return instance
		end
	end

	return nil
end

function Class:SetVisible(bool)
	self.visible = bool
end

function Class:SetActive(bool)
	self.active = bool
end

function Class:SetDraggable(bool)
	self.draggable = bool
end

function Class:SetParent(parent)
	if IsType(parent, "UIElement") then
		self.parent = parent
		self.parent:AddChild(self)
	end
end

function Class:AddChild(child)
	if IsType(child, "UIElement") then
		if table.HasValue(self.children, child) then
		else
			child.parent = self

			table.insert(self.children, 1, child)
		end
	end
end

function Class:SetAnchor(x, y)
	self.anchor:Set(x, y)
end


function Class:SetBorder(w, h)
	self.border:Set(w, h)
end
function Class:SetPadding(w, h)
	self.padding:Set(w, h)
end

function Class:SetPosition(x, y)
	self.rects.native.x = x
	self.rects.native.y = y
end

function Class:SetSize(w, h)
	self.rects.native.w = w
	self.rects.native.h = h
end

function Class:OnPress(x, y, button, istouch)
end
function Class:OnHoverEnter(x, y)
end
function Class:OnHover(x, y, istouch)
end
function Class:OnHoverExit(x, y, istouch)
end
function Class:OnDrag(x, y, istouch)
end
function Class:OnRelease(x, y, button, istouch)
end
function Class:OnUpdate()
end
function Class:Draw(x, y, w, h)
end

function Class:OnMouseMoved(x, y, dx, dy, istouch)
	if self.visible then
		local mouse = Vector2(x, y)

		if self.draggable then
			if self.__drag then
				self:OnDrag(x, y, istouch)
			end
		end

		if Vector2.InRange(mouse, self.rects.global:Position(), self.rects.global:Position() + self.rects.global:Size()) then
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
			element:OnMouseMoved(x, y, dx, dy, istouch)
		end
	end
end

function Class:OnMousePressed(x, y, button, istouch)
	if self.visible then
		local mouse = Vector2(x, y)

		if Vector2.InRange(mouse, self.rects.global:Position(), self.rects.global:Position() + self.rects.global:Size()) then
			local exit = false
			for key, element in pairs(self.children) do
				if element:OnMousePressed(x, y, button, istouch) then
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

function Class:OnMouseReleased(x, y, button, istouch)
	self.__drag = false
	self:OnRelease(x, y, button, istouch)

	for key, element in pairs(self.children) do
		element:OnMouseReleased(x, y, button, istouch)
	end
end

function Class:Update()
	if self.visible then
		self.rects.global.x = self.rects.native.x
		self.rects.global.y = self.rects.native.y
		self.rects.global.w = self.rects.native.w
		self.rects.global.h = self.rects.native.h

		if self.parent then
			self.rects.global.x = self.parent.rects.padding.x + self.rects.native.x
			self.rects.global.y = self.parent.rects.padding.y + self.rects.native.y
		end

		self.rects.border.x = self.rects.global.x + self.border.x
		self.rects.border.y = self.rects.global.y + self.border.y
		self.rects.border.w = self.rects.global.w - self.border.x * 2
		self.rects.border.h = self.rects.global.h - self.border.y * 2

		self.rects.padding.x = self.rects.border.x + self.padding.x
		self.rects.padding.y = self.rects.border.y + self.padding.y
		self.rects.padding.w = self.rects.border.w - self.padding.x * 2
		self.rects.padding.h = self.rects.border.h - self.padding.y * 2

		self:OnUpdate()
		
		for key, element in pairs(self.children) do
			element:Update()
		end
	end
end

function Class:Paint()
	if self.visible then
		love.graphics.push()
		love.graphics.rotate(self.rotation)

		self:Draw(self.rects.global.x, self.rects.global.y, self.rects.global.w, self.rects.global.h)

		for key, element in pairs(self.children) do
			love.graphics.setColor(element.colour:Unpack())
			element:Paint()
		end

		love.graphics.pop()
	end

	love.graphics.setColor(255,255,255,255)
end

function love.resize(w, h)
	hook.Call("OnWindowResize", w, h)
end

function love.textinput(char)
	hook.Call("OnTextInput", char)
end

function love.mousemoved(x, y, dx, dy, istouch)
	hook.Call("OnMouseMoved", x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
	hook.Call("OnMouseWheel", x, y)
end

function love.mousepressed(x, y, button, istouch)
	hook.Call("OnMousePressed", x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
	hook.Call("OnMouseReleased", x, y, button, istouch)
end