local ScaleOffset4 = {}

function ScaleOffset4.Create(scaleX, scaleY, scaleZ, scaleW, offsetX, offsetY, offsetZ, offsetW)
    local self = Class.CreateInstance(nil, ScaleOffset4)

    if type(scaleX) == "number" then
        self.Scale = Vector4.Create(scaleX, scaleY, scaleZ, scaleW)
        self.Offset = Vector4.Create(offsetX, offsetY, offsetZ, offsetW)
    else
        self.Scale = scaleX
        self.Offset = scaleY
    end

    return self
end

function ScaleOffset4.__eq(left, right)
	return left.Scale == right.Scale and left.Offset == right.Offset
end

function ScaleOffset4.__tostring(scaleOffset)
	return string.format("{S: %s, O: %s}", scaleOffset.Scale, scaleOffset.Offset)
end

Class.CreateClass(ScaleOffset4, "ScaleOffset4")

ScaleOffset4.Zero = ScaleOffset4.Create(Vector4.Zero, Vector4.Zero)

return ScaleOffset4