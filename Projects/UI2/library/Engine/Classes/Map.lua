local Class = class.NewClass("Map")

function Class:New()
	self.body 		= love.physics.newBody(world)
	self.objects 	= {}
end

function Class:Add(x, y)
	local object = {}
	object.x 		= x
	object.y 		= y
	object.shape 	= love.physics.newRectangleShape(object.x, object.y, 20, 20, 0)

	object.fixture 	= love.physics.newFixture(self.body, object.shape)

	table.insert(self.objects, 1, object)
end

function Class:Save(path)
	local data = {}
	for k, v in pairs(self.objects) do
		data[k] 	= {}
		data[k].x 	= v.x
		data[k].y 	= v.y
	end
 
 if love.system.getOS() == "Windows" then
     local file = io.open(path, "w+")
    	if file then
    		file:write(json.encode(data))
    		file:close()
    	end
	else
	    love.filesystem.write(path, json.encode(data))
	end
end

function Class:Load(path)
 local data, content = {}
 if love.system.getOS() == "Windows" then
	    local file 		= io.open(path, "rb")
	    if file then
		        content = file:read("*all")
		        file:close()
	    end
 else
    content = love.filesystem.read(path)
 end
 
 if content then
     data = json.decode(content)
     
     for k, v in pairs(data) do
         self:Add(v.x, v.y)
	    end
 end
end

function Class:Render()
	for k, v in ipairs(self.objects) do
		local shape_type = v.shape:getType()
		if shape_type == "polygon" then
			love.graphics.polygon("line", self.body:getWorldPoints(v.shape:getPoints()))
		end
	end
end