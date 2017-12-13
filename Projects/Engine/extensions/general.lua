function fast_assert(condition, ...)
	if not condition then
		if getn(arg) > 0 then
			assert(condition, call(format, arg))
		else
			assert(condition)
		end
	end
end