local Class = class.NewClass("Ship", "MonoBehaviour")

function Class:New(gameObject)
    Class:Base().New(self, gameObject)
    
    self.rigidBody = nil
    self.colliders = {
        
    }
    
    self.triggers = {
        
    }
    
    self.structure = {
    	
    }
end