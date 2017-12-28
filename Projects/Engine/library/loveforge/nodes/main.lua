local Class = class.NewClass("loveforge.nodes.main", "loveforge.node")

function Class:New(...)
	Class:Base().New(...)
	
	self:SetInput("diffuse", 	{ 0.0, 0.0, 0.0, 0.0 })
	self:SetInput("emission", 	{ 0.0, 0.0, 0.0, 0.0 })
	self:SetInput("normal", 	{ 0.0, 0.0, 0.0, 0.0 })
	self:SetInput("refraction", { 0.0, 0.0, 0.0, 0.0 })
end

function Class:Compile()
	local code = [[
		extern Image cubemap;
		extern Image refraction_image;

		vec4 diffuse;
		vec4 emission;
		vec4 normal;
		vec4 refraction;
		vec4 frag_Colour;

		vec4 effect(vec4 colour, Image texture, vec2 uv_coords, vec2 screen_coords)
		{
			vec4 refraction = Texel(refraction_image, uv_coords.xy);
			float x = screen_coords.x - (screen_coords.x * (refraction.x - 0.5) * 2.0 * 1.0)
			float y = screen_coords.y - (screen_coords.y * (refraction.z - 0.5) * 2.0 * 1.0)
			
			return vec4(0.0, 0.0, 0.0, 1.0);
		}
	]]

	local shader = love.graphics.newShader(code)
end