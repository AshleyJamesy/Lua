local Class = class.NewClass("Time")

Class.delta 			= 0.0
Class.fixedTimeStep		= 0.3333
Class.elapsed			= 0.0
Class.timers 			= {}

function Class.Update()
	Class.delta = love.timer.getDelta()
	Class.elapsed = Class.elapsed + Class.delta
end

local Class = class.NewClass("Timer")

function Class:New(method, duration, ...)
	self.start 		= Time.elapsed
	self.duration 	= duration
	self.method 	= method
	self.args 		= { ... }

	Time.timers[#Class.Timers + 1] = self
end

function Class.Update()
	for i = 1, #Time.timers do
		local timer = Time.timers[i]
		if Time.elapsed - timer.start > timer.duration then
			timer.method(unpack(timer.args))
			Time.timers[i] = nil
		end
	end
end