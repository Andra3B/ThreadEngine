local InterfaceObject = {}

function InterfaceObject.Create()
	local self = Class.CreateInstance(Hierarchy.Create(), InterfaceObject)
	
	self._Position = ScaleOffset2.Zero
	self._AbsolutePosition = Class.NIL
	
	self._Size = ScaleOffset2.Zero
	self._AbsoluteSize = Class.NIL
	
	self._Angle = 0
	self._AbsoluteAngle = Class.NIL

	self._Origin = ScaleOffset2.Zero
	self._AbsoluteOrigin = Class.NIL

	self._ChildShift = ScaleOffset2.Zero
	self._AbsoluteChildShift = Class.NIL

	self._ChildExtents = Class.NIL

	self._Depth = 0

	self._Transform = Class.NIL
	self._InverseTransform = Class.NIL
	self._LovrTransform = Class.NIL
	self._LovrInverseTransform = Class.NIL

	return self
end

function InterfaceObject:GetChildrenDrawOrder()
	local drawOrder = table.new(#self._Children, 0)

	for _, child in ipairs(self._Children) do
		if child._Visible then
			local inserted = false

			for drawIndex, drawnChild in pairs(drawOrder) do
				if child._Depth > drawnChild._Depth then
					table.insert(drawOrder, drawIndex, child)

					inserted = true
					break
				end
			end

			if not inserted then
				table.insert(drawOrder, child)
			end
		end
	end

	return drawOrder
end

function InterfaceObject:GetDrawOrder(drawOrder)
	drawOrder = drawOrder or {}

	for _, child in ipairs(self:GetChildrenDrawOrder()) do
		table.insert(drawOrder, child)

		child:GetDrawOrder(drawOrder)
	end

	return drawOrder
end

function InterfaceObject:GetPosition()
	return self._Position
end

function InterfaceObject:SetPosition(position)
	if position ~= self._Position then
		self._Position = position

		return true, position
	end
end

--[[DependsOn: Parent, ParentAbsolutePosition, ParentAbsoluteSize, ParentAbsoluteAngle, Position, ParentAbsoluteChildShift, AbsoluteOrigin, Angle]]--
function InterfaceObject:GetAbsolutePosition()
	if self._AbsolutePosition == Class.NIL then
		if Class.IsA(self._Parent, "InterfaceObject") then
			self._AbsolutePosition = 
				self._Parent.AbsolutePosition +
				(self._Position.Offset + self._Parent.AbsoluteSize * self._Position.Scale + self._Parent.AbsoluteChildShift - self.AbsoluteOrigin:Rotate(self._Angle)):Rotate(self._Parent.AbsoluteAngle)
		else
			self._AbsolutePosition = self._Position.Offset - self.AbsoluteOrigin:Rotate(self._Angle)
		end
	end

	return self._AbsolutePosition
end

function InterfaceObject:SetAbsolutePosition(position)
	if position ~= self._AbsolutePosition then
		self._AbsolutePosition = position

		if position ~= Class.NIL then
			if Class.IsA(self._Parent, "InterfaceObject") then
				self.Position = ScaleOffset2.Create(
					self._Position.Scale,
					(position - self._Parent.AbsolutePosition):Rotate(-self._Parent.AbsoluteAngle) - self._Parent.AbsoluteSize * self._Position.Scale - self._Parent.AbsoluteChildShift + self.AbsoluteOrigin:Rotate(self._Angle)
				)
			else
				self.Position = ScaleOffset2.Create(
					self._Position.Scale,
					position + self.AbsoluteOrigin:Rotate(self._Angle)
				)
			end
		end
		
		return true, position
	end
end

function InterfaceObject:GetSize()
	return self._Size
end

function InterfaceObject:SetSize(size)
	if size ~= self._Size then
		self._Size = size

		return true, size
	end
end

--[[DependsOn: Parent, ParentAbsoluteSize, Size]]--
function InterfaceObject:GetAbsoluteSize()
	if self._AbsoluteSize == Class.NIL then
		if Class.IsA(self._Parent, "InterfaceObject") then
			self._AbsoluteSize = self._Size.Offset + self._Parent.AbsoluteSize * self._Size.Scale
		else
			self._AbsoluteSize = self._Size.Offset
		end
	end

	return self._AbsoluteSize
end

function InterfaceObject:SetAbsoluteSize(size)
	if size ~= self._AbsoluteSize then
		self._AbsoluteSize = size

		if size ~= Class.NIL then
			if Class.IsA(self._Parent, "InterfaceObject") then
				self.Size = ScaleOffset2.Create(
					self._Size.Scale,
					size - self._Parent.AbsoluteSize * self._Size.Scale
				)
			else
				self.Size = ScaleOffset2.Create(
					self._Size.Scale,
					size
				)
			end
		end
		
		return true, size
	end
end

function InterfaceObject:GetAngle()
	return self._Angle
end

function InterfaceObject:SetAngle(angle)
	if angle ~= self._Angle then
		self._Angle = angle

		return true, angle
	end
end

--[[DependsOn: Parent, ParentAbsoluteAngle, Angle]]--
function InterfaceObject:GetAbsoluteAngle()
	if self._AbsoluteAngle == Class.NIL then
		if Class.IsA(self._Parent, "InterfaceObject") then
			self._AbsoluteAngle = self._Parent.AbsoluteAngle + self._Angle
		else
			self._AbsoluteAngle = self._Angle
		end
	end

	return self._AbsoluteAngle
end

function InterfaceObject:SetAbsoluteAngle(angle)
	if angle ~= self._AbsoluteAngle then
		self._AbsoluteAngle = angle

		if angle ~= Class.NIL then
			if Class.IsA(self._Parent, "InterfaceObject") then
				self.Angle = angle - self._Parent.AbsoluteAngle
			else
				self.Angle = angle
			end
		end

		return true, angle
	end
end

function InterfaceObject:GetOrigin()
    return self._Origin
end

function InterfaceObject:SetOrigin(origin)
	if origin ~= self._Origin then
		self._Origin = origin

		return true, origin
	end
end

--[[DependsOn: AbsoluteSize, Origin]]--
function InterfaceObject:GetAbsoluteOrigin()
	if self._AbsoluteOrigin == Class.NIL then
		self._AbsoluteOrigin = self._Origin.Offset + self.AbsoluteSize * self._Origin.Scale
	end

    return self._AbsoluteOrigin
end

function InterfaceObject:SetAbsoluteOrigin(origin)
    if origin ~= self._AbsoluteOrigin then
        self._AbsoluteOrigin = origin

		if origin ~= Class.NIL then
			self.Origin = SizeOffset2.Create(
				self._Origin.Scale,
				origin - self.AbsoluteSize * self._Origin.Scale
			)
		end

        return true, origin
    end
end

function InterfaceObject:GetChildShift()
	return self._ChildShift
end

function InterfaceObject:SetChildShift(shift)
	if shift ~= self._ChildShift then
		self._ChildShift = shift

		return true, shift
	end
end

--[[DependsOn: ChildShift, AbsoluteSize]]--
function InterfaceObject:GetAbsoluteChildShift()
	if self._AbsoluteChildShift == Class.NIL then
		self._AbsoluteChildShift = self._ChildShift.Offset + self.AbsoluteSize * self._ChildShift.Scale
	end

	return self._AbsoluteChildShift
end

function InterfaceObject:SetAbsoluteChildShift(shift)
	if shift ~= self._AbsoluteChildShift then
		self._AbsoluteChildShift = shift

		if shift ~= Class.NIL then
			self.ChildShift = ScaleOffset2.Create(
				self._ChildShift.Scale,
				shift - self.AbsoluteSize * self._ChildShift.Scale
			)
		end	

		return true, offset
	end
end

-- Seperate function for future use
local function GetExtents(originPosition, originAngle, objects)
	if #objects > 0 then
		local minX, maxX, minY, maxY = math.huge, -math.huge, math.huge, -math.huge

		for _, object in ipairs(objects) do
			if Class.IsA(object, "InterfaceObject") then
				local xOffset = Vector2.Create(object.AbsoluteSize.X, 0):Rotate(object.AbsoluteAngle)
				local yOffset = Vector2.Create(0, object.AbsoluteSize.Y):Rotate(object.AbsoluteAngle)

				local topLeft = object.AbsolutePosition
				local topRight = topLeft + xOffset
				local bottomRight = topRight + yOffset
				local bottomLeft = topLeft + yOffset

				minX = math.min(minX, topLeft.X, topRight.X, bottomRight.X, bottomLeft.X)
				maxX = math.max(maxX, topLeft.X, topRight.X, bottomRight.X, bottomLeft.X)
				minY = math.min(minY, topLeft.Y, topRight.Y, bottomRight.Y, bottomLeft.Y)
				maxY = math.max(maxY, topLeft.Y, topRight.Y, bottomRight.Y, bottomLeft.Y)
			end
		end

		return Extents2.Create(
			(Vector2.Create(minX, minY) - originPosition):Rotate(-originAngle),
			(Vector2.Create(maxX, maxY) - originPosition):Rotate(-originAngle)
		)
	else
		return Extents2.Zero
	end
end

--[[DependsOn: ChildParent, ChildAbsolutePosition, ChildAbsoluteSize, ChildAbsoluteAngle, AbsolutePosition, AbsoluteAngle]]--
function InterfaceObject:GetChildExtents()
	if self._ChildExtents == Class.NIL then
		self._ChildExtents = GetExtents(self.AbsolutePosition, self.AbsoluteAngle, self._Children)
	end

	return self._ChildExtents
end

function InterfaceObject:SetChildExtents(extents)
	if extents ~= self._ChildExtents then
		self._ChildExtents = extents

		return true, extents
	end
end

function InterfaceObject:GetDepth()
	return self._Depth
end

function InterfaceObject:SetDepth(depth)
	if depth ~= self._Depth then
		self._Depth = depth

		return true, depth
	end
end

--[[DependsOn: AbsolutePosition, AbsoluteAngle, AbsoluteOrigin]]--
function InterfaceObject:GetTransform()
	if self._Transform == Class.NIL then
		self._Transform = Matrix4.CreateTransform(
            Vector3.Create(self.AbsolutePosition.X, self.AbsolutePosition.Y, 0),
            Vector3.Create(0, 0, self.AbsoluteAngle),
            Vector3.One,
            Vector3.Zero
        )
	end

	return self._Transform
end

function InterfaceObject:SetTransform(transform)
	if transform ~= self._Transform then
		self._Transform = transform

		if transform ~= Class.NIL then
			self.AbsolutePosition = Vector2.Create(transform.Position.X, transform.Position.Y)
			self.AbsoluteAngle = transform.Orientation:GetAngleAxis(true)
			self.Origin = ScaleOffset2.Zero
		end

		return true, transform
	end
end

--[[DependsOn: Transform]]--
function InterfaceObject:GetInverseTransform()
    if self._InverseTransform == Class.NIL then
        self._InverseTransform = self.Transform:Inverse()
    end

    return self._InverseTransform
end

function InterfaceObject:SetInverseTransform(inverse)
    if inverse ~= self._InverseTransform then
        self._InverseTransform = inverse

        return true, inverse
    end
end

--[[DependsOn: Transform]]--
function InterfaceObject:GetLovrTransform()
	if self._LovrTransform == Class.NIL then
		self._LovrTransform = lovr.math.newMat4(self.Transform:Unpack())
	end

	return self._LovrTransform
end

function InterfaceObject:SetLovrTransform(transform)
	if transform ~= self._LovrTransform then
		self._LovrTransform = transform

		return true, transform
	end
end

--[[DependsOn: InverseTransform]]--
function InterfaceObject:GetLovrInverseTransform()
	if self._LovrInverseTransform == Class.NIL then
		self._LovrInverseTransform = lovr.math.newMat4(self.InverseTransform:Unpack())
	end

	return self._LovrInverseTransform
end

function InterfaceObject:SetLovrInverseTransform(transform)
	if transform ~= self._LovrInverseTransform then
		self._LovrInverseTransform = transform

		return true, transform
	end
end

function InterfaceObject:Destroy()
	if not self._Destroyed then
		self._Position = nil
		self._AbsolutePosition = nil

		self._Size = nil
		self._AbsoluteSize = nil

		self._Origin = nil
		self._AbsoluteOrigin = nil

		self._ChildShift = nil
		self._AbsoluteChildShift = nil

		self._ChildExtents = nil

		self._Transform = nil
		self._InverseTransform = nil
		self._LovrTransform = nil
		self._LovrInverseTransform = nil

		Hierarchy.Destroy(self)
	end
end

return Class.CreateClass(InterfaceObject, "InterfaceObject", Hierarchy, scriptpath())