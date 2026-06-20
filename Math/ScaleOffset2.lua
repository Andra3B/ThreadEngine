local ScaleOffset2 = {}

function ScaleOffset2.Create(scaleX, scaleY, offsetX, offsetY)
    local self = Class.CreateInstance(nil, ScaleOffset2)

    if type(scaleX) == "number" then
        self.Scale = Vector2.Create(scaleX, scaleY)
        self.Offset = Vector2.Create(offsetX, offsetY)
    else
        self.Scale = scaleX
        self.Offset = scaleY
    end

    return self
end

function ScaleOffset2.__eq(left, right)
	return left.Scale == right.Scale and left.Offset == right.Offset
end

function ScaleOffset2.__tostring(scaleOffset)
	return string.format("{S: %s, O: %s}", scaleOffset.Scale, scaleOffset.Offset)
end

Class.CreateClass(ScaleOffset2, "ScaleOffset2")

ScaleOffset2.Zero = ScaleOffset2.Create(Vector2.Zero, Vector2.Zero)

return ScaleOffset2