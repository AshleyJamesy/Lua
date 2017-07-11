function tableRemove(t, v)
	for key,value in pairs(t) do
		if v == value then 
			table.remove(t, key)
		end
	end
end

math.randomseed(os.time())


player = {}
player.delay = 0.5
player.time = 0
player.x = love.graphics.getWidth() * 0.5
player.y = love.graphics.getHeight() * 0.9
player.radius = 12
player.vx = 0
player.vy = 0
player.speed = 100

player.draw = function(self)
	love.graphics.circle("fill",self.x,self.y,self.radius)
end

player.update = function(self, dt)
	if love.keyboard.isDown("d") then 
		self.vx = 100
	elseif love.keyboard.isDown("a") then 
		self.vx = -100
	else
		self.vx = 0
	end

	self.x = self.x + self.vx * dt
	self.y = self.y + self.vy * dt

	if self.time >= self.delay then
		bullet.create(self.x, self.y, self.vx, self.vy) 
		self.time = 0
	end
	self.time = self.time + dt
end

entities = {}
bullet = {}

bullet.create = function(x, y, vx, vy)
	local t = {}
	t.radius = 2
	t.draw = player.draw
	t.x = x
	t.y = y
	t.damage = 50
	t.vx = vx or 0
	t.vy = vy - 200
	t.update = bullet.update
	t.remove = bullet.remove
	t.collision = bullet.collision
	table.insert(entities, t)
	t.tag = "bullet"
	return t
end

bullet.update = function(self, dt)
	self.x = self.x + self.vx * dt
	self.y = self.y + self.vy * dt
	
	if self.y <= 0 then
		self:remove()
	end                         
end

bullet.remove = function(self)
	tableRemove(entities, self)
end

bullet.collision = function(self, e, key)
	if e.tag == "enemy" then
		e:damage(self.damage)
		self:remove(key)
	end
end

Enemy = {}
Enemy.create = function(x, y)
	local e = {}
	e.radius = 20
	e.draw = player.draw
	e.x = x
	e.y = y
	e.speed = math.random(20, 100)
	e.update = Enemy.update
	e.damage = Enemy.damage
	e.destroy = Enemy.destroy
	e.collision = Enemy.collision
	e.health = 200
	table.insert(entities, e)
	e.tag = "enemy"
	return e
end

Enemy.Manager = {}
Enemy.Manager.time = 0
Enemy.Manager.delay = 1
Enemy.Manager.update = function(self, dt)
	if self.time >= self.delay then
		Enemy.create(math.random() * love.graphics.getWidth(), 0)
		self.time = 0
	end
	self.time = self.time + dt
end 



Enemy.destroy = function(self)
	tableRemove(entities, self)
end

Enemy.damage = function(self, amount)
	self.health = self.health - amount

	if self.health <= 0 then
		self:destroy()
	end
end

Enemy.collision = function(self, b, key)

end

Enemy.update = function(self, dt, key)
	self.y = self.y + self.speed * dt 
end

function Distance(x,y,x2,y2)
	local xa = math.abs(x - x2)
	local ya = math.abs(y - y2)

	return math.sqrt(xa * xa + ya * ya) 
end

function checkCollisions()
	for i, obj1 in pairs(entities) do
		for j, obj2 in pairs(entities) do
			if obj1 == obj2 then 
			else
				local distance = Distance(obj1.x, obj1.y, obj2.x, obj2.y)
				if distance < obj1.radius + obj2.radius then
					obj1:collision(obj2, i)
					obj2:collision(obj1, j)
				end
			end
		end
	end	
end

function love.load()

end

function love.update(dt)
	Enemy.Manager:update(dt)
	player:update(dt)
	for key, bullet in pairs(entities) do
		bullet:update(dt, key)
	end
	checkCollisions()
end

function love.draw()
	player:draw()
	for key, value in pairs(entities) do
		value:draw()
	end
end
