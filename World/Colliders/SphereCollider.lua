local SphereCollider = {}

function SphereCollider.Create()
	local self = Class.CreateInstance(Collider.Create(), SphereCollider)

	self._Radius = 1

	return self
end

function SphereCollider:Refresh()
	local world = Collider.Refresh(self)

	if world then
		if not self._Shape then
			local shape = lovr.physics.newSphereShape()

			self._Collider:addShape(shape)
			self._Shape = shape
		end

		self._Shape:setRadius(self._Radius)
	end
end

function SphereCollider:SetCollider(collider)
	if Collider.SetCollider(self, collider) then
		if collider then
			local shape = lovr.physics.newSphereShape()

			self.Shape = shape
			self._Collider:addShape(shape)
		end

		return true, collider
	end
end

function SphereCollider:SetShape(shape)
	if Collider.SetShape(self, shape) then
		if shape then
			shape:setRadius(self._Radius)
		end

		self._Shape = shape

		return true, shape
	end
end

function SphereCollider:GetRadius()
	return self._Radius
end

function SphereCollider:SetRadius(radius)
	if size ~= self._Radius then
		if self._Shape then
			self._Shape:setRadius(radius)
		end

		self._Radius = radius

		return true, radius
	end
end

return Class.CreateClass(SphereCollider, "SphereCollider", Collider, scriptpath())