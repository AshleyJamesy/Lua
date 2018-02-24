local Class = class.NewClass("GUIWindow", "GUI")

function Class:Init(x, y, w, h, name)
	self.title 	= name or "Window"
	self.offset = Vector2(0, 0)

	self.Position:Set(x, y)
	self.Size:Set(w, h)
end

function Class:Update()
	GUI.Active = self
	
	local title_bar = GUI:Button(" " .. self.title, GUIOption.ExpandWidth(true), GUIOption.Height(25), GUIOption.Align("left"))
	if title_bar.onPress then
		local mx, my = Screen.Point(love.mouse.getPosition())
		self.offset:Set(self.Position.x - mx, self.Position.y - my)
	end
	
	if title_bar.onDown then
		local mx, my = Screen.Point(love.mouse.getPosition())
		self.Position:Set(mx + self.offset.x, my + self.offset.y)
	end
	
	self:Space(2)
	self:OnGUI()
end

function Class:OnGUI()
	
end