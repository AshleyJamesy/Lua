local Class = class.NewClass("SpriteRenderer", "Renderer")

SpriteDrawMode = enum{
	"Simple", 	--Displays the full sprite.
	"Sliced",	--The SpriteRenderer will render the sprite as a 9-slice image where the corners will remain constant and the other sections will scale.
	"Tiled"		--The SpriteRenderer will render the sprite as a 9-slice image where the corners will remain constant and the other sections will tile.
}

function Class:New(gameObject)
	Class:Base().New(self, gameObject)

	self.colour 	= Colour(255,255,255,255)
	self.drawMode 	= SpriteDrawMode.None
	self.flipX 		= false
	self.flipY 		= false
	self.sprite 	= nil
end