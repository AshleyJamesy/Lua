local Class = class.NewClass("Light", "Component")
Class.Index 	= 1
Class.MaxLights = 100

Class.Lights = {
	position 	= {},
	colour 		= {},
	distance 	= {},
	intensity 	= {}
}

local Lights = Class.Lights

function Class.NewLightData(index)
	Lights.position[index] 	= { 0, 0, 10.0 }
	Lights.colour[index] 	= { 0, 0, 0, 0 }
	Lights.distance[index] 	= 0.0
	Lights.intensity[index] = 0.0
end

for i = 1, Class.MaxLights do
	Class.NewLightData(i)
end

function Class:New(gameObject)
	Class:Base().New(self, gameObject)

	self.colour 	= Colour(math.random() * 255, math.random() * 255, math.random() * 255, 255)
	self.distance 	= 500.0
	self.intensity 	= 1.0
end

function Class:Render(camera)
	local position = self.transform.globalPosition
	
	self.gameObject:SetBounds(
		position.x - self.distance * 0.5, 
		position.y - self.distance  * 0.5, 
		self.distance, 
		self.distance
	)
	
	if Rect.Intersect(camera.bounds, self.gameObject.__bounds) then
		if Class.Index < Class.MaxLights + 1 then
			local index = Class.Index
			local light_position = Lights.position[index]
			light_position[1] = position.x
			light_position[2] = position.y

			local colour = self.colour
			local light_colour = Lights.colour[index]
			light_colour[1] = colour.r
			light_colour[2] = colour.g
			light_colour[3] = colour.b
			light_colour[4] = colour.a

			Lights.distance[index] 	= self.distance * 0.5
			Lights.intensity[index] = self.intensity

			Class.Index = Class.Index + 1
		end
	end
end

local icon = Image("resources/engine/gizmo_light.png")
function Class:OnDrawGizmos()
	local bounds = self.gameObject.__bounds
	graphics.draw(icon.source, bounds.x + bounds.w * 0.5, bounds.y + bounds.h * 0.5, 0, Screen.aspect, Screen.aspect, icon.width * 0.5, icon.height * 0.5)
end

function Class.SendLights()
	local material = Material("Sprites/Default")

	--material:Set("light_position", "vec3", 		{ 0, 0, 0 } , { 100, 100, 0})
	--material:Set("light_colour", "vec3", 		{ 255, 255, 255 } , { 255, 0, 0})
	--material:Set("light_distance", 	"float", 	500.0, 500.0)
	--material:Set("light_intensity", "float", 	0.001, 0.001)
	
	material.shader:Send("light_position", 		unpack_ext(Class.Lights.position, Class.MaxLights))
	material.shader:SendColour("light_colour", 		unpack_ext(Class.Lights.colour, Class.MaxLights))
	material.shader:Send("light_distance", 	unpack_ext(Class.Lights.distance, Class.MaxLights))
	material.shader:Send("light_intensity", 	unpack_ext(Class.Lights.intensity, Class.MaxLights))

	stats.rendering_lights 	= Class.Index - 1
	stats.lights 			= SceneManager:GetActiveScene():GetCount("Light")
	stats.light 			= Vector2(Lights.position[1][1], Lights.position[1][2])

	Class.Index = 1
end