-- Preset3D --

function love3D.preset.cube3D(sideLength)
	local points = {}
	local polyTable = {}
	for i=0, 8 do
		local point = {}
		point.x = 0
		point.y = 0
		point.z = 0
		table.insert(points, point)
	end
	local s = sideLength/2
	points[1].x, points[1].y, points[1].z = -s, -s, -s
	points[2].x, points[2].y, points[2].z = s, -s, -s
	points[3].x, points[3].y, points[3].z = s, -s, s
	points[4].x, points[4].y, points[4].z = -s, -s, s
	points[5].x, points[5].y, points[5].z = -s, s, -s
	points[6].x, points[6].y, points[6].z = s, s, -s
	points[7].x, points[7].y, points[7].z = s, s, s
	points[8].x, points[8].y, points[8].z = -s, s, s
	polyTable = {
	{1, 2, 3, 4, 1},	--bottom
	{5, 6, 7, 8, 1},	--top
	{3, 4, 8, 7, 1},	--back
	{1, 2, 6, 5, 1},	--front
	{2, 3, 7, 8, 1},	--right
	{1, 5, 8, 4, 1}		--left
	}
	return points, polyTable
end