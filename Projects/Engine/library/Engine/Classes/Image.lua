local Class = class.NewClass("Image")
Class.Images = {}

function Class:New(path)
    if Class.Images[path] then 
        return Class.Images[path]
    end
    
	self.source = love.graphics.newImage(GetProjectDirectory() .. path)
	self.source:setFilter("nearest", "nearest")
	
	self.width 	= self.source:getWidth()
	self.height = self.source:getHeight()
	
	local w, h = self.width * 0.33, self.height * 0.33
	
	local vertices = {
	    { w * 0.0, h * 0.0, 0.00, 0.00 },
	    { w * 1.0, h * 0.0, 0.33, 0.00 },
	    { w * 2.0, h * 0.0, 0.66, 0.00 },
	    { w * 3.0, h * 0.0, 1.00, 0.00 },
	    
	    { w * 0.0, h * 1.0, 0.00, 0.33 },
	    { w * 1.0, h * 1.0, 0.33, 0.33 },
	    { w * 2.0, h * 1.0, 0.66, 0.33 },
	    { w * 3.0, h * 1.0, 1.00, 0.33 },
	    
	    { w * 0.0, h * 2.0, 0.00, 0.66 },
	    { w * 1.0, h * 2.0, 0.33, 0.66 },
	    { w * 2.0, h * 2.0, 0.66, 0.66 },
	    { w * 3.0, h * 2.0, 1.00, 0.66 },
	    
	    { w * 0.0, h * 3.0, 0.00, 1.00 },
	    { w * 1.0, h * 3.0, 0.33, 1.00 },
	    { w * 2.0, h * 3.0, 0.66, 1.00 },
	    { w * 3.0, h * 3.0, 1.00, 1.00 }
	}
	self.mesh = love.graphics.newMesh(vertices, "triangles")
	self.mesh:setVertexMap(
	    1, 5, 6, 
	    1, 6, 2,
	    2, 6, 7, 
	    2, 7, 3,
	    3, 7, 8, 
	    3, 8, 4, 
	    5, 9, 10, 
	    5, 10, 6, 
	    6, 10, 11, 
	    6, 11, 7, 
	    7, 11, 12, 
	    7, 12, 8, 
	    9, 13, 14, 
	    9, 14, 10, 
	    10, 14, 15, 
	    10, 15, 11, 
	    11, 15, 16, 
	    11, 16, 12
	)
	
	self.mesh:setTexture(self.source)
	
	Class.Images[path] = self
end

function Class:Render(x, y, w, h)
	local aspectx = self.width / w 
	local aspecty = self.height / h

	local aw = w * 0.3333333 * aspectx
	local ah = h * 0.3333333 * aspecty
	local a  = w - aw
	local b  = h - ah

	self.mesh:setVertexAttribute(1, 1, 0.00, 0.00)
    self.mesh:setVertexAttribute(2, 1, aw, 0.00)
    self.mesh:setVertexAttribute(3, 1, a, 0.00)
    self.mesh:setVertexAttribute(4, 1, w, 0.00)

    self.mesh:setVertexAttribute(5, 1, 0.00, aw)
    self.mesh:setVertexAttribute(6, 1, aw, aw)
    self.mesh:setVertexAttribute(7, 1, a, aw)
    self.mesh:setVertexAttribute(8, 1, w, aw)

    self.mesh:setVertexAttribute(9,  1, 0.00, b)
    self.mesh:setVertexAttribute(10, 1, aw, b)
    self.mesh:setVertexAttribute(11, 1, a, b)
    self.mesh:setVertexAttribute(12, 1, w, b)

    self.mesh:setVertexAttribute(13, 1, 0.00, h)
    self.mesh:setVertexAttribute(14, 1, aw, h)
    self.mesh:setVertexAttribute(15, 1, a, h)
    self.mesh:setVertexAttribute(16, 1, w, h)

    graphics.draw(self.mesh, x, y, 0, 3.0, 3.0)
end






