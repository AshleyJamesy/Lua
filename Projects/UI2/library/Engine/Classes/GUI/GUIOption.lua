local Class = class.NewClass("GUIOption")

function Class.Option(option, value)
	return function(options)
		options[option] = value
	end
end

function Class.Width(value)
	return function(options)
		options.width = value
	end
end

function Class.Height(value)
	return function(options)
		options.height = value
	end
end

function Class.MinWidth(value)
	return function(options)
		options.width_min = value
	end
end

function Class.MaxWidth(value)
	return function(options)
		options.width_max = value
	end
end

function Class.MinHeight(value)
	return function(options)
		options.height_min = value
	end
end

function Class.MaxHeight(value)
	return function(options)
		options.height_max = value
	end
end

function Class.ExpandWidth(bool)
	return function(options)
		options.width_expand = bool
	end
end

function Class.ExpandHeight(bool)
	return function(options)
		options.height_expand = bool
	end
end

function Class.Padding(w, h)
	return function(options)
		options.padding_width 	= w
		options.padding_height 	= h
	end
end

function Class.PaddingWidth(value)
	return function(options)
		options.padding_width = value
	end
end

function Class.PaddingHeight(value)
	return function(options)
		options.padding_height = value
	end
end

function Class.Align(alignment)
	return function(options)
		options.align = alignment
	end
end

function Class.Draw(draw_func)
	return function(options)
		options.draw = draw_func
	end
end