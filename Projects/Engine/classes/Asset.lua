local Class 	= class.NewClass("Asset")
Class:SetReference(false)

local Assets 	= {}

local function GenerateUniqueIdentifier()
	local template ='xxxxxxx-xxxx-xxxx-yxxx-xxxxxxxxxxxx'

	return string.gsub(template, '[xy]', 
		function (char)
			return string.format('%x', (char == 'x') and math.random(0, 0xf) or math.random(8, 0xb))
		end
	)
end

function Class:New(path, extension, loading)
	self.path = path

	if loading then
		return
	end

	if not path and not extension then
		return
	end

	return Asset.LoadAsset(self.path, self.extension, self:Type())
end

function Class:Serialise()
	local t = {}
	t.__type 					= "Asset"
	t.__properties 				= {}
	t.__properties.path 		= self.path
	t.__properties.extension 	= self.extension
	t.__properties.type 		= self:Type()

	return t
end

function Class:DeSerialise(value)
	if self:Type() == "Asset" then
		for k, v in pairs(value.__properties) do
			self[k] = v
		end
		
		return Asset.LoadAsset(self.path, self.extension, self.type)
	else
		for k, v in pairs(value.__properties) do
			self[k] = class.DeSerialise(v)
		end
	end
end

function Class:SaveAsset(extension)
	local extension = extension and extension or self.extension and self.extension or "json"

	local file = io.open(self.path .. "." .. extension, "w+")
	
	if file then
		file:write(json.string(class.Serialise(self)))
		file:close()
	end
end

function Class.LoadAsset(asset_path, extension, type)
	local extension = extension or "json"

	if Assets[asset_path] then
		return Assets[asset_path]
	end

	local filename, ext = GetFileDetails(asset_path .. "." .. extension)

	if extension == ext then

		local file = io.open(asset_path .. "." .. extension, "r")
		
		if file then
			local contents 	= file:read("*all")
			local metadata 	= json.parse(contents)
			local asset 	= class.DeSerialise(metadata, asset_path, extension, true)

			local status, err = pcall(asset.Load, asset, asset)
			if status then
				
			else
				print(err)
			end

			Assets[asset_path] = asset

			return asset
		else
			local asset = class.New(type, asset_path, extension, true)
			
			local status, err = pcall(asset.Load, asset)
			if status then
				asset:SaveAsset(extension)
			else
				print(err)
			end
			
			return asset
		end
	else
		print("unable to import '" .. asset_path .. " : " .. filename .. ", " .. ext)
	end

	return nil
end

function Class:Load()
	print("umm")
end

