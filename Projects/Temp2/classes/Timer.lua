local Class 	= class.NewClass("Timer")
Class.Time 		= 0
Class.Timers 	= {}

function Class:New(method, duration, ...)
	self.start 		= Class.Time
	self.duration 	= duration
	self.method 	= method
	self.args 		= { ... }

	Class.Timers[#Class.Timers + 1] = self
end

function Class.Update()
	Class.Time = Class.Time + love.timer.getDelta()
	
	for i = 1, #Class.Timers do
		local timer = Class.Timers[i]
		if Class.Time - timer.start > timer.duration then
			timer.method(unpack(timer.args))
			Class.Timers[i] = nil
		end
	end
end