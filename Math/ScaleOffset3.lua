local ScaleOffset3 = {}

function ScaleOffset3.Create(scaleX, scaleY, scaleZ, offsetX, offsetY, offsetZ)
    local self = Class.CreateInstance(nil, ScaleOffset3)

    if type(scaleX) == "number" then
        self.Scale = Vector3.Create(scaleX, scaleY, scaleZ)
        self.Offset = Vector3.Create(offsetX, offsetY, offsetZ)
    else
        self.Scale = scaleX
        self.Offset = scaleY
    end

    return self
end

function ScaleOffset3.__eq(left, right)
	return left.Scale == right.Scale and left.Offset == right.Offset
end

function ScaleOffset3.__tostring(scaleOffset)
	return string.format("{S: %s, O: %s}", scaleOffset.Scale, scaleOffset.Offset)
end

Class.CreateClass(ScaleOffset3, "ScaleOffset3")

ScaleOffset3.Zero = ScaleOffset3.Create(Vector3.Zero, Vector3.Zero)

return ScaleOffset3