include("extensions/")
include("util/")
include("classes/class")
include("classes/math/")
include("classes/")

class.Load()

include("source/")

local components = {}

function ComponentAdded(component)
	local type = component:Type()
	if components[type] then
	else
		components[type] = {}
	end

	table.insert(components[type], component)
end
hook.Add("ComponentAdded", "Scene.ComponentAdded", ComponentAdded)

local prefab = GameObject()
prefab:AddComponent("SpriteRenderer")
prefab:GetComponent("SpriteRenderer").colour:Set(255,0,0,255)
local s = prefab:Serialise()

for i = 1, 100 do
	local g = GameObject.Instantiate(s)
	g:Initalise()
end

print(json.encode(s))

function love.load()

end

function love.update(dt)

end

function love.draw()
	for name, batch in pairs(components) do
		for id, component in pairs(batch) do
			if component.Render then
				love.graphics.setColor(255,255,255,255)
				component:Render()
			else
				break
			end
		end
	end
end