local Extents3 = {}

function Extents3.Create(minX, minY, minZ, maxX, maxY, maxZ)
    local self = Class.CreateInstance(nil, Extents3)

    if type(minX) == "number" then
        self.Min = Vector3.Create(minX, minY, minZ)
        self.Max = Vector3.Create(maxX, maxY, maxZ)
    else
        self.Min = minX
        self.Max = minY
    end

    return self
end

function Extents3.__eq(left, right)
	return left.Min == right.Min and left.Max == right.Max
end

function Extents3.__tostring(extents)
	return string.format("{Min: %s, Max: %s}", extents.Min, extents.Max)
end

Class.CreateClass(Extents3, "Extents3")

Extents3.Zero = Extents3.Create(Vector3.Zero, Vector3.Zero)

return Extents3