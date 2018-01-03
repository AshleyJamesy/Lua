require "Love3D"

objects = { }
function newObject(typ, pos, rot, center, ...)
	local o = { }
	o.points, o.polygons = love3D.preset[typ](...)
	o.pos = pos
	o.rot = rot
	o.center = center
	objects[#objects+1] = o
end

meshes = { }
meshes[4] = love.graphics.newMesh(
{
	{"VertexPosition", "float", 2},
	{"depth", "float", 1},
}, 4)

function love.load()
	screenWidth = 800
	screenHeight = 600
	
	vp = {}
	vp.x = screenWidth/2
	vp.y = screenHeight/2
	
	fl = 300
	love3D.load(fl, vp.x, vp.y)
	love3D.light.load()
	
	newObject("cube3D", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0}, 1)
	
	brt = 1
	lgt = {}
	lgt.x = 0
	lgt.y = 0
	lgt.z = -200
	
	isUsingBackfaceCull = true
	
	love.window.setMode(screenWidth, screenHeight)
end

function love.update(dt)
	if love.keyboard.isDown("right") then
		objects[1].rot.y = objects[1].rot.y + dt
	end
	if love.keyboard.isDown("left") then
		objects[1].rot.y = objects[1].rot.y - dt
	end

	if love.keyboard.isDown("up") then
		objects[1].rot.x = objects[1].rot.x + dt
	end
	if love.keyboard.isDown("down") then
		objects[1].rot.x = objects[1].rot.x - dt
	end
end

mainCanvas = love.graphics.newCanvas()

renderShader = love.graphics.newShader[[
	varying float depthV;
	
	#ifdef VERTEX
	attribute float depth;
	vec4 position(mat4 transform_projection, vec4 vertex_position) {
		depthV = depth;
		return transform_projection * vertex_position;
	}
	#endif
	
	#ifdef PIXEL
	extern Image depthBuffer;
	vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {
		vec4 d = Texel(depthBuffer, sc/vec2(800, 600));
		if (depthV < d.a) {
			vec4 i = Texel(texture, tc);
			return vec4(i.r*color.r, i.g*color.g, i.b*color.b, depthV);
		} else {
			discard;
		}
	}
	#endif
]]
drawShader = love.graphics.newShader[[
	vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {
		vec4 c = Texel(texture, tc);
		return vec4(c.r, c.g, c.b, 1);
	}
]]
drawShader_debug = love.graphics.newShader[[
	vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {
		vec4 c = Texel(texture, tc);
		return vec4(c.a, c.a, c.a, 1);
	}
]]

function love.draw()
	love.graphics.setCanvas(mainCanvas)
	love.graphics.clear(0, 0, 0, 255)
	love.graphics.setShader(renderShader)
	love.graphics.setBlendMode("replace", "premultiplied")
	
	local polygons = {}
	for _,o in ipairs(objects) do
		love3D.func.zSortAvg(o.polygons, o.points)
		for pi,p in ipairs(o.polygons) do
			love3D.light.set(lgt.x, lgt.y, lgt.z, brt, 255, 0, 0)
			love3D.light.setAmbience(0, 50, 0)
			local v = { }
			for i = 1, #p-1 do
				local x, y, z = o.points[p[i]].x, o.points[p[i]].y, o.points[p[i]].z
				y, z = love3D.func.rotateX(y, z, o.rot.x, o.center.y, o.center.z)
				x, z = love3D.func.rotateY(x, z, o.rot.y, o.center.x, o.center.z)
				x, y = love3D.func.rotateZ(x, y, o.rot.z, o.center.x, o.center.y)
				local px, py = love3D.calculatePointPosition(x, y, z)
				v[i] = {x = px, y = py, ox = x, oy = y, oz = z, dist = math.max(0, math.min(1, 0.5 + z/4))}
			end
			love.graphics.setCanvas(mainCanvas)
			--if love3D.isBackFace(v[1].x, v[1].y, v[2].x, v[2].y, v[3].x, v[3].y) then
				meshes[4]:setVertices({
					{v[1].x, v[1].y, v[1].dist},	
					{v[2].x, v[2].y, v[2].dist},	
					{v[3].x, v[3].y, v[3].dist},	
					{v[4].x, v[4].y, v[4].dist},	
				})
				love.graphics.setColor(love3D.light.getNewColor({x = v[1].ox, y = v[1].oy, z = v[1].oz}, {x = v[2].ox, y = v[2].oy, z = v[2].oz}, {x = v[3].ox, y = v[3].oy, z = v[3].oz}))
				--if pi == 1 then love.graphics.setColor(255, 0, 0) end
				--if pi == 2 then love.graphics.setColor(0, 255, 0) end

				love.graphics.setCanvas(mainCanvas)
				renderShader:send("depthBuffer", mainCanvas)
				love.graphics.draw(meshes[4])
				
			--end
		end
	end
	
	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255)
	love.graphics.origin()
	love.graphics.setBlendMode("screen")
	
	if love.keyboard.isDown("space") then 
		love.graphics.setShader(drawShader_debug)
	else
		love.graphics.setShader(drawShader)
	end
	love.graphics.draw(mainCanvas)
end