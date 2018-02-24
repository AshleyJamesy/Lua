local Class = class.NewClass("GUIStyle")

function Class:New(...)
	for k, v in pairs({ ... }) do
		v(self)
	end
end

function Class:Set(func)
	func(self)
end

function Class:Use(options)
	for k, v in pairs(self) do
		if k ~= "style" then
			if type(v) == "table" then
				for i, j in pairs(v) do
					options[k][i] = j
				end
			else
				options[k] = v
			end
		end
	end
end