local Class = class.NewClass("Material")

function Class:New(d, r)
	self.density 		= d or 0
	self.restitution 	= r or 0
end

Material.materials = {}
Material.materials.rock 	= Material(0.6, 0.1)
Material.materials.wood 	= Material(0.3, 0.2)
Material.materials.metal 	= Material(1.2, 0.05)
Material.materials.rubber 	= Material(0.3, 0.8)
Material.materials.static 	= Material(0.0, 0.4)