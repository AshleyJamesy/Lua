local Class 	= class.NewClass("Asset")
local Assets 	= {}

local AssetExenstion = "json"

local function GenerateUniqueIdentifier()
	local template ='xxxxxxx-xxxx-xxxx-yxxx-xxxxxxxxxxxx'

	return string.gsub(template, '[xy]', 
		function (char)
			return string.format('%x', (char == 'x') and math.random(0, 0xf) or math.random(8, 0xb))
		end
	)
end

function Class:New(path, loading)
	self.path = path

	if loading then
		return
	end
	
	return self:LoadAsset(path)
end

function Class:SaveAsset()
	local file = io.open(self.path .. "." .. AssetExenstion, "w+")

	if file then
		file:write(json.string(class.Serialise(self)))
		file:close()
	end
end

function Class:LoadAsset(asset_path)
	if Assets[asset_path] then
		return Assets[asset_path]
	end

	local filename, extenstion = GetFileDetails(asset_path .. "." .. AssetExenstion)

	if extenstion == AssetExenstion then
		local file = io.open(asset_path .. "." .. AssetExenstion, "r")
		
		if file then
			local contents 	= file:read("*all")
			local metadata 	= json.parse(contents)
			local asset 	= class.DeSerialise(metadata, asset_path, true)

			local status, err = pcall(asset.Load, asset, asset)
			if status then
				
			else
				print(err)
			end

			Assets[asset_path] = asset

			return asset
		else
			local asset = class.New(self:Type(), asset_path, true)
			
			local status, err = pcall(asset.Load, asset)
			if status then
				asset:SaveAsset()
			else
				print(err)
			end
			
			return asset
		end
	else
		print("unable to import asset '" .. asset_path .. "' - not an asset")
	end

	return nil
end

function Class:Load()

end

