local Class = class.NewClass("Agent")

local function raycast(x, y, dx, dy, m, func)
	world:rayCast(x, y, x + dx * m, y + dy * m, func)
end

local function draw_raycast(x, y, dx, dy, m)
	love.graphics.line(x, y, x + dx * m, y + dy * m)
end

function Class:New(x, y)
	self.angle 		= 0.0
	self.joystick 	= 0.0
	self.speed 		= 100.0

	self.radius 	= 15.0
	self.body 		= love.physics.newBody(world, x, y, "dynamic")
	self.shape 		= love.physics.newCircleShape(self.radius)
	self.fixture 	= love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData(self)
	self.fixture:setGroupIndex(-1)

	self.user 		= false
	self.input 		= 0.0

	self.active 	= false

	self.casts = {
		30.0,
		30.0,
		30.0,
		30.0,
		30.0
	}

	self.fitness = 0.0

	self.network = NeuralNetwork()
	self.network:NewLayer(5)
	self.network:NewLayer(4)
	self.network:NewLayer(1)

	self.network:SetWeightsRandom()
end

group = {}

function Class:OnEnterCollision(other)
	if other:getGroupIndex() ~= -1 then
		self.active = false

		self.body:setAwake(false)

		table.insert(group, 1, self)
	end
end

function Class:OnExitCollision(other)
	
end

function Class:RayCast(id, x, y, angle, magnitude)
	local direction = Vector2.Rotation(angle)
	direction:Normalise()

	self.casts[id] = magnitude - self.radius

	raycast(x, y, direction.x, direction.y, magnitude,
		function(fixture, fx, fy, xn, yn, fraction)
			if self.fixture == fixture then
				return 1
			end

			if fixture:getGroupIndex() == -1 then
				return 1
			end

			self.casts[id] = ((Vector2(fx, fy) - Vector2(x, y)):Magnitude() - self.radius)
			
			return 0
		end
	)

	--love.graphics.setColor(255, 255, 255, 255)
	--love.graphics.line(x, y, x + direction.x * magnitude, y + direction.y * magnitude)
end

function Class:Update()
	if self.active then
		self.network:SetInputs(unpack(self.casts))
		self.network:Forward()

		local x = 0.0

		if self.user then
			local joystick = 
				love.joystick.getJoysticks()[1]

			x = joystick:getAxis(4)
		else
			x = (self.network.output[1] - 0.5) / 0.5
		end

		if math.abs(x) > 0.05 then
			self.angle = 
				self.angle + x * Time.Delta * 5.0

			self.body:setAngle(self.angle)		
		end

		self.body:setLinearVelocity(math.sin(self.angle) * self.speed, -math.cos(self.angle) * self.speed)
	end
end

function Class:Render()
	local x, y 	= self.body:getPosition()
	local r 	= self.shape:getRadius()

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.circle("line", x, y, r)

	if self.active then
		self:RayCast(1, x, y, self.angle - math.rad(90.00), 40.0)
		self:RayCast(2, x, y, self.angle - math.rad(45.00), 40.0)
		self:RayCast(3, x, y, self.angle - math.rad(0.00), 40.0)
		self:RayCast(4, x, y, self.angle + math.rad(45.00), 40.0)
		self:RayCast(5, x, y, self.angle + math.rad(90.00), 40.0)

		local fitness = 0.0
		for k, v in pairs(self.casts) do
			fitness = fitness + v
		end

		self.fitness = 0.1 * (fitness / 5)
	end

	local direction = Vector2.Rotation(self.angle)
	direction:Normalise()

	love.graphics.line(x, y, x + direction.x * self.radius, y + direction.y * self.radius)
end