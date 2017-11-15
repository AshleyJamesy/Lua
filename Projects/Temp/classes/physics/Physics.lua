engine = {}
engine.physics = {}

local function dot(x1,y1,x2,y2)
	return x1 * x2 + y1 * y2
end

local function distance(x1,y1,x2,y2)
	return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end 

function engine.physics.ResolveCollision(a,b)
	local rv 	= b.velocity - a.velocity
	local van 	= dot()
	local e 	= math.min(a.material.restitution, b.material.restitution)

	local j 	= (-(1 + e) * van) / (1 / a.mass + 1 / b.mass)

	local i = j * n
	a.velocity = a.velocity - (1 / a.mass * i)
	b.velocity = b.velocity + (1 / b.mass * i)
end

function engine.physics.GeneratePairs(bodies)
	local list = {}

	for i = 1, #bodies do
		local A = bodies[i]

		for j = i, #bodies do
			local B = bodies[i]

			if A == B then
			else
				local A_AABB = AABB.Generate()
				local B_AABB = AABB.Generate()

				--If Intersecting Add to Pair List
			end
		end
	end
end