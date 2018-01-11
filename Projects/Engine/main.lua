FFI = require("ffi")
BIT = require("bit")

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

Material("Unlit/Colour", "Unlit/Colour", [[
	#ifdef VERTEX

	vec4 position(mat4 _, vec4 vertex)
	{
		return ProjectionMatrix * TransformMatrix * vertex;
	}

	#endif

	#ifdef PIXEL

	vec4 effect(vec4 _Colour, Image _MainTex, vec2 uv_MainTex, vec2 screen_coords)
	{ 
		return _Colour;
	}

	#endif
]])

Material("Sprites/Default", "Sprites/Default", [[
	#ifndef GL_ES
	#define lowp
	#define mediump
	#define highp
	#endif

	#ifdef VERTEX
	extern mat4 u_projection;

	varying vec4 frag_Position;

	vec4 position(mat4 _a, vec4 _b)
	{
		frag_Position = TransformMatrix * VertexPosition;

		return u_projection * frag_Position;
	}

	#endif

	#ifdef PIXEL
	#define MAX_LIGHTS 200

	extern vec3 	light_position[MAX_LIGHTS];
	extern vec3 	light_colour[MAX_LIGHTS];
	extern float 	light_distance[MAX_LIGHTS]; //clamping the light to a specific distance / radius; 
	extern float 	light_intensity[MAX_LIGHTS]; //the intensity of the light

	extern mat4 u_view;
	extern mat4 u_projection;

	varying vec4 frag_Position;

	extern Image _Normal;
	extern Image _Emission;
	extern Image _Specular;
	extern float _Shininess;

	extern vec4 _emission_colour;

	void effects(vec4 _Colour, Image _MainTex, vec2 uv_MainTex, vec2 screen_coords)
	{
		vec4 _MainTex_Colour 	= Texel(_MainTex, uv_MainTex);
		vec4 _Normal_Colour 	= Texel(_Normal, uv_MainTex);
		vec4 _Emission_Colour 	= Texel(_Emission, uv_MainTex);

		vec4 normal = normalize(_Normal_Colour * 2.0 - 1.0);
		normal.z = 0.0;

		vec3 _Lights = vec3(0.0, 0.0, 0.0);
		for(int i = 0; i < MAX_LIGHTS; i++)
		{
			vec3 _Light 			= (u_view * vec4(light_position[i], 1.0)).xyz + (vec3(love_ScreenSize.xy, 0.0) * 0.5);
			vec3 _LightToFragment 	= normalize(_Light - frag_Position.xyz);

			float intensity 	= light_intensity[i];
			float brightness 	= 
				(1.0 - smoothstep(0.0, light_distance[i], distance(_Light, frag_Position.xyz))) * intensity;

			_Lights += light_colour[i].rgb * brightness * (1.0 - abs(dot(normal.rgb, _LightToFragment)));
		}

		//emission
		float brightness = (_Emission_Colour.r + _Emission_Colour.g + _Emission_Colour.b) * 0.333333333;

		if(brightness > 0.0)
		{
			love_Canvases[1] = _Emission_Colour * vec4(_MainTex_Colour.rgb, 1.0) * _MainTex_Colour.a;
		}
		else
		{
			love_Canvases[1] = vec4(0,0,0,1) * _MainTex_Colour.a;
		}

		love_Canvases[0] = vec4(_MainTex_Colour.rgb, _MainTex_Colour.a) * vec4(_Lights, 1.0);
	}

	#endif
]])
SpriteRenderer.material = Material("Sprites/Default")
Material("Sprites/Default"):Set("_Normal", "Image", Image("resources/engine/normal.png").source)
Material("Sprites/Default"):Set("_Emission", "Image", Image("resources/engine/emission.png").source)
Material("Sprites/Default"):Set("_emission_colour", "Colour", { 255, 255, 255, 255 })

hook.Add("love.load", "game", function()
	Input.Update()
	Input.LateUpdate()

	SceneManager:GetActiveScene()
	
	object = GameObject()
	object:AddComponent("Camera")
	object:AddComponent("FlyCamera")

	object = GameObject()
	object:AddComponent("Light")
	object:AddComponent("Move")

	object = GameObject(0, 0)
	local renderer 					= object:AddComponent("SpriteRenderer")
	renderer.sprite 				= Sprite("resources/floor1.png")
	renderer.sprite.pixelPerUnit 	= 64
end)

hook.Add("love.update", "game", function()
	local scene = SceneManager:GetActiveScene()
	
	Input.Update()

	hook.Call("Update")
	scene:Update()
	
	hook.Call("LateUpdate")
	scene:LateUpdate()
end)

hook.Add("love.render", "game", function()
	local scene = SceneManager:GetActiveScene()
	
	hook.Call("OnPreRender")
	
	scene:Render()
	
	Screen.Draw(Camera.main.buffers.post.source, 0, 0, 0)

	hook.Call("OnPostRender")
	hook.Call("OnRenderImage")
	
	Input.LateUpdate()
	
	Screen.Print(table.ToString(stats), 10, 10, 1.0, 1.0)
end)

hook.Add("OnRenderImage", "debug", function()
	stats.graphics 					= graphics.getStats()
	stats.graphics.memory 			= string.format("%.2f MB", stats.graphics.texturememory / 1024 / 1024)
	stats.graphics.texturememory 	= nil
	stats.fps 						= love.timer.getFPS()
	stats.mouse 					= Vector2(Input.GetMousePosition())
	stats.screen 					= Vector2(Screen.width, Screen.height)
	stats.camera 					= Camera.main.transform.globalPosition
end)