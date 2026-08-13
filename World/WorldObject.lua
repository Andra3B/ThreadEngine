local WorldObject = {}

function WorldObject.Create()
	local self = Class.CreateInstance(Hierarchy.Create(), WorldObject)
	
	self._Position = Vector3.Zero
	
	self._Scale = Vector3.One
	
	self._Orientation = Quaternion.One

	self._Origin = Vector3.Zero

	self._Forward = Class.NIL
	self._Right = Class.NIL
	self._Up = Class.NIL

	self._Transform = Class.NIL
	self._LocalTransform = Class.NIL
	self._InverseTransform = Class.NIL
	self._InverseLocalTransform = Class.NIL
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

function WorldObject:GetScale()
	return self._Scale
end

function WorldObject:SetScale(scale)
	if scale ~= self._Scale then
		self._Scale = scale

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

function WorldObject:GetOrigin()
    return self._Origin
end

function WorldObject:SetOrigin(origin)
	if origin ~= self._Origin then
		self._Origin = origin

		return true, origin
	end
end

--[[DependsOn: Transform]]--
function WorldObject:GetForward()
	if self._Forward == Class.NIL then
		self._Forward = Vector3.Forward:Rotate(self.Transform.Orientation)
	end

	return self._Forward
end

function WorldObject:SetForward(forward)
	if forward ~= self._Forward then
		self._Forward = forward

		return true, forward
	end
end

--[[DependsOn: Transform]]--
function WorldObject:GetRight()
	if self._Right == Class.NIL then
		self._Right = Vector3.Right:Rotate(self.Transform.Orientation)
	end

	return self._Right
end

function WorldObject:SetRight(right)
	if right ~= self._Right then
		self._Right = right

		return true, right
	end
end

--[[DependsOn: Transform]]--
function WorldObject:GetUp()
	if self._Up == Class.NIL then
		self._Up = Vector3.Up:Rotate(self.Transform.Orientation)
	end

	return self._Up
end

function WorldObject:SetUp(up)
	if up ~= self._Up then
		self._Up = up

		return true, up
	end
end

--[[DependsOn: Position, Scale, Orientation, Origin]]--
function WorldObject:GetLocalTransform()
	if self._LocalTransform == Class.NIL then
		self._LocalTransform = Matrix4.CreateTransform(
			self._Position,
			self._Orientation,
			self._Scale,
			self._Origin
		)
	end

	return self._LocalTransform
end

function WorldObject:SetLocalTransform(transform)
	if transform ~= self._LocalTransform then
		self._LocalTransform = transform

		return true, transform
	end
end

--[[DependsOn: LocalTransform]]--
function WorldObject:GetInverseLocalTransform()
	if self._InverseLocalTransform == Class.NIL then
		self._InverseLocalTransform = self.LocalTransform:Inverse()
	end

	return self._InverseLocalTransform
end

function WorldObject:SetInverseLocalTransform(transform)
	if transform ~= self._InverseLocalTransform then
		self._InverseLocalTransform = transform

		return true, transform
	end
end

--[[DependsOn: Parent, ParentTransform, LocalTransform]]--
function WorldObject:GetTransform()
	if self._Transform == Class.NIL then
		if Class.IsA(self._Parent, "WorldObject") then
			self._Transform = self._Parent.Transform * self.LocalTransform
		else
			self._Transform = self.LocalTransform
		end
	end

	return self._Transform
end

function WorldObject:SetTransform(transform)
	if transform ~= self._Transform then
		self._Transform = transform

		if transform ~= Class.NIL then
			if Class.IsA(self._Parent, "WorldObject") then
				self.LocalTransform = self._Parent.InverseTransform * transform
			else
				self.LocalTransform = transform
			end
		end

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

		self._Scale = nil

		self._Orientation = nil

		self._Origin = nil

		self._Forward = nil
		self._Right = nil
		self._Up = nil

		self._Transform = nil
		self._LocalTransform = nil
		self._InverseTransform = nil
		self._InverseLocalTransform = nil
		self._LovrTransform = nil
		self._LovrInverseTransform = nil

		Hierarchy.Destroy(self)
	end
end

return Class.CreateClass(WorldObject, "WorldObject", Hierarchy, scriptpath())