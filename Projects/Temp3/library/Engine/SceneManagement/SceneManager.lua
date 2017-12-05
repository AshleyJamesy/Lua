local Class = class.NewClass("SceneManager")
Class.scenes 		= {}
Class.sceneCount 	= 0
Class.activeScene 	= nil

--Events
Class.activeSceneChanged 	= hook.CreateHookTable()
Class.sceneLoaded 			= hook.CreateHookTable()
Class.sceneUnLoaded 		= hook.CreateHookTable()

OpenSceneMode = enum{
	"Single", 					--Closes all current open scenes and loads a scene.
	"Additive", 				--Adds a scene to the current open scenes and loads it.
	"AdditiveWithoutLoading" 	--Adds a scene to the current open scenes without loading it. It will show up as 'unloaded' in the Hierarchy Window.
}

function Class:CreateScene(name)
	return Scene(name)
end

--The currently active Scene is the Scene which will be used as the target for new GameObjects instantiated by scripts
function Class:GetActiveScene()
	if self.activeScene == nil then
		self.activeScene = Scene("scene")
	end
	
	return self.activeScene
end

function Class:GetSceneAt(index)
	return self.scenes[index]
end

function Class:GetSceneByName(name)
	for k, v in pairs(self.scenes) do
		if v.name == name then 
			return v
		end
	end
end

--You can only move root GameObjects from one Scene to another. This means the GameObject to move must not be a child of any other GameObject in its Scene
function Class:MoveGameObjectToScene(gameObject, scene)

end

function Class:SetActiveScene(scene)

end