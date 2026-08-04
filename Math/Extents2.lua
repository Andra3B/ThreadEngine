local Extents2 = {}

function Extents2.Create(minX, minY, maxX, maxY)
    local self = Class.CreateInstance(nil, Extents2)

    if type(minX) == "number" then
        self.Min = Vector2.Create(minX, minY)
        self.Max = Vector2.Create(maxX, maxY)
    else
        self.Min = minX
        self.Max = minY
    end

    return self
end

function Extents2.__eq(left, right)
	return left.Min == right.Min and left.Max == right.Max
end

function Extents2.__tostring(extents)
	return string.format("{Min: %s, Max: %s}", extents.Min, extents.Max)
end

Class.CreateClass(Extents2, "Extents2")

Extents2.Zero = Extents2.Create(Vector2.Zero, Vector2.Zero)

return Extents2