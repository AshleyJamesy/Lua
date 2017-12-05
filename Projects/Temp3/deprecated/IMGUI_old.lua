local Class = class.NewClass("IMGUI")
Class.Windows 	= {}
Class.Stack 	= {}
Class.Styles 	= {
	Fonts 	= {},
	Colour 	= {}
}

Class.Colour = Colour(255,255,255)

Class.MousePressed = {}

Class.Next = {
	x 				= 0,
	y 				= 0,
	w 				= 0,
	h 				= 0,
	indent 			= 1,
	indent_spacing 	= 5,
	spacing 		= 2,
	height 			= 2,
	sameline 		= false
}

local function GetCurrent(stack)
	return stack[1]
end

local function Push(stack, value)
	table.insert(stack, 1, value == nil and {} or value)
end

local function Pop(stack)
	table.remove(stack, 1)
end

local function hook_MousePressed(x, y, button, istouch)
	IMGUI.MousePressed[button] = true
end
hook.Add("MousePressed", "imguiMousePressed", hook_MousePressed)

local function MousePressed(button)
	return IMGUI.MousePressed[button] or false
end

--Styles
function Class:PushFont(font)
	Push(self.Styles.Fonts, font)
end

function Class:PopFont()
	Pop(self.Styles.Fonts)
end

function Class:Spacing(space)
	local current = GetCurrent(self.Stack)
	
	if space == nil then
		current.height = current.height + current.spacing
	else
		current.height = current.height + math.clamp(space, 0, math.huge)
	end
end

function Class:SameLine(bool)
	local current = GetCurrent(self.Stack)

	current.sameline = bool or true
end

--Window
function Class:Begin(name)
	name = name or "Default"

	if self.Windows[name] then
		Push(self.Stack, self.Windows[name])
	else
		Push(self.Stack)
		self.Windows[name] = GetCurrent(self.Stack)

		for k, v in pairs(self.Next) do
			self.Windows[name][k] = v
		end
	end

	local window = GetCurrent(self.Stack)

	love.graphics.setColor(35, 35, 35, 255)
	love.graphics.rectangle("fill", window.x, window.y, window.w, window.h)
	love.graphics.intersectScissor(window.x, window.y, window.w, window.h)
end

function Class:End()
	local current = GetCurrent(self.Stack)
	current.indent 			= 1
	current.indent_spacing 	= 5
	current.spacing 		= 2
	current.height 			= 2
	current.sameline 		= false

	Pop(self.Stack)
end

function Class:SetNextWindowPosition(x, y)
	self.Next.x = x or 0
	self.Next.y = y or 0
end

function Class:SetNextWindowPositionCentered(center)
	self.Next.center = center or true
end

function Class:SetNextWindowSize(w, h)
	self.Next.w = w or 0
	self.Next.h = h or 0
end

function Class:SetWindowCollapsed(collapse)
	self.Next.collapse = collapse
end

function Class:SetNextWindowFocused()
	self.Next.focus = true
end

function Class:SetWindowPosition(x, y)
	local current = GetCurrent(self.Stack)
	current.x = x or 0
	current.y = y or 0
end

function Class:SetWindowSize(w, h)
	local current = GetCurrent(self.Stack)
	current.w = w or 0
	current.h = h or 0
end

function Class:SetWindowCollapsed(collapse)
	local current = GetCurrent(self.Stack)
	current.collapse = collapse
end

function Class:SetWindowFocus()
	local current = GetCurrent(self.Stack)
	current.focus = true
end

function Class:GetWindowPosition()
	local current = GetCurrent(self.Stack)
	return current.x, current.y
end

local function GetPositions(current)
	local x = current.indent * current.indent_spacing + current.x
	local y = current.height + current.y

	if current.sameline then
		y = current.y + current.height
	end

	return x, y
end

--Button
function Class:Button(label, w, h, bool)
	local current = GetCurrent(self.Stack)
	local nx, ny = GetPositions(current)

	if bool == nil then
		if love.mouse.isDown(1) then
			local x, y = love.mouse.getPosition()
			if math.inrange(x, nx, nx + w) and math.inrange(y, ny, ny + h) then
				self.Colour:Set(50,50,50,255)
			else
				self.Colour:Set(20,20,20,255)
			end
		else
			self.Colour:Set(20,20,20,255)
		end
	else
		if bool then self.Colour:Set(50,50,50,255) else self.Colour:Set(20,20,20,255) end
	end

	love.graphics.setColor(self.Colour.r, self.Colour.g, self.Colour.b, self.Colour.a)
	love.graphics.rectangle("fill", nx, ny, w, h)

	self.Colour:Set(255,255,255,255)
	love.graphics.setColor(self.Colour.r, self.Colour.g, self.Colour.b, self.Colour.a)
	love.graphics.printf(label, nx, ny + love.graphics.getFont():getBaseline() * 0.666, w, "center")

	if bool == nil then
		if love.mouse.isDown(1) then
			local x, y = love.mouse.getPosition()
			if math.inrange(x, nx, nx + w) and math.inrange(y, ny, ny + h) then
				current.height = current.height + current.spacing + h
				return true
			end
		end
	else
		if MousePressed(1) then
			local x, y = love.mouse.getPosition()
			if math.inrange(x, nx, nx + w) and math.inrange(y, ny, ny + h) then
				current.height = current.height + current.spacing + h

				return bool == nil and true or not bool
			end
		end
	end

	self:Spacing(current.spacing + h)
	self:SameLine(false)

	return bool or false
end

function Class:Slider(label, value, min, max)
	local current = GetCurrent(self.Stack)
	local nx, ny = GetPositions(current)

	self.Colour:Set(20,20,20,255)
	love.graphics.setColor(self.Colour.r, self.Colour.g, self.Colour.b, self.Colour.a)
	love.graphics.rectangle("fill", nx, ny, 100, 10, 5, 5)

	self.Colour:Set(50,50,50,255)
	love.graphics.setColor(self.Colour.r, self.Colour.g, self.Colour.b, self.Colour.a)
	love.graphics.rectangle("fill", nx, ny, (value / max) * 100, 10, 5, 5)

	self.Colour:Set(80,80,80,255)
	love.graphics.setColor(self.Colour.r, self.Colour.g, self.Colour.b, self.Colour.a)
	love.graphics.circle("fill", nx + math.clamp((value / max) * 100, 5, 95), ny + 5, 5)

	if love.mouse.isDown(1) then
		local x, y = love.mouse.getPosition()
		if math.inrange(x, nx, nx + 100) and math.inrange(y, ny, ny + 10) then
			return (x - nx) / 100 * 1000
		end
	end

	return value
end

--Reset everything
function Class:Render()
	for k, v in pairs(Class.MousePressed) do
		Class.MousePressed[k] = nil
	end

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setScissor()
end