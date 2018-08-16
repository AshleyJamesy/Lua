module("timer", package.seeall)

local timers = {}
local index = 0

function Create(identifier, delay, repetitions, func)
    timers[identifier] = {
    	   active     = true,
    	   time       = delay,
        delay      = delay,
        iterations = repetitions,
        max        = repetitions,
        callback   = func,
        loop       = repetitions == 0
    }
end

function Simple(delay, func)
    index = index + 1
    
    timers[index] = {
    	   active     = true,
    	   time       = delay,
        delay      = delay,
        iterations = 1,
        max        = 1,
        callback   = func,
        loop       = false
    }
end

function Stop(identifier)
    if timers[identifier] then
        timers[identifier].active       = false
        timers[identifier].time         = timers[identifier].delay
        timers[identifier].iterations   = timers[identifier].max
    end
end

function Toggle(identifier)
    if timers[identifier] then
        timers[identifier].active = not timers[identifier].active
    end
end

function Exists(identifier)
    return timers[identifier] ~= nil
end

function Pause(identifier)
    if timers[identifier] then
        timers[identifier].active = false
    end
end

function UnPause(identifier)
    if timers[identifier] then
        timers[identifier].active = true
    end
end

function Update()
    local deduct = time.FixedTimeStep * 1000
    for k, timer in pairs(timers) do
        if timer.active then
        timer.time = timer.time  - deduct
        
        if timer.time <= 0 then
            timer.callback(timer.max - timer.iterations + 1)
            
            if timer.loop then
                timer.time = timer.delay + timer.time
            else
                timer.iterations = timer.iterations - 1
                
                if timer.iterations < 1 then
                    timers[k] = nil
                else
                    timer.time = timer.delay
                end
            end
        end
        end
    end
end