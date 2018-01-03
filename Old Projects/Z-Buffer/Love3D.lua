--[[
The Love3D Library --
Version 0.3.2
License : Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported --
http://creativecommons.org/licenses/by-nc-sa/3.0/ --
Programmed by substitute541
This is NOT the L3D Library. the L3D Library was made by 10$man
]]--

-- Var Setters
love3D = {}
love3D.graphics = {}
love3D.func = {}
love3D.light = {}
love3D.preset = {}
love3D.version = "0.3.2"

-- Load function
function love3D.load(fl, vpX, vpY)
	focalLength = fl
	vanishingPointX, vanishingPointY = vpX, vpY
	print("Loaded Love3D v" .. love3D.version)
	if love.filesystem.exists("Light3D.lua") then
		require "Light3D"
		print("Loaded Light3D!")
	else print("Light3D does not exist. Continuing") end
	if love.filesystem.exists("Preset3D.lua") then
		require "Preset3D"
		print("Loaded Preset3D!")
	else print("Preset3D does not exist. Continuing") end
	if love.filesystem.exists("Beetle.lua") then
		require "Beetle"
		print("Loaded Beetle Debug!")
		beetle.load()
		beetle.add("Love3D Version", "love3D.version")
	end
end

-- Calculate point position by transforming the 3D coordinates to 2D
function love3D.calculatePointPosition(x, y, z)
	local scale = focalLength/(focalLength + z) * 100
	local newX = vanishingPointX + x * scale
	local newY = vanishingPointY + y * scale
	return newX, newY, scale
end

-- Checks if it's the backface
function love3D.isBackFace(sx1, sy1, sx2, sy2, sx3, sy3)
	local cax = sx3 - sx1
	local cay = sy3 - sy1
	local bcx = sx2 - sx3
	local bcy = sy2 - sy3
	return cax * bcy > cay * bcx
end

-- Draws a 2D Circle
function love3D.graphics.circle2D(mode, x, y, z, radius, segments)
	local xNew, yNew, scale = love3D.calculatePointPosition(x, y, z)
	love.graphics.circle(mode, xNew, yNew, radius * scale, segments)
end

-- Draws a triangle
function love3D.graphics.polygon(mode, bfc, p)
	local pn = { }
	for d,s in ipairs(p) do
		pn[d] = {love3D.calculatePointPosition(p.x, p.y, p.z)}
	end
	if bfc then
		if love3D.isBackFace(pn[1][1], pn[1][2], pn[2][1], pn[2][2], pn[3][1], pn[3][2]) then
			return
		end
	end
	love.graphics.polygon(mode, pn)
end

-- Draws a 2D Line segment
function love3D.graphics.lineSegment2D(width, style, x1, y1, z1, x2, y2, z2)
	local x1New, y1New = love3D.calculatePointPosition(x1, y1, z1)
	local x2New, y2New = love3D.calculatePointPosition(x2, y2, z2)
	love.graphics.setLine(width, style)
	love.graphics.line(x1New, y1New, x2New, y2New)
end

-- Rotates a certain point, by default, around the vanishing points
function love3D.func.rotateX(y, z, angleX, centerY, centerZ)
	local cosX = math.cos(angleX)
	local sinX = math.sin(angleX)
	local y1 = (y - centerY) * cosX - (z - centerZ) * sinX
	local z1 = (z - centerZ) * cosX + (y - centerY) * sinX
	return y1 + centerY, z1 + centerZ
end

function love3D.func.rotateY(x, z, angleY, centerX, centerZ)
	local cosY = math.cos(angleY)
	local sinY = math.sin(angleY)
	local x1 = (x - centerX) * cosY - (z - centerZ) * sinY
	local z1 = (z - centerZ) * cosY + (x - centerX) * sinY
	return x1 + centerX, z1 + centerZ
end

function love3D.func.rotateZ(x, y, angleZ, centerX, centerY)
	local cosZ = math.cos(angleZ)
	local sinZ = math.sin(angleZ)
	local x1 = (x - centerX) * cosZ - (y - centerY) * sinZ
	local y1 = (y - centerY) * cosZ + (x - centerX) * sinZ
	return x1 + centerX, y1 + centerY
end

-- Finds the average Z
function love3D.func.getAvgZTriangle(az, bz, cz)
	local avgZ = (az + bz + cz)/3
	return avgZ
end

-- Sorts which faces goes in front, and which goes in back
function love3D.func.zSortAvg(polyTable, verticesTable)
	for _,v in ipairs(polyTable) do
		v.avgZ = 0
		for i = 1, #v-1 do
			v.avgZ = v.avgZ + verticesTable[v[i]].z / (#v-1)
		end
	end
	table.sort(polyTable, function(A, B) return A.avgZ > B.avgZ end)
end

function love3D.func.zSortMin(polyTable, verticesTable)
	for i, v in ipairs(polyTable) do
		v.minZ = math.min(verticesTable[v[1]].z, verticesTable[v[2]].z, verticesTable[v[3]].z)
	end
	table.sort(polyTable, function(A, B) return A.minZ > B.minZ end)
end

-- Moves a shape or a table of points
function love3D.func.moveShape(pointTable, x, y, z)
	for i, v in ipairs(pointTable) do
		v.x = v.x + x
		v.y = v.y + y
		v.z = v.z + z
	end
end