local myState = {}

function myState:Initalise()
	self.resources = {}
	
	for i = 1, 1000 do 
		table.insert(self.resources, 1, "resources/engine/ui/A.png")
	end
	
	self.complete 	= false
	self.index 		= 1
	
	self.co = coroutine.create(function(resourceList, index)
		local output = {}
		
		while index < #resourceList + 1 do
			local filename = resourceList[index]
			
			output[filename] = 
				love.graphics.newImage(filename)
			
			resourceList, index = coroutine.yield(false, index + 1)
		end
		
		coroutine.yield(true, 1, output)
	end)
end

function myState:Update()

	if self.complete then
	else
		local status, complete, index, resources = coroutine.resume(self.co, self.resources, self.index)
		self.index = index

		if complete then
			self.complete = true

			self.a = resources

			print(self.a)		
		end
	end
end

function myState:Render()
	
end

return myState