local Class = class.NewClass("Player", "MonoBehaviour")

function Class:Awake()
	self.ridgidBody = self.gameObject:GetComponent("RigidBody")

	self.ridgidBody.angularDrag	= 0.0
end

function Class:Update()
	Camera.main.transform.position = Vector2.Lerp(Camera.main.transform.position, self.transform.globalPosition, Time.Delta)
	Camera.main.transform.rotation = Vector2.Lerp(Camera.main.transform.rotation, self.transform.globalRotation, Time.Delta)
	if self.ridgidBody then
		if love.keyboard.isDown("a") then
			self.ridgidBody:ApplyForceAtPosition(self.transform.right.x * -1 * self.ridgidBody.mass, self.transform.right.y * -1 * self.ridgidBody.mass, 
				self.transform.globalPosition.x + self.transform.up.x, self.transform.globalPosition.y + self.transform.up.y)

			self.ridgidBody:ApplyForceAtPosition(self.transform.right.x * 1 * self.ridgidBody.mass, self.transform.right.y * 1 * self.ridgidBody.mass, 
				self.transform.globalPosition.x - self.transform.up.x, self.transform.globalPosition.y - self.transform.up.y)
		end

		if love.keyboard.isDown("d") then
			self.ridgidBody:ApplyForceAtPosition(self.transform.right.x * 1 * self.ridgidBody.mass, self.transform.right.y * 1 * self.ridgidBody.mass, 
				self.transform.globalPosition.x + self.transform.up.x, self.transform.globalPosition.y + self.transform.up.y)

			self.ridgidBody:ApplyForceAtPosition(self.transform.right.x * -1 * self.ridgidBody.mass, self.transform.right.y * -1 * self.ridgidBody.mass, 
				self.transform.globalPosition.x - self.transform.up.x, self.transform.globalPosition.y - self.transform.up.y)
		end

		if love.keyboard.isDown("w") then
			self.ridgidBody:ApplyForce(self.transform.up.x * 100 * self.ridgidBody.mass, self.transform.up.y * 100 * self.ridgidBody.mass)
		end

		if love.keyboard.isDown("s") then
			self.ridgidBody:ApplyForce(self.transform.up.x * -100 * self.ridgidBody.mass, self.transform.up.y * -100 * self.ridgidBody.mass)
		end
	end

	if love.mouse.isDown(1) then
		local object = GameObject(Camera.main:ScreenToWorld(love.mouse.getX(), love.mouse.getY()))
		object:AddComponent("RigidBody")
		object:AddFixture(love.physics.newRectangleShape(0, 0, 50, 50, 0), 1)
	end
end

function Class:Render()
	love.graphics.line(self.transform.globalPosition.x, self.transform.globalPosition.y, 
		self.transform.globalPosition.x + self.transform.up.x  * 20, self.transform.globalPosition.y + self.transform.up.y * 20)

	love.graphics.line(self.transform.globalPosition.x, self.transform.globalPosition.y, 
		self.transform.globalPosition.x + self.transform.right.x  * 20, self.transform.globalPosition.y + self.transform.right.y * 20)
end