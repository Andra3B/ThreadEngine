local WorldObject = {}

function WorldObject.Create()
	local self = Class.CreateInstance(Hierarchy.Create(), WorldObject)
	
	self._Position = Vector3.Zero
	self._AbsolutePosition = Class.NIL
	
	self._Size = Vector3.One
    self._AbsoluteSize = Class.NIL
	
	self._Orientation = Quaternion.One
    self._AbsoluteOrientation = Class.NIL

	self._Transform = Class.NIL
	self._InverseTransform = Class.NIL
	self._LovrTransform = Class.NIL
	self._LovrInverseTransform = Class.NIL

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

--[[DependsOn: Position]]--
function WorldObject:GetAbsolutePosition()
    if self._AbsolutePosition == Class.NIL then
        self._AbsolutePosition = self._Position
    end

    return self._AbsolutePosition
end

function WorldObject:SetAbsolutePosition(position)
	if position ~= self._AbsolutePosition then
		self._AbsolutePosition = position
		
		return true, position
	end
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

--[[DependsOn: Size]]--
function WorldObject:GetAbsoluteSize()
    if self._AbsoluteSize == Class.NIL then
        self._AbsoluteSize = self._Size
    end

    return self._AbsoluteSize
end

function WorldObject:SetAbsoluteSize(size)
	if size ~= self._AbsoluteSize then
		self._AbsoluteSize = size
		
		return true, size
	end
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

--[[DependsOn: Orientation]]--
function WorldObject:GetAbsoluteOrientation()
    if self._AbsoluteOrientation == Class.NIL then
        self._AbsoluteOrientation = self._Orientation
    end

    return self._AbsoluteOrientation
end

function WorldObject:SetAbsoluteOrientation(orientation)
	if orientation ~= self._AbsoluteOrientation then
		self._AbsoluteOrientation = orientation
		
		return true, orientation
	end
end

--[[DependsOn: AbsolutePosition, AbsoluteSize, AbsoluteOrientation]]--
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

--[[DependsOn: Transform]]--
function WorldObject:GetLovrTransform()
	if self._LovrTransform == Class.NIL then
		self._LovrTransform = lovr.math.newMat4(self.Transform:Unpack())
	end

	return self._LovrTransform
end

function WorldObject:SetLovrTransform(transform)
	if transform ~= self._LovrTransform then
		self._LovrTransform = transform

		return true, transform
	end
end

--[[DependsOn: InverseTransform]]--
function WorldObject:GetLovrInverseTransform()
	if self._LovrInverseTransform == Class.NIL then
		self._LovrInverseTransform = lovr.math.newMat4(self.InverseTransform:Unpack())
	end

	return self._LovrInverseTransform
end

function WorldObject:SetLovrInverseTransform(transform)
	if transform ~= self._LovrInverseTransform then
		self._LovrInverseTransform = transform

		return true, transform
	end
end

function WorldObject:Destroy()
	if not self._Destroyed then
		self._Position = nil
		self._AbsolutePosition = nil

		self._Size = nil
		self._AbsoluteSize = nil

		self._Orientation = nil
		self._AbsoluteOrientation = nil

		self._Transform = nil
		self._InverseTransform = nil
		self._LovrTransform = nil
		self._LovrInverseTransform = nil

		Hierarchy.Destroy(self)
	end
end

return Class.CreateClass(WorldObject, "WorldObject", Hierarchy, scriptpath())