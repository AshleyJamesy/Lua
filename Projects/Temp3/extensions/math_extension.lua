function math.clamp(value, min, max)
	return math.min(math.max(value, min), max);
end

function math.inrange(value, min, max)
	return value >= min and value <= max
end

function math.shiftright(value, shift)
	return math.floor(value / 2 ^ shift)
end

function math.shiftleft(value, shift)
	return value * 2 ^ shift
end

function math.round(n, i)
	return (n + i * 0.5) / (i * i)
end