FFI = require("ffi")

include("extensions/")
include("util/")
include("callbacks")
include("library/class")
include("library/containers/")
include("library/math/")
include("library/")
include("source/")

class.Load()

stats     = {}
graphics  = love.graphics

function rep(s, n)
    local out = ""
    
    for i = 1, n do
        out = out .. s
    end
    
    return out
end

function table_serialise(t, depth)
    local output = ""
    if type(t) == "table" then
        for k, v in pairs(t) do
            if (depth or 0) > 0 then
                output = output .. "\n" .. rep("\t", (depth or 0)) .. tostring(k) .. ":" .. table_serialise(v, (depth or 0) + 1)
            else
                output = output .. rep("\t", (depth or 0)) .. tostring(k) .. ":" .. table_serialise(v, (depth or 0) + 1)
            end
        end
    else
        output = output .. " " .. tostring(t)
    end
    
    return output
end

function CallFunctionOnType(typename, method, ...)
	local batch = SceneManager:GetActiveScene().__objects[typename]
	if batch then
		local f = nil

		local index, component = next(batch, nil)
		while index do
			if f == nil then
				f = component[method]

				if f == nil or type(f) ~= "function" then
					f = nil
					break
				end
			end

			if component.enabled == nil or component.enabled == true then
				f(component, ...)
			end

			index, component = next(batch, index)
		end	
	end
end

function CallFunctionOnAll(method, ignore, ...)
	for name, batch in pairs(SceneManager:GetActiveScene().__objects) do
		if ignore == nil then
			CallFunctionOnType(name, method, ...)
		else
			if table.HasValue(ignore, name) then
			else
				CallFunctionOnType(name, method, ...)
			end
		end
	end
end

local hero = Sprite("resources/sprites/hero.png")
hero:NewFrame(16, 16, 16, 16)
hero:NewFrame(32, 16, 16, 16)
hero:NewFrame(48, 16, 16, 16)
hero:NewFrame(64, 16, 16, 16)
hero:NewFrame(80, 16, 16, 16)
hero:NewFrame(96, 16, 16, 16)
hero:NewFrame(16, 32, 16, 16)
hero:NewFrame(32, 32, 16, 16)
hero:NewFrame(48, 32, 16, 16)
hero:NewFrame(64, 32, 16, 16)
hero:NewFrame(80, 32, 16, 16)
hero:NewFrame(96, 32, 16, 16)
hero:NewFrame(16, 48, 16, 16)
hero:NewFrame(32, 48, 16, 16)
hero:NewFrame(48, 48, 16, 16)
hero:NewFrame(64, 48, 16, 16)
hero:NewFrame(96, 48, 16, 16)
hero:NewFrame(16, 64, 16, 16)
hero:NewFrame(32, 64, 16, 16)
hero:NewFrame(48, 64, 16, 16)
hero:NewFrame(64, 64, 16, 16)
hero:NewFrame(80, 64, 16, 16)
hero:NewFrame(96, 64, 16, 16)
hero:NewFrame(16, 80, 16, 16)
hero:NewFrame(32, 80, 16, 16)
hero:NewFrame(48, 80, 16, 16)
hero:NewFrame(64, 80, 16, 16)
hero:NewFrame(80, 80, 16, 16)
hero:NewFrame(96, 80, 16, 16)

hero.pixelPerUnit = 16

hero:NewAnimation("idle", Animation(1.0, true, { 1, 2, 3, 4 }))

local hero_emission = Sprite("resources/sprites/hero_gray.png")

hook.Add("love.load", "game", function()
	Screen.Flip()
	
	Input.Update()
	Input.LateUpdate()

	SceneManager:GetActiveScene()
	
	object = GameObject()
	object:AddComponent("Camera")
	
	object = GameObject()
	local renderer                = object:AddComponent("SpriteRenderer")
	renderer.sprite               = Sprite("resources/face.png")
	renderer.sprite.pixelPerUnit  = 256
	object:AddComponent("Player")
end)

hook.Add("love.update", "game", function()
	local scene = SceneManager:GetActiveScene()
	
	Input.Update()

	hook.Call("Update")
	scene:Update()
	
	hook.Call("LateUpdate")
	scene:LateUpdate()

end)

