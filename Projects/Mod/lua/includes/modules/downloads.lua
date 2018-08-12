module("downloads", package.seeall)

local Content = {}

function AddContentType(name)
	Content[name] = {}
end

function GetContentListByType(name)
	return Content[name]
end

function GetContentByType(name, path)
	if Content[name] then
		return Content[name][path]
	end
end

function RemoveContentType(name)
	Content[name] = nil
end

function ClearByType(name)
	if Content[name] then
		Content[name] = {}
	end
end

function ClearAllContent()
	for k, v in pairs(Content) do
		Content[name] = {}
	end
end

function AddContentByType(name, path, data)
	if Content[name] then
		print("adding downloadable content: '" .. path .. "'")
		
		local content = {
			path = path,
			data = data
		}
		
		table.insert(Content[name], #Content[name], content)
	end
end

function RemoveContentByType(name, path)
	if Content[name] then
		if not Content[name][path] then
			Content[name][path] = nil
		end
	end
end

AddContentType("scripts")
AddContentType("images")
AddContentType("sounds")