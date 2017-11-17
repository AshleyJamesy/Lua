local Class = class.NewClass("Scene")

function Class:New()
	Class.main = self

	self.selected 	= nil
	self.objects 	= {}

	hook.Add("MousePressed", self, Class.MousePressed)
	hook.Add("MouseReleased", self, Class.MouseReleased)
	hook.Add("MouseMoved", self, Class.MouseMoved)
end

function Class:Create(x, y)
	local g = GameObject(x, y)
	
	self.objects[g.id] 	= g
	return g
end

local objectdrag = false
local drag = false

function Class:MousePressed(x, y, button, istouch)
	if button == 1 and self.selected == nil then
		local selected = nil
		for k, v in pairs(self.objects) do
			if v ~= Camera.main.gameObject then
				local mx, my = Camera.main:ToWorld(x, y)
				local w = v.__aabb.w * 0.5
				local h = v.__aabb.h * 0.5

				if mx > v.transform.globalPosition.x - w and mx < v.transform.globalPosition.x + w then
					if my > v.transform.globalPosition.y - h and my < v.transform.globalPosition.y + h then
						if v == self.selected then
							selected = v
						else
							selected = v
							break
						end
					end
				end
			end
		end
		
		self.selected = selected
	end

	if button == 2 then
		drag = true
	end
end

function Class:MouseReleased(x, y, button, istouch)
	if button == 2 then
		drag = false
	end
end

function Class:MouseMoved(x, y, dx, dy, istouch)
	if drag then
		Camera.main.transform.position.x = Camera.main.transform.position.x - dx
		Camera.main.transform.position.y = Camera.main.transform.position.y - dy
	end
end

function Class:Render()
	if self.selected then
		self.selected:SendMessage("OnDrawGizmosSelected")
		
		for k, v in pairs(self.selected.components) do
			if v.__editor then
				v.__editor:OnSceneGui(v)
			end
		end
	end
end