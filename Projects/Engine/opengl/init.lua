local FFI = require("ffi")

function OpenGL_Import()
	local loaded = pcall(function() 
		return FFI.C.SDL_GL_DEPTH_SIZE 
	end)
	
	if not loaded then
		FFI.cdef([[
			typedef enum {
				SDL_GL_DEPTH_SIZE = 6
			} SDL_GLattr;
			void *SDL_GL_GetProcAddress(const char *proc);
			int SDL_GL_GetAttribute(SDL_GLattr attr, int* value);
		]])
	end
	
	-- Windows needs to use an external SDL
	local sdl
	if love.system.getOS() == "Windows" then
		if not love.filesystem.isFused() and love.filesystem.isFile("bin/SDL2.dll") then
			sdl = FFI.load("bin/SDL2")
		else
			sdl = FFI.load("SDL2")
		end
	else
		-- On other systems, we get the symbols for free.
		sdl = FFI.C
	end
	
	-- Get handles for OpenGL
	local OpenGL
	local Platform = select(1, love.graphics.getRendererInfo())
	if Platform == "OpenGL ES" then
		OpenGL_ES 	= true
		OpenGL 		= include("opengl/opengles2")
	else
		OpenGL 		= include("opengl/opengl")
	end
	
	OpenGL.loader = function(fn)
		return sdl.SDL_GL_GetProcAddress(fn)
	end
	
	OpenGL:Import()
	
	local out = FFI.new("int[?]", 1)
	sdl.SDL_GL_GetAttribute(sdl.SDL_GL_DEPTH_SIZE, out)
end

function OpenGL_Clear(color, depth)
	local to_clear = 0
	if color then
		to_clear = bit.bor(to_clear, tonumber(GL.COLOR_BUFFER_BIT))
	end
	if depth or depth == nil then
		to_clear = bit.bor(to_clear, tonumber(GL.DEPTH_BUFFER_BIT))
	end
	gl.Clear(to_clear)
end

--- Reset LOVE3D state.
-- Disables depth testing, enables depth writing, disables culling and resets
-- front face.
function OpenGL_Reset()
	OpenGL_DepthTest()
	OpenGL_DepthWrite()
	OpenGL_Cull()
	OpenGL_FrontFace()
end

--- Set depth writing.
-- Enable or disable writing to the depth buffer.
-- @param mask
function OpenGL_DepthWrite(mask)
	if mask then
		assert(type(mask) == "boolean", "set_depth_write expects one parameter of type 'boolean'")
	end
	if mask == nil then
		mask = true
	end
	gl.DepthMask(mask and 1 or 0)
end

--- Set depth test method.
-- Can be "greater", "equal", "less" or unspecified to disable depth testing.
-- Usually you want to use "less".
-- @param method
function OpenGL_DepthTest(method)
	if method then
		local methods = 
		{
			greater = GL.GEQUAL,
			equal 	= GL.EQUAL,
			less 	= GL.LEQUAL
		}

		assert(methods[method], "Invalid depth test method.")
		
		gl.Enable(GL.DEPTH_TEST)
		gl.DepthFunc(methods[method])

		if use_gles then
			gl.DepthRangef(0, 1)
			gl.ClearDepthf(1.0)
		else
			gl.DepthRange(0, 1)
			gl.ClearDepth(1.0)
		end
	else
		gl.Disable(GL.DEPTH_TEST)
	end
end

--- Set front face winding.
-- Can be "cw", "ccw" or unspecified to reset to ccw.
-- @param facing
function OpenGL_FrontFace(facing)
	if not facing or facing == "ccw" then
		gl.FrontFace(GL.CCW)
		return
	elseif facing == "cw" then
		gl.FrontFace(GL.CW)
		return
	end

	error("Invalid face winding. Parameter must be one of: 'cw', 'ccw' or unspecified.")
end

--- Set culling method.
-- Can be "front", "back" or unspecified to reset to none.
-- @param method
function OpenGL_Cull(method)
	if not method then
		gl.Disable(GL.CULL_FACE)
		return
	end

	gl.Enable(GL.CULL_FACE)

	if method == "back" then
		gl.CullFace(GL.BACK)
		return
	elseif method == "front" then
		gl.CullFace(GL.FRONT)
		return
	end

	error("Invalid culling method: Parameter must be one of: 'front', 'back' or unspecified")
end