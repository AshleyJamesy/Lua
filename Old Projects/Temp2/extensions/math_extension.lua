function math.clamp(value, min, max)
	return math.min(math.max(value, min), max);
end

function math.inRange(value, x, y)
	return value > x and value < y
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