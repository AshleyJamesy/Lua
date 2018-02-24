local Class = class.NewClass("GUI")
Class.Skins = {}

local function OnResize(gui, w, h)
	gui.canvas = love.graphics.newCanvas(w, h)
end

function Class:New(x, y, w, h, ...)
	self.Index 			= 0
	self.Position 		= Vector2(x, y)
	self.Size 			= Vector2(w, h)
	self.Width 			= 0.0
	self.Height 		= 0.0
	
	self.MouseDown 		= false
	self.Active 		= nil
	self.Hovered 		= nil
	self.LastHovered 	= nil
	
	self.Options = 
	{
		width 			= 0.0,
		width_min 		= 0.0,
		width_max 		= math.huge,
		width_expand 	= false,

		height 			= 0.0,
		height_min 		= 0.0,
		height_max 		= math.huge,
		height_expand 	= false,
		
		padding = 
		{
			width 	= 0.0,
			height 	= 0.0
		},
		font 	= love.graphics.newFont(love.window.getPixelScale() * 12.0),
		align 	= "center",
		style 	= nil,
		skin 	= GUISkin.Default
	}

	self.background = Colour(100, 100, 100, 255)

	self.canvas = love.graphics.newCanvas(Screen.width, Screen.height)
	
	hook.Add("WindowResize", self, OnResize)

	if self.Init then
		self.Init(self, ...)
	end

	if Class.Active == nil then
		Class.Active = self
	end
end

function Class:ResetOptions()
	local gui = Class.Active
	local options = gui.Options
	gui.Index = gui.Index + 1
	
	options.id 				= gui.Index	
	options.width 			= 0.0
	options.width_min 		= 0.0
	options.width_max 		= math.huge
	options.width_expand 	= false
	
	options.height 			= 0.0
	options.height_min 		= 0.0
	options.height_max 		= math.huge
	options.height_expand 	= false
	
	options.padding.width 	= 0.0
	options.padding.height 	= 0.0
	
	options.align 			= "center"

	options.style 			= nil
	options.skin 			= GUISkin.Default
end

function Class:GetOptions(default_style, ...)
	local gui = Class.Active
	gui:ResetOptions()
	
	local options 	= gui.Options
	options.x 		= gui.Width
	options.y 		= gui.Height
	
	if default_style then
		default_style:Use(options)
	end
	
	for k, v in pairs({ ... }) do
		v(options)
	end
	
	if options.style then
		options.style:Use(options)
	end
	
	options.width = 
		options.width_expand and 
		math.clamp(gui.Size.x, options.width_min, options.width_max) or 
		math.clamp(options.width, options.width_min, options.width_max)
	
	options.height = 
		options.height_expand and 
		math.clamp(gui.Size.y, options.height_min, options.height_max) or 
		math.clamp(options.height, options.height_min, options.height_max)

	gui.Height = 
		gui.Height + options.height + options.padding.height
	
	return options.id, gui.Position.x + options.x, gui.Position.y + options.y, options.width, options.height, options
end

function Class:RegisterMouseHit(id, x, y, w, h)
	local gui = Class.Active
	local mx, my = Screen.Point(love.mouse.getPosition())
	if math.inrange(mx, x, x + w) and math.inrange(my, y, y + h) then
		gui.Hovered = id
		if gui.Active == nil and gui.MouseDown then
			gui.Active = id
			return true
		end
	end

	return false
end

function Class:RegisterDraw(draw_func, x, y, w, h, options, ...)
	local gui = Class.Active
	local parameters = { ... }
	gui.canvas:renderTo(function()
		local position 	= gui.Position
		local size 		= gui.Size
		love.graphics.setScissor(position.x, position.y, size.x, size.y)
		
		draw_func(x, y, w, h, options, unpack(parameters))
	end)
end

function Class:Element(id, options)
	local gui = Class.Active
	return {
		id 		= id,
		onPress = options.state or false,
		onDown  = id == gui.Active and id == gui.Hovered and gui.MouseDown,
		onClick = id == gui.Active and id == gui.Hovered and not gui.MouseDown,
		onHover = id == gui.Hovered,
		onEnter = id == gui.Hovered and id ~= gui.LastHovered,
		onExit 	= id ~= gui.Hovered and id == gui.LastHovered
	}
end

function Class:Update()
	Class.Active = self
	self:OnGUI()
end

function Class:OnGUI()

end

function Class:Render()
	if not self.MouseDown then
		self.Active = nil
	elseif self.Active == nil then
		self.Active = -1
	end
	
	self.LastHovered, self.Hovered = self.Hovered, nil
	self.Width 			= 0.0
	self.Height 		= 0.0
	self.Index 			= 0
	self.MouseDown 		= love.mouse.isDown(1)
end

function Class.AddSkin(name, skin)
	GUI.Skins[name] = skin
end

function Class.GetSkin(name)
	return GUI.Skins[name]
end

function Class:Show()
	love.graphics.reset()
	Screen.Draw(self.canvas, 0.0, 0.0, 0.0)

	self.canvas:renderTo(function()
		love.graphics.clear()
		love.graphics.setColor(self.background:GetTable())
		love.graphics.rectangle("fill", self.Position.x, self.Position.y, self.Size.x, self.Size.y)
	end)
end