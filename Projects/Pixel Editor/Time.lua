include("class")

local Class, BaseClass = class.NewClass("Time")
Time = Class

Time.delta            = 0.0
Time.fixedTimeStep    = 0.3333
Time.elapsed          = 0.0