Circle = {}

function Circle.Generate(a,b,c)
	return {
		x = a, 
		y = b, 
		radius = c
	}
end

function Circle.CircleVsCircle(a,b)
	local r = a.radius + b.radius
	r = r * r
	return r < (a.x + b.x)^2 + (a.y + b.y)^2
end