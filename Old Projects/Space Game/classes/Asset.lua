local Class = class.NewClass("Asset")
Class.Extenstion 	= "asset"
Class.AddToAssets 	= true
Class.Assets 		= {}

function Class:New(path)
	if path then
		if love.filesystem.exists(path) then
			if love.filesystem.isFile(path) then
				local extenstion = self:Type() == "Asset" and "" or self.Extenstion

				if Class.Assets[path .. "." .. extenstion] then
					return Class.Assets[path .. "." .. extenstion]
				else
					if love.filesystem.exists(path .. "." .. extenstion) then
						local file = io.open(path .. "." .. extenstion, "rb")
						if file then
							local content = file:read("*all")
							local data = json.decode(content)

							file:close()

							local asset = class.New(data.type)
							asset.path = data.path
							asset.type = data.type
							
							asset:LoadAsset(data)
							
							Class.Assets[path .. "." .. extenstion] = asset

							return asset
						end
					else
						local asset = {}
						asset["path"] = path
						asset["type"] = self:Type()

						self.path = path
						self.type = self:Type()

						self:NewAsset(path)
						self:Save()

						Class.Assets[path .. "." .. self.Extenstion] = self
					end
				end
			else
				print("attempted to create asset for '" .. self.path .. "' is directory")
				return nil
			end
		else
			print("attempted to create asset for '" .. self.path .. "' does not exist")
			return nil
		end
	end
end

function Class:Save()
	local asset = {}
	asset["path"] = self.path
	asset["type"] = self.type

	self:SaveAsset(asset)

	local data = json.encode(asset)

	local file = io.open(self.path .. "." .. self.Extenstion, "w+")
	if file then
		file:write(data)
		file:close()
	end
end

--virtual functions
function Class:LoadAsset(asset)
end

function Class:SaveAsset(asset)
end