local shader_code = [[
	extern vec2 screen_dimensions;
	extern Image texture_cubemap;
	extern Image texture_emission;
	extern Image texture_refraction;
	extern float time;
	extern float strength;
	
	float opacity 		= 0.0;
	
	vec4 base			= vec4(0.0, 0.0, 0.0, 1.0);
	vec4 emission		= vec4(0.0, 0.0, 0.0, 1.0);
	vec4 normal			= vec4(0.0, 0.0, 0.0, 1.0);
	vec4 refraction 	= vec4(0.0, 0.0, 0.0, 1.0);
	vec4 frag_Colour 	= vec4(1.0, 1.0, 1.0, 1.0);
	
	vec4 effect(vec4 colour, Image texture_diffuse, vec2 uv_coords, vec2 screen_coords)
	{
		float sx = (screen_coords.x - 0.5) / screen_dimensions.x;
		float sy = (screen_coords.y - 0.5) / screen_dimensions.y;
		
		base = Texel(texture_diffuse, uv_coords.xy);

		vec4 refraction = Texel(texture_refraction, uv_coords.xy);
		refraction 	= Texel(texture_cubemap, vec2(
				sx - (sx * ((refraction.r - 0.5) * 2.0) * 0.01 * strength), 
				sy - (sy * ((refraction.b - 0.5) * 2.0) * 0.01 * strength)
			)
		);
		
		frag_Colour = mix(base, refraction, 1.0 - opacity) * colour;
		
		return frag_Colour;
	}
]]

blur_code = [[
    #ifndef GL_ES
    #define lowp
    #define mediump
    #define highp
    #endif
    
    extern float steps;
    extern float intensity;
    
    vec4 effect(vec4 colour, Image texture, vec2 uv_coords, vec2 screen_coords)
    {
        vec2 size   = 1.0 / love_ScreenSize.xy;
        vec4 result = Texel(texture, uv_coords);
       
        for(float i = 1.0; i <= steps; i += 1.0)
        {
        	    result = result + Texel(texture, vec2(uv_coords.x, uv_coords.y - size.y * i));
        	    result = result + Texel(texture, vec2(uv_coords.x, uv_coords.y + size.y * i));
        }
    
        result   = result / (steps * 2.0 + 1.0) * intensity;
        result.a = 1.0;
        
        return result;
    }
]]
blur_shader = graphics.newShader(blur_code)

scanlines = [[
    extern float pixels;
    extern float intensity;
    extern float time;
    
    vec4 effect(vec4 colour, Image texture, vec2 uv_coords, vec2 screen_coords)
    {
        vec2 size = 1.0 / love_ScreenSize.xy;
        
        float brightness  = 1.0;
        float amplitude   = sign(cos(time * 80.0));
        
        vec4 diffuse = Texel(texture,
        	    vec2(
        	        uv_coords.x + (step(mod(uv_coords.y * love_ScreenSize.y, pixels), pixels * 0.5) - 0.5) * 2.0 * 0.001 * intensity * sin(time * 5.0),
        	        	uv_coords.y
        	    )
        	);
        
        float red     = diffuse.r;
        float green   = diffuse.g;
        float blue    = diffuse.b;
        
        vec4 result = vec4(diffuse.xyz, 1.0) * brightness;
    
        if(mod((uv_coords.y + mod(time * 0.08, 2.0)) * love_ScreenSize.y, pixels) < pixels * 0.5)
        {
            result = result * 0.75;
            result.r = result.r * 0.25;
        }
        else
        {
        	    result.b = result.b * 0.5;
        }
        	
        return vec4(result.xyz, 1.0);
    }
]]

scanline_shader = graphics.newShader(scanlines)

pixels = [[
    vec4 effect(vec4 colour, Image texture, vec2 uv_coords, vec2 screen_coords)
    {
    	return vec4(1.0, 1.0, 1.0, 1.0);
    }
]]

pixels_shader = graphics.newShader(pixels)

hook.Add("love.render", "game", function()
	local scene = SceneManager:GetActiveScene()
	
	hook.Call("OnPreRender")
	
	scene:Render()
	
	scanline_shader:send("pixels", 8)
	scanline_shader:send("time", Time.Elapsed * 0.5)
	scanline_shader:send("intensity", 0.5)
	
	Screen.Draw(Camera.main.canvases.post.source, 0, 0, 0)
	
	--if Screen.flipped then
	--    graphics.draw(, Screen.height * 0.5, Screen.width * 0.5, math.rad(-90), 1.0, 1.0, Screen.width * 0.5, Screen.height * 0.5)
	--else
	--    graphics.draw(Camera.main.canvases.post.source, 0, 0, 0)
	--end

	hook.Call("OnPostRender")
	hook.Call("OnRenderImage")
	
	Input.LateUpdate()
	
 Screen.Print(table_serialise(stats), 10, 10, 3.0, 3.0)
end)

hook.Add("OnRenderImage", "debug", function()
	stats.graphics = graphics.getStats()
	stats.graphics.fps             = love.timer.getFPS()
	stats.graphics.memory          = string.format("%.2f MB", stats.graphics.texturememory / 1024 / 1024)
	stats.graphics.texturememory   = nil
	stats.graphics.mouse = Vector2(Input.GetMousePosition())
 stats.graphics.screen = Vector2(Screen.width, Screen.height)
end)