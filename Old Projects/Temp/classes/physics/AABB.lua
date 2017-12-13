AABB = {}

function AABB.Generate(x1,y1,x2,y2)
	return {
		xmin = x1 or 0, 
		ymin = y1 or 0, 
		xmax = x2 or 0, 
		ymax = y2 or 0
	}
end