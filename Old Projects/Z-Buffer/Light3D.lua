-- Light3D --

function love3D.light.load()
	light = {}
	light.x = 0
	light.y = 0
	light.z = 0
	light.brightness = 0
	light.r = 255
	light.b = 255
	light.g = 255
	light.newColor = {}
	light.factor = 0
	light.ar, light.ag, light.ab = 0, 0, 0
end

function love3D.light.set(x, y, z, brightness, r, g, b)
	light.brightness = brightness
	light.x = x
	light.y = y
	light.z = z
	light.r, light.g, light.b = r, g, b
end

function love3D.light.setAmbience(r, g, b)
	light.ar = r
	light.ag = g
	light.ab = b
end

function love3D.light.getLightFactor(pointA, pointB, pointC)
	ab = {}
	ab.x = pointA.x - pointB.x
	ab.y = pointA.y - pointB.y
	ab.z = pointA.z - pointB.z
	
	bc = {}
	bc.x = pointB.x - pointC.x
	bc.y = pointB.y - pointC.y
	bc.z = pointB.z - pointC.z
	
	norm = {}
	norm.x = (ab.y * bc.z) - (ab.z * bc.y)
	norm.y = -((ab.x * bc.z) - (ab.z * bc.x))
	norm.z = (ab.x * bc.y) - (ab.y * bc.x)
	
	dotProd = norm.x * light.x +
			  norm.y * light.y +
			  norm.z * light.z
	
	normMag = math.sqrt(norm.x * norm.x +
						norm.y * norm.y +
						norm.z * norm.z)
	
	lightMag = math.sqrt(light.x * light.x +
						 light.y * light.y +
						 light.z * light.z)
									
	return (math.acos(dotProd / (normMag * lightMag)) / math.pi) * light.brightness
end

function love3D.light.getNewColor(pointA, pointB, pointC)
	light.factor = love3D.light.getLightFactor(pointA, pointB, pointC)
	light.r = light.r * light.factor + light.ar
	light.b = light.b * light.factor + light.ag
	light.g = light.g * light.factor + light.ab
	light.newColor = {light.r, light.b, light.g, 255}
	return light.newColor
end