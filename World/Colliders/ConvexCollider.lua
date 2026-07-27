local ConvexCollider = {}

function ConvexCollider.Create(points)
	local self = Class.CreateInstance(Collider.Create(), ConvexCollider)

	self._Points = points

	return self
end

function ConvexCollider:SetCollider(collider)
	if Collider.SetCollider(self, collider) then
		if collider then
			local shape = lovr.physics.newConvexShape(self._Points)

			self.Shape = shape
			self._Collider:addShape(shape)
		end

		return true, collider
	end
end

function ConvexCollider:GetPoints()
	return self._Points
end

function ConvexCollider:Destroy(destroyPoints)
	if not self._Destroyed then
		if destroyPoints and type(self._Points) ~= "table" then
			self._Points:release()
		end

		self._Points = nil

		Collider.Destroy(self)
	end
end

return Class.CreateClass(ConvexCollider, "ConvexCollider", Collider, scriptpath())