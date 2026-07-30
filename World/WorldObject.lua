local WorldObject = {}

function WorldObject.Create()
	local self = Class.CreateInstance(Hierarchy.Create(), WorldObject)
	
	self._Position = Vector3.Zero
	self._AbsolutePosition = Class.NIL
	
	self._Scale = Vector3.One
	self._AbsoluteScale = Class.NIL
	
	self._Orientation = Quaternion.One
	self._AbsoluteOrientation = Class.NIL

	self._Origin = ScaleOffset3.Zero
	self._AbsoluteOrigin = Class.NIL

	self._Forward = Class.NIL
	self._Right = Class.NIL
	self._Up = Class.NIL

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

--[[DependsOn: Parent, ParentAbsolutePosition, Position]]--
function WorldObject:GetAbsolutePosition()
	if self._AbsolutePosition == Class.NIL then
		if Class.IsA(self._Parent, "WorldObject") then
			self._AbsolutePosition = self._Parent.AbsolutePosition + self._Position
		else
			self._AbsolutePosition = self._Position
		end
	end

    return self._AbsolutePosition
end

function WorldObject:SetAbsolutePosition(position)
	if position ~= self._AbsolutePosition then
		self._AbsolutePosition = position

		if position ~= Class.NIL then
			if Class.IsA(self._Parent, "WorldObject") then
				self.Position = position - self._Parent.AbsolutePosition
			else
				self.Position = position
			end
		end
		
		return true, position
	end
end

function WorldObject:GetScale()
	return self._Scale
end

function WorldObject:SetScale(scale)
	if scale ~= self._Scale then
		self._Scale = scale

		return true, scale
	end
end

--[[DependsOn: Parent, ParentAbsoluteSize, Scale]]--
function WorldObject:GetAbsoluteScale()
	if self._AbsoluteScale == Class.NIL then
		if Class.IsA(self._Parent, "WorldObject") then
			self._AbsoluteScale = self._Parent.AbsoluteScale * self._Scale
		else
			self._AbsoluteScale = self._Scale
		end
	end

	return self._AbsoluteScale
end

function WorldObject:SetAbsoluteScale(scale)
	if scale ~= self._AbsoluteScale then
		self._AbsoluteScale = scale

		if scale ~= Class.NIL then
			if Class.IsA(self._Parent, "WorldObject") then
				self.Scale = scale / self._Parent.AbsoluteScale
			else
				self.Scale = scale
			end
		end
		
		return true, scale
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

--[[DependsOn: Parent, ParentAbsoluteOrientation, Orientation]]--
function WorldObject:GetAbsoluteOrientation()
	if self._AbsoluteOrientation == Class.NIL then
		if Class.IsA(self._Parent, "WorldObject") then
			self._AbsoluteOrientation = self._Orientation * self._Parent.AbsoluteOrientation
		else
			self._AbsoluteOrientation = self._Orientation
		end
	end

	return self._AbsoluteOrientation
end

function WorldObject:SetAbsoluteOrientation(orientation)
	if orientation ~= self._AbsoluteOrientation then
		self._AbsoluteOrientation = orientation

		if orientation ~= Class.NIL then
			if Class.IsA(self._Parent, "WorldObject") then
				self.Orientation = orientation / self._Parent.AbsoluteOrientation
			else
				self.Orientation = orientation
			end
		end
		
		return true, orientation
	end
end

function WorldObject:GetOrigin()
    return self._Origin
end

function WorldObject:SetOrigin(origin)
	if origin ~= self._Origin then
		self._Origin = origin

		return true, origin
	end
end

--[[DependsOn: Origin, AbsoluteSize]]--
function WorldObject:GetAbsoluteOrigin()
	if self._AbsoluteOrigin == Class.NIL then
		self._AbsoluteOrigin = self._Origin.Offset + self.AbsoluteScale * self._Origin.Scale
	end

    return self._AbsoluteOrigin
end

function WorldObject:SetAbsoluteOrigin(origin)
    if origin ~= self._AbsoluteOrigin then
        self._AbsoluteOrigin = origin

		self.Origin = ScaleOffset3.Create(self._Origin.Scale, origin - self.AbsoluteSize * self._Origin.Scale)

        return true, origin
    end
end

--[[DependsOn: AbsoluteOrientation]]--
function WorldObject:GetForward()
	if self._Forward == Class.NIL then
		self._Forward = Vector3.Forward:Rotate(self._AbsoluteOrientation)
	end

	return self._Forward
end

function WorldObject:SetForward(forward)
	if forward ~= self._Forward then
		self._Forward = forward

		return true, forward
	end
end

--[[DependsOn: AbsoluteOrientation]]--
function WorldObject:GetRight()
	if self._Right == Class.NIL then
		self._Right = Vector3.Right:Rotate(self._AbsoluteOrientation)
	end

	return self._Right
end

function WorldObject:SetRight(right)
	if right ~= self._Right then
		self._Right = right

		return true, right
	end
end

--[[DependsOn: AbsoluteOrientation]]--
function WorldObject:GetUp()
	if self._Up == Class.NIL then
		self._Up = Vector3.Up:Rotate(self._AbsoluteOrientation)
	end

	return self._Up
end

function WorldObject:SetUp(up)
	if up ~= self._Up then
		self._Up = up

		return true, up
	end
end

--[[DependsOn: AbsolutePosition, AbsoluteScale, AbsoluteOrientation, AbsoluteOrigin]]--
function WorldObject:GetTransform()
	if self._Transform == Class.NIL then
		self._Transform = Matrix4.CreateTransform(
            self.AbsolutePosition,
            self.AbsoluteOrientation,
            self.AbsoluteScale,
            self.AbsoluteOrigin
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

		self._Scale = nil
		self._AbsoluteScale = nil

		self._Orientation = nil
		self._AbsoluteOrientation = nil

		self._Origin = nil
		self._AbsoluteOrigin = nil

		self._Forward = nil
		self._Right = nil
		self._Up = nil

		self._Transform = nil
		self._InverseTransform = nil
		self._LovrTransform = nil
		self._LovrInverseTransform = nil

		Hierarchy.Destroy(self)
	end
end

return Class.CreateClass(WorldObject, "WorldObject", Hierarchy, scriptpath())