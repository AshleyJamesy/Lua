include("class")

local Class, BaseClass = class.NewClass("Scene")
Scene = Class

function Class:New(name)
	self.name			= name
	self.components 	= {}
end

function Class:AddComponent(component)
	if component then
		if component:IsType("Component") then
			local batch = component:Type()
			
			if not self.components[batch] then
				self.components[batch] = {}
			end
			
			table.insert(self.components[batch], component)
		end
	end
end