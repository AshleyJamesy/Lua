include("extensions/")
include("util/")
include("classes/class")
include("classes/")

class.Load()

include("systems/")
include("source/")

function CreateWindow()
	local window = ui.Create("Frame")
	window:SetPosition(100,200)
	window:SetSize(200,200)
	window.anchor.x = 0
	window.anchor.y = 0

	local titlebar = ui.Create("Button", window)
	titlebar:SetSize(0, 18)
	titlebar.parentRect.w = 1.0
	titlebar.label.text = "Window"

	titlebar.DoPress = function(self, x, y, button, istouch)
		if button == 1 or istouch then
			self.__offset = Vector2(0,0)
			self.__offset.x = x - self.globalRect.x
			self.__offset.y = y - self.globalRect.y

			local found, k = table.HasValue(window.parent.children, window) 

			if found then
				window.parent.children[k] = nil
				table.insert(window.parent.children, window)
			end
		end
	end

	titlebar.DoDrag = function(self, x, y, istouch)
		window.localRect.x = love.mouse.getX() - self.__offset.x
		window.localRect.y = love.mouse.getY() - self.__offset.y
	end

	local close = ui.Create("Button", titlebar)
	close:SetSize(18, 0)
	close.parentRect.x = 1.0
	close.parentRect.h = 1.0
	close.anchor.x = 1.0
	close.label.text = "x"
	close.label.align = "center"

	close.DoPress = function(self, x, y, button, istouch)
		if button == 1 or istouch then
			window:Destroy()
		end
	end

	return window
end

function love.load()
	local window = CreateWindow()
	local button = ui.Create("Button", window)
	button:SetPosition(20,40)
	button:SetSize(100,100)

	button.DoPress = function(self, x, y, button, istouch)
		if button == 1 or istouch then
			local mywindow = CreateWindow()
		end
	end
end

function love.update(dt)
	Time.delta 		= dt
	Time.elapsed 	= Time.elapsed + dt

	for k, v in pairs(Scene.main.layers) do
		v:CallFunctionOnType("Update", "Transform", nil, dt)
	end

	for k, v in pairs(Scene.main.layers) do
		v:CallFunctionOnAll("Update", { "Transform" }, nil, dt)
	end

	ui.Update()
end

function love.draw()
	for k, v in pairs(Scene.main.layers) do
		v:CallFunctionOnType("Render", "Camera")
	end

	ui.Render()

	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
	love.graphics.print("Delta: " .. string.format("%.5f", Time.delta), 10, 25)
end