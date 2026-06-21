local InterfaceObject = {}

function InterfaceObject.Create()
	local self = Class.CreateInstance(Hierarchy.Create(), InterfaceObject)

	self._Position = ScaleOffset2.Zero
	self._Size = ScaleOffset2.Zero
    self._Angle = 0

	self._Transform = Class.NIL
    self._InverseTransform = Class.NIL

	self._Depth = 0
	self._Visible = true

	return self
end

function InterfaceObject:GetChildrenDrawOrder(root)
	root = root or self

	if #root._Children > 0 then
		local drawOrder = table.new(#root._Children, 0)

		for _, child in ipairs(root._Children) do
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
	else
		return table.empty
	end
end

function InterfaceObject:GetDrawOrder(root, drawOrder)
	root = root or self
	drawOrder = drawOrder or {}

	for _, child in ipairs(self:GetChildrenDrawOrder(root)) do
		table.insert(drawOrder, child)

		self:GetDrawOrder(child, drawOrder)
	end

	return drawOrder
end

function InterfaceObject:Draw(pass)
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

function InterfaceObject:GetAbsolutePosition()
	return self._Position.Offset
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

function InterfaceObject:GetAbsoluteSize()
	return self._Size.Offset
end

function Interface:GetAngle()
	return self._Angle
end

function Interface:SetAngle(angle)
	if angle ~= self._Angle then
		self._Angle = angle

		return true, angle
	end
end

function InterfaceObject:GetAbsoluteAngle()
    return self._AbsoluteAngle
end

--[[DependsOn: Position, Angle]]--
function Frame:GetTransform()
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

function Frame:SetTransform(transform)
	if transform ~= self._Transform then
		self._Transform = transform

		return true, transform
	end
end

--[[DependsOn: Transform]]--
function Frame:GetInverseTransform()
    if self._InverseTransform == Class.NIL then
        self._InverseTransform = self.Transform:Inverse()
    end

    return self._InverseTransform
end

function Frame:SetInverseTransform(inverse)
    if inverse ~= self._InverseTransform then
        self._InverseTransform = inverse

        return true, inverse
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

function InterfaceObject:IsVisible()
	return self._Visible
end

function InterfaceObject:SetVisible(visible)
	if visible ~= self._Visible then
		self._Visible = visible

		return true, visible
	end
end

function InterfaceObject:Destroy()
	if not self._Destroyed then
		self._Position = nil
		self._Size = nil

		self._Transform = nil
		self._InverseTransform = nil

		Hierarchy.Destroy(self)
	end
end

return Class.CreateClass(InterfaceObject, "InterfaceObject", Hierarchy, scriptpath())