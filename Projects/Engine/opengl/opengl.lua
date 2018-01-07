local FFI = require("ffi")

local opengl_header = [[
typedef float GLfloat;
typedef unsigned int GLbitfield;
typedef unsigned int GLuint;
typedef double GLdouble;
typedef unsigned int GLenum;
typedef unsigned char GLboolean;
typedef int GLsizei;
typedef int GLint;
typedef char GLchar;

#define GL_NO_ERROR                       0
#define GL_NONE                           0
#define GL_EQUAL                          0x0202
#define GL_LEQUAL                         0x0203
#define GL_GEQUAL                         0x0206
#define GL_FRONT                          0x0404
#define GL_BACK                           0x0405
#define GL_CW                             0x0900
#define GL_CCW                            0x0901
#define GL_CULL_FACE                      0x0B44
#define GL_DEPTH_TEST                     0x0B71
#define GL_TEXTURE_2D                     0x0DE1
#define GL_FLOAT                          0x1406
#define GL_DEPTH_COMPONENT                0x1902
#define GL_NEAREST                        0x2600
#define GL_LINEAR                         0x2601
#define GL_TEXTURE_MAG_FILTER             0x2800
#define GL_TEXTURE_MIN_FILTER             0x2801
#define GL_TEXTURE_WRAP_S                 0x2802
#define GL_TEXTURE_WRAP_T                 0x2803
#define GL_CLAMP_TO_EDGE                  0x812F
#define GL_TEXTURE0                       0x84C0
#define GL_TEXTURE7                       0x84C7
#define GL_TEXTURE_COMPARE_MODE           0x884C
#define GL_TEXTURE_COMPARE_FUNC           0x884D
#define GL_COMPARE_REF_TO_TEXTURE         0x884E
#define GL_CURRENT_PROGRAM                0x8B8D
#define GL_FRAMEBUFFER_COMPLETE           0x8CD5
#define GL_DEPTH_ATTACHMENT               0x8D00
#define GL_FRAMEBUFFER                    0x8D40
#define GL_RENDERBUFFER                   0x8D41

#define GL_DEPTH_COMPONENT16              0x81A5
#define GL_DEPTH_COMPONENT24              0x81A6

#define GL_DEPTH_BUFFER_BIT               0x00000100
#define GL_COLOR_BUFFER_BIT               0x00004000

typedef void (APIENTRYP PFNGLUNIFORM1IPROC) (GLint location, GLint v0);
typedef void (APIENTRYP PFNGLACTIVETEXTUREPROC) (GLenum texture);
typedef GLint (APIENTRYP PFNGLGETUNIFORMLOCATIONPROC) (GLuint program, const GLchar *name);
typedef void (APIENTRYP PFNGLGETINTEGERVPROC) (GLenum pname, GLint *data);
typedef GLenum (APIENTRYP PFNGLGETERRORPROC) (void);
typedef void (APIENTRYP PFNGLFRAMEBUFFERRENDERBUFFERPROC) (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer);
typedef void (APIENTRYP PFNGLVIEWPORTPROC) (GLint x, GLint y, GLsizei width, GLsizei height);
typedef void (APIENTRYP PFNGLREADBUFFERPROC) (GLenum mode);
typedef void (APIENTRYP PFNGLFRAMEBUFFERTEXTURE2DPROC) (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
typedef void (APIENTRYP PFNGLRENDERBUFFERSTORAGEMULTISAMPLEPROC) (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height);
typedef void (APIENTRYP PFNGLBINDRENDERBUFFERPROC) (GLenum target, GLuint renderbuffer);
typedef void (APIENTRYP PFNGLDELETERENDERBUFFERSPROC) (GLsizei n, const GLuint *renderbuffers);
typedef void (APIENTRYP PFNGLGENRENDERBUFFERSPROC) (GLsizei n, GLuint *renderbuffers);
typedef void (APIENTRYP PFNGLRENDERBUFFERSTORAGEPROC) (GLenum target, GLenum internalformat, GLsizei width, GLsizei height);
typedef void (APIENTRYP PFNGLBINDFRAMEBUFFERPROC) (GLenum target, GLuint framebuffer);
typedef void (APIENTRYP PFNGLDELETEFRAMEBUFFERSPROC) (GLsizei n, const GLuint *framebuffers);
typedef void (APIENTRYP PFNGLGENFRAMEBUFFERSPROC) (GLsizei n, GLuint *framebuffers);
typedef GLenum (APIENTRYP PFNGLCHECKFRAMEBUFFERSTATUSPROC) (GLenum target);
typedef void (APIENTRYP PFNGLTEXIMAGE2DPROC) (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const void *pixels);
typedef void (APIENTRYP PFNGLTEXPARAMETERIPROC) (GLenum target, GLenum pname, GLint param);
typedef void (APIENTRYP PFNGLBINDTEXTUREPROC) (GLenum target, GLuint texture);
typedef void (APIENTRYP PFNGLDELETETEXTURESPROC) (GLsizei n, const GLuint *textures);
typedef void (APIENTRYP PFNGLGENTEXTURESPROC) (GLsizei n, GLuint *textures);
typedef void (APIENTRYP PFNGLDRAWBUFFERPROC) (GLenum mode);
typedef void (APIENTRYP PFNGLDEPTHMASKPROC) (GLboolean flag);
typedef void (APIENTRYP PFNGLDISABLEPROC) (GLenum cap);
typedef void (APIENTRYP PFNGLCLEARPROC) (GLbitfield mask);
typedef void (APIENTRYP PFNGLCLEARDEPTHPROC) (GLdouble depth);
typedef void (APIENTRYP PFNGLCLEARDEPTHFPROC) (GLfloat d);
typedef void (APIENTRYP PFNGLDEPTHFUNCPROC) (GLenum func);
typedef void (APIENTRYP PFNGLDEPTHRANGEPROC) (GLdouble near, GLdouble far);
typedef void (APIENTRYP PFNGLENABLEPROC) (GLenum cap);
typedef void (APIENTRYP PFNGLCULLFACEPROC) (GLenum mode);
typedef void (APIENTRYP PFNGLFRONTFACEPROC) (GLenum mode);
]]

local OpenGL = {
	GL 		= {},
	gl 		= {},
	loader 	= nil,
	Import 	= function(self)
		rawset(_G, "GL", self.GL)
		rawset(_G, "gl", self.gl)
	end
}

if FFI.os == "Windows" then
	opengl_header = opengl_header:gsub("APIENTRYP", "__stdcall *")
	opengl_header = opengl_header:gsub("APIENTRY", "__stdcall")
else
	opengl_header = opengl_header:gsub("APIENTRYP", "*")
	opengl_header = opengl_header:gsub("APIENTRY", "")
end

local type_glenum = FFI.typeof("unsigned int")
local type_uint64 = FFI.typeof("uint64_t")

local function constant_replace(name, value)
	local GL = OpenGL.GL

	local enum = tonumber(value)
	if not enum then
		if value:match("ull$") then
			--Potentially reevaluate this for LuaJIT 2.1
			GL[name] = loadstring("return " .. value)()
		elseif value:match("u$") then
			value 	= value:gsub("u$", "")
			enum 	= tonumber(value)
		end
	end

	GL[name] = GL[name] or type_glenum(enum)

	return ""
end

opengl_header = opengl_header:gsub("#define GL_(%S+)%s+(%S+)\n", constant_replace)

FFI.cdef(opengl_header)

if FFI.os == "Windows" then
	FFI.load('opengl32')
end

local metatable = 
{
	__index = function(self, name)
		local glname 	= "gl" .. name
		local procname 	= "PFNGL" .. name:upper() .. "PROC"
		local method 	= FFI.cast(procname, OpenGL.loader(glname))

		rawset(self, name, method)

		return method
	end
}

setmetatable(OpenGL.gl, metatable)

function OpenGL_clear(colour, depth)
	local clear = 0
	if colour then
		clear = bit.bor(clear, tonumber(GL.COLOR_BUFFER_BIT))
	end
	if depth or depth == nil then
		clear = bit.bor(clear, tonumber(GL.DEPTH_BUFFER_BIT))
	end
	
	gl.Clear(clear)
end

function OpenGL_reset()
	OpenGL_set_depth_test()
	OpenGL_set_depth_write()
end

function  OpenGL_set_depth_write(mask)
	if mask then
		assert(type(mask) == "boolean", "set_depth_write expects one parameter of type 'boolean'")
	end
	if mask == nil then
		mask = true
	end
	gl.DepthMask(mask and 1 or 0)
end

local depth_test_methods = 
{
	greater = OpenGL.GL.GEQUAL,
	equal 	= OpenGL.GL.EQUAL,
	less 	= OpenGL.GL.LEQUAL
}
function OpenGL_set_depth_test(method)
	if method then
		assert(depth_test_methods[method], "Invalid depth test method.")

		gl.Enable(GL.DEPTH_TEST)
		gl.DepthFunc(methods[method])

		if OpenGL_ES then
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

function OpenGL_newCanvas(width, height, format, msaa, gen_depth)
	--TODO: Test this to make sure things are properly freed.
	if OpenGL_ES then
		error()
		return
	end
	local w, h 		= width or love.graphics.getWidth(), height or love.graphics.getHeight()
	local canvas 	= love.graphics.newCanvas(w, h, format, msaa)

	if gen_depth and canvas then
		love.graphics.setCanvas(canvas)

		local depth = FFI.new("unsigned int[1]", 1)
		gl.GenRenderbuffers(1, depth);
		gl.BindRenderbuffer(GL.RENDERBUFFER, depth[0]);

		if not OpenGL_ES and (type(msaa) == "number" and msaa > 1) then
			gl.RenderbufferStorageMultisample(GL.RENDERBUFFER, msaa, OpenGL_ES and GL.DEPTH_COMPONENT16 or GL.DEPTH_COMPONENT24, w, h)
		else
			gl.RenderbufferStorage(GL.RENDERBUFFER, OpenGL_ES and GL.DEPTH_COMPONENT16 or GL.DEPTH_COMPONENT24, w, h)
		end

		gl.FramebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, depth[0])

		local status = gl.CheckFramebufferStatus(GL.FRAMEBUFFER)

		if status ~= GL.FRAMEBUFFER_COMPLETE then
			error(string.format("Framebuffer error:( (%d)", status))
		end

		if gl.GetError() ~= GL.NO_ERROR then
			error("unknown error")
		end
		
		OpenGL_clear()
		
		love.graphics.setCanvas()
	end

	return canvas
end

return OpenGL