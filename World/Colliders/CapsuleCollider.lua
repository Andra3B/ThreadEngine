local CapsuleCollider = {}

function CapsuleCollider.Create()
	local self = Class.CreateInstance(Collider.Create(), CapsuleCollider)

	self._Radius = 1
	self._Length = 1

	return self
end

function CapsuleCollider:SetCollider(collider)
	if Collider.SetCollider(self, collider) then
		if collider then
			local shape = lovr.physics.newCapsuleShape()

			self.Shape = shape
			self._Collider:addShape(shape)
		end

		return true, collider
	end
end

function CapsuleCollider:SetShape(shape)
	if Collider.SetShape(self, shape) then
		if shape then
			shape:setRadius(self._Radius)
			shape:setLength(self._Length)
		end

		self._Shape = shape

		return true, shape
	end
end

function CapsuleCollider:GetRadius()
	return self._Radius
end

function CapsuleCollider:SetRadius(radius)
	if radius ~= self._Radius then
		if self._Shape then
			self._Shape:setRadius(radius)
		end

		self._Radius = radius

		return true, radius
	end
end

function CapsuleCollider:GetLength()
	return self._Length
end

function CapsuleCollider:SetLength(length)
	if length ~= self._Length then
		if self._Shape then
			self._Shape:setLength(length)
		end

		self._Length = length

		return true, length
	end
end

return Class.CreateClass(CapsuleCollider, "CapsuleCollider", Collider, scriptpath())