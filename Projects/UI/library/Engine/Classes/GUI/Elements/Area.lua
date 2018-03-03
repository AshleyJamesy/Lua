local style = GUIStyle()
style:Set(GUIOption.Width(100))
style:Set(GUIOption.Height(100))

local skin = GUISkin()
skin.background = Colour(80, 80, 80, 255)
GUI.AddSkin("Area", skin)

local function draw(x, y, w, h, options)
	love.graphics.setColor(skin.background:GetTable())
	love.graphics.rectangle("fill", x, y, w, h)
end

function GUI:BeginArea(ax, ay, w, h, ...)
	local id, x, y, w, h, options = self:GetOptions(style, GUIOption.Width(w), GUIOption.Height(h), ...)

	x = ax == nil and x or ax
	y = ay == nil and y or ay
	
	GUI:Push(x, y, w, h)
	
	self:RegisterMouseHit(id, x, y, w, h)
	
	GUI:NextFocus(id)
	
	self:RegisterDraw(draw, x, y, w, h, options)
end

function GUI:EndArea()
	GUI:Pop()
end