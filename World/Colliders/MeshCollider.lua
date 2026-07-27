local MeshCollider = {}

function MeshCollider.Create(vertices, indices)
	local self = Class.CreateInstance(Collider.Create(), MeshCollider)

	self._Vertices = vertices
	self._Indices = indices

	return self
end

function MeshCollider:SetCollider(collider)
	if Collider.SetCollider(self, collider) then
		if collider then
			local shape = lovr.physics.newMeshShape(self._Vertices, self._Indices)

			self.Shape = shape
			self._Collider:addShape(shape)
		end

		return true, collider
	end
end

function MeshCollider:GetVertices()
	return self._Vertices
end

function MeshCollider:GetIndices()
	return self._Indices
end

function MeshCollider:Destroy(destroyVertices)
	if not self._Destroyed then
		if destroyVertices and type(self._Vertices) ~= "table" then
			self._Vertices:release()
		end

		self._Vertices = nil
		self._Indices = nil

		Collider.Destroy(self)
	end
end

return Class.CreateClass(MeshCollider, "MeshCollider", Collider, scriptpath())