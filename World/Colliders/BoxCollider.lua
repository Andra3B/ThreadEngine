local BoxCollider = {}

function BoxCollider.Create()
	local self = Class.CreateInstance(Collider.Create(), BoxCollider)

	self._Size = Vector3.Create(1, 1, 1)

	return self
end

function BoxCollider:SetCollider(collider)
	if Collider.SetCollider(self, collider) then
		if collider then
			local shape = lovr.physics.newBoxShape()

			self.Shape = shape
			self._Collider:addShape(shape)
		end

		return true, collider
	end
end

function BoxCollider:SetShape(shape)
	if Collider.SetShape(self, shape) then
		if shape then
			shape:setDimensions(self._Size:Unpack())
		end

		self._Shape = shape

		return true, shape
	end
end

function BoxCollider:GetSize()
	return self._Size
end

function BoxCollider:SetSize(size)
	if size ~= self._Size then
		if self._Shape then
			self._Shape:setDimensions(size:Unpack())
		end

		self._Size = size

		return true, size
	end
end

function BoxCollider:Destroy()
	if not self._Destroyed then
		self._Size = nil

		Collider.Destroy(self)
	end
end

return Class.CreateClass(BoxCollider, "BoxCollider", Collider, scriptpath())