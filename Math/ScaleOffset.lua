local ScaleOffset = {}

function ScaleOffset.Create(scale, offset)
    local self = Class.CreateInstance(nil, ScaleOffset)

    self.Scale = scale
    self.Offset = offset

    return self
end

function ScaleOffset.__eq(left, right)
	return left.Scale == right.Scale and left.Offset == right.Offset
end

function ScaleOffset.__tostring(scaleOffset)
	return string.format("{S: %.3f, O: %.3f}", scaleOffset.Scale, scaleOffset.Offset)
end

Class.CreateClass(ScaleOffset, "ScaleOffset")

ScaleOffset.Zero = ScaleOffset.Create(0, 0)

return ScaleOffset