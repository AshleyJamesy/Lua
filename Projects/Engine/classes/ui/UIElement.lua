local Class = class.NewClass("UIElement")

function Class:old()
	--[[
	function Class:New()
		

		self.anchor			= Vector2(0,0)
		self.position 		= Vector2(0,0)
		self.size 			= Vector2(0,0)
		self.globalPosition	= Vector2(0,0)
		self.globalSize 	= Vector2(0,0)
		self.useParentSize	= Vector2(0,0)
		self.useParentPosition = Vector2(0,0)
		self.visible 		= true
		self.active 	= true
		self.parent 		= nil
		self.__drag 		= false
		self.draggable  	= true
		self.__hover 		= false
		self.__destroy 		= false
		self.children 		= {}

	end

	function Class:SetDraggable(bool)
		self.draggable = bool
	end

	function Class:SetSize(x, y)
		self.size:Set(x, y)
	end

	function Class:SetParent(parent)
		self.parent = parent
		table.insert(parent.children, self)
	end

	function Class:SetPosition(x, y)
		self.position:Set(x, y)
	end

	function Class:GetLocalPosition()
		return self.position
	end

	function Class:GetGlobalPosition()
		return self.globalPosition
	end

	function Class:SetGlobalPosition(x,y)
		self.globalPosition:Set(x,y)
	end

	function Class:SetVisible(bool)
		self.visible = bool
	end

	function Class:GetSize()
		return self.globalSize
	end

	function Class:Destroy()
		for k, v in pairs(self.children) do
			v:Destroy()
		end

		self.__destroy = true
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
	function Class:PreDraw(w, h)
	end
	function Class:Draw(w, h)
	end
	function Class:PostDraw(w, h)
	end

	function Class:Paint()
		if self.visible then
			local colour = Colour(love.graphics.getColor())
			love.graphics.setColor(255,255,255,255)

			local size = Vector2(self.size.x, self.size.y)

			if self.parent then
				local position = self.parent:GetGlobalPosition() + self:GetLocalPosition()
				size.x = self.useParentSize.x > 0 and self.parent.globalSize.x * self.useParentSize.x - self.position.x or self.size.x
				size.y = self.useParentSize.y > 0 and self.parent.globalSize.y * self.useParentSize.y - self.position.y or self.size.y
				
				self:SetGlobalPosition(position)
			end

			self.globalSize:Set(size.x, size.y)

			love.graphics.push()
			love.graphics.translate((self:GetLocalPosition() + self:GetSize() * self.anchor):Unpack())

			self:PreDraw(size.x, size.y)
			self:Draw(size.x, size.y)

			for k, v in pairs(self.children) do
				v:Paint()
			end

			self:PostDraw(size.x, size.y)

			love.graphics.pop()

			love.graphics.setColor(colour:Unpack())
		end
	end

	function Class:OnMouseMoved(x, y, dx, dy, istouch)
		if self.visible then
			if self.draggable then
				if self.__drag then
					self:OnDrag(x, y, istouch)
				end
			end

			local anchorPoint = self:GetSize() * self.anchor
			if Vector2.InRange(Vector2(x, y), self:GetGlobalPosition() + anchorPoint, self:GetGlobalPosition() + self:GetSize() + anchorPoint) then
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

			for k, v in pairs(self.children) do
				v:OnMouseMoved(x, y, dx, dy, istouch)
			end
		end
	end

	function Class:Update()
		if self.__hover then
			local x, y = love.mouse.getPosition()
			self:OnHover(x, y)
		end

		self:OnUpdate()

		for k, v in pairs(self.children) do
			if v.__destroy then
				self.children[k] = nil
			else
				v:Update()
			end
		end
	end

	function Class:OnMousePressed(x, y, button, istouch)
		if self.visible then
			local anchorPoint = self:GetSize() * self.anchor
			if Vector2.InRange(Vector2(x, y), self:GetGlobalPosition() + anchorPoint, self:GetGlobalPosition() + self:GetSize() + anchorPoint) then
				local exit = false
				for k, v in pairs(self.children) do
					exit = v:OnMousePressed(x, y, button, istouch)

					if exit then 
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

		for k, v in pairs(self.children) do
			v:OnMouseReleased(x, y, button, istouch)
		end
	end

	function Class:OnMouseWheel(x, y)
		for k, v in pairs(self.children) do
			v:OnMouseWheel(x, y)
		end
	end

	function Class:OnWindowResize(w, h)
		for k, v in pairs(self.children) do
			v:OnWindowResize(w, h)
		end
	end
	--]]
