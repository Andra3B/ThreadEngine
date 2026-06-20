local InterfaceObject = {}

function InterfaceObject.Create()
	local self = Class.CreateInstance(Hierarchy.Create(), InterfaceObject)

	self._AbsolutePosition = Vector2.Zero
	self._AbsoluteSize = Vector2.Zero

    self._Angle = 0
    self._AbsoluteAngle = 0

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

function InterfaceObject:GetAbsolutePosition()
	return self._AbsolutePosition
end

function InterfaceObject:SetAbsolutePosition(position)
	if position ~= self._AbsolutePosition then
		self._AbsolutePosition = position

		return true, position
	end
end

function InterfaceObject:GetAbsoluteSize()
	return self._AbsoluteSize
end

function InterfaceObject:SetAbsoluteSize(size)
	if size ~= self._AbsoluteSize then
		self._AbsoluteSize = size

		return true, size
	end
end

function InterfaceObject:GetAbsoluteAngle()
    return self._AbsoluteAngle
end

function InterfaceObject:SetAbsoluteAngle(angle)
    if angle ~= self._AbsoluteAngle then
        self._AbsoluteAngle = angle

        return true, angle
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
		self._AbsolutePosition = nil
		self._AbsoluteSize = nil

		Hierarchy.Destroy(self)
	end
end

return Class.CreateClass(InterfaceObject, "InterfaceObject", Hierarchy)