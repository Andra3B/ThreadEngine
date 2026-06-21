local WorldObject = {}

function WorldObject.Create()
	local self = Class.CreateInstance(Hierarchy.Create(), WorldObject)

	self._Position = Vector3.Zero
	self._Size = Vector3.One
	self._Orientation = Quaternion.One

	self._Transform = Class.NIL
	self._InverseTransform = Class.NIL

	return self
end

function WorldObject:GetPosition()
	return self._Position
end

function WorldObject:SetPosition(position)
	if position ~= self._Position then
		self._Position = position

		return true, position
	end
end

function WorldObject:GetAbsolutePosition()
	return self._Position
end

function WorldObject:GetSize()
	return self._Size
end

function WorldObject:SetSize(size)
	if size ~= self._Size then
		self._Size = size

		return true, size
	end
end

function WorldObject:GetAbsoluteSize()
	return self._Size
end

function WorldObject:GetOrientation()
	return self._Orientation
end

function WorldObject:SetOrientation(orientation)
	if orientation ~= self._Orientation then
		self._Orientation = orientation

		return true, orientation
	end
end

function WorldObject:GetAbsoluteOrientation()
	return self._Orientation
end

--[[DependsOn: Position, Size, Orientation]]--
function WorldObject:GetTransform()
	if self._Transform == Class.NIL then
		self._Transform = Matrix4.CreateTransform(
            self.AbsolutePosition,
            self.AbsoluteOrientation,
            self.AbsoluteSize,
            Vector3.Zero
        )
	end

	return self._Transform
end

function WorldObject:SetTransform(transform)
	if transform ~= self._Transform then
		self._Transform = transform

		return true, transform
	end
end

--[[DependsOn: Transform]]--
function WorldObject:GetInverseTransform()
    if self._InverseTransform == Class.NIL then
        self._InverseTransform = self.Transform:Inverse()
    end

    return self._InverseTransform
end

function WorldObject:SetInverseTransform(inverse)
    if inverse ~= self._InverseTransform then
        self._InverseTransform = inverse

        return true, inverse
    end
end

function WorldObject:Destroy()
	if not self._Destroyed then
		self._Position = nil
		self._Size = nil
		self._Orientation = nil

		self._Transform = nil
		self._InverseTransform = nil

		Hierarchy.Destroy(self)
	end
end

return Class.CreateClass(WorldObject, "WorldObject", Hierarchy)