end

function Class:New()
	self.visible 		= true
	self.active 		= true
	self.draggable  	= true

	self.parent 		= nil
	self.anchor			= Vector2(0,0)
	self.rotation 		= 0
	self.localRect 		= Rect(0,0,0,0)
	self.globalRect 	= Rect(0,0,0,0)
	self.parentRect		= Rect(0,0,0,0)
	self.children 		= {}

	self.__drag 		= false
	self.__hover 		= false
	self.__destroy 		= false
end

function Class:SetPosition(x, y)
	self.localRect.x = x
	self.localRect.y = y
end

function Class:SetSize(w,h)
	self.localRect.w = w
	self.localRect.h = h
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
function Class:Draw(w, h)
end

function Class:OnMouseMoved(x, y, dx, dy, istouch)
	if self.visible and self.active then
		if self.draggable then
			if self.__drag then
				self:OnDrag(x, y, istouch)
			end
		end

		if Vector2.InRange(Vector2(x, y), self.globalRect:Position(), self.globalRect:Position() + self.globalRect:Size()) then
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

		for k = #self.children, 1,-1 do
			local v = self.children[k]
			if v then
				v:OnMouseMoved(x, y, dx, dy, istouch)
			end
		end
	end
end

function Class:OnMousePressed(x, y, button, istouch)
	if self.visible and self.active then
		if Vector2.InRange(Vector2(x, y), self.globalRect:Position(), self.globalRect:Position() + self.globalRect:Size()) then
			local exit = false
			for k = #self.children, 1,-1 do
				local v = self.children[k]
				
				if v then
					exit = v:OnMousePressed(x, y, button, istouch)
				end

				if exit then
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

	for k = #self.children, 1,-1 do
		local exit = false
		local v = self.children[k]
		if v then
			v:OnMouseReleased(x, y, button, istouch)
		end
	end
end

function Class:Destroy()
	self.__destroy = true

	for k, v in pairs(self.children) do
		v:Destroy()
		self.children[k] = nil
	end
end

function Class:Update()
	if self.visible then
		self.globalRect.x = self.localRect.x
		self.globalRect.y = self.localRect.y
		self.globalRect.w = self.localRect.w
		self.globalRect.h = self.localRect.h
		
		if self.parent then
			self.globalRect.w = self.parentRect.w > 0 and self.parent.globalRect.w * self.parentRect.w or self.localRect.w
			self.globalRect.h = self.parentRect.h > 0 and self.parent.globalRect.h * self.parentRect.h or self.localRect.h
			
			self.globalRect.x = self.parentRect.x > 0 and
			self.parent.globalRect.x + (self.parent.globalRect.w * self.parentRect.x) or
			self.parent.globalRect.x + self.localRect.x
			
			self.globalRect.y = self.parentRect.y > 0 and
			self.parent.globalRect.y + (self.parent.globalRect.h * self.parentRect.y) or
			self.parent.globalRect.y + self.localRect.y

			self.globalRect.x = self.globalRect.x -self.globalRect.w * self.anchor.x
			self.globalRect.y = self.globalRect.y -self.globalRect.h * self.anchor.y
		end
		
		self:OnUpdate()
		
		if self.__hover then
			self:OnHover(love.mouse.getPosition())
		end
		
		for k = #self.children, 1,-1 do
			local v = self.children[k]
			if v then
				if v.__destroy then
					self.children[k] = nil
				else
					v:Update()
				end
			end
		end
	end
end

function Class:Paint()
	if self.visible then
		love.graphics.push()

		if self.parent then
			local x = self.parentRect.x > 0 and self.parent.globalRect.w * self.parentRect.x or 0
			local y = self.parentRect.y > 0 and self.parent.globalRect.h * self.parentRect.y or 0

			love.graphics.translate(x, y)
		end

		love.graphics.translate(self.localRect.x, self.localRect.y)
		love.graphics.translate(-self.globalRect.w * self.anchor.x, -self.globalRect.h * self.anchor.y)

		self:Draw(self.globalRect.w, self.globalRect.h)

		for k, v in pairs(self.children) do
			love.graphics.setColor(255,255,255,255)
			v:Paint()
		end
		
		love.graphics.pop()
	end

	love.graphics.setColor(255,255,255,255)
end