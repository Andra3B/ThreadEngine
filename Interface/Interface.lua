local Interface = {}

function Interface.Create()
	local self = Class.CreateInstance(Hierarchy.Create(), Interface)

	self._AbsolutePosition = Vector3.Zero
	self._AbsoluteSize = Vector2.Zero

	self._Visible = true

	return self
end

function Interface:GetChildrenDrawOrder(root)
	root = root or self

	if #root._Children > 0 then
		local drawOrder = table.new(#root._Children, 0)

		for _, child in pairs(root._Children) do
			if child._Visible then
				local inserted = false

				for drawIndex, drawnChild in pairs(drawOrder) do
					if child.AbsolutePosition.Z < drawnChild.AbsolutePosition.Z then
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

function Interface:GetDrawOrder(root, drawOrder)
	root = root or self
	drawOrder = drawOrder or {}

	for _, child in ipairs(self:GetChildrenDrawOrder(root)) do
		table.insert(drawOrder, child)

		self:GetDrawOrder(child, drawOrder)
	end

	return drawOrder
end

function Interface:Update(deltaTime)

end

function Interface:Draw(pass)
	if self._Visible then
		for _, child in ipairs(self:GetDrawOrder()) do
			
		end
	end
end

function Interface:GetAbsolutePosition()
	return self._AbsolutePosition
end

function Interface:SetAbsolutePosition(position)
	if position ~= self._AbsolutePosition then
		self._AbsolutePosition = position

		return true, position
	end
end

function Interface:GetAbsoluteSize()
	return self._AbsoluteSize
end

function Interface:SetAbsoluteSize(size)
	if size ~= self._AbsoluteSize then
		self._AbsoluteSize = size

		return true, size
	end
end

function Interface:IsVisible()
	return self._Visible
end

function Interface:SetVisible(visible)
	if visible ~= self._Visible then
		self._Visible = visible

		return true, visible
	end
end

return Class.CreateClass(Interface, "Interface", Hierarchy)