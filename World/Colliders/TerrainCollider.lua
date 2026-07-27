local TerrainCollider = {}

function TerrainCollider.Create(size, resolution, heightMapCallback)
	local self = Class.CreateInstance(Collider.Create(), TerrainCollider)

	self._Size = size
	self._Resolution = resolution
	self._HeightMapCallback = heightMapCallback

	return self
end

function TerrainCollider:Refresh()
	local world = Collider.Refresh(self)

	if world and not self._Shape then
		local shape = lovr.physics.newTerrainShape(
			self._Size,
			self._HeightMapCallback,
			self._Size / self._Resolution
		)

		self._Collider:addShape(shape)
		self._Shape = shape
	end
end

function TerrainCollider:SetCollider(collider)
	if Collider.SetCollider(self, collider) then
		if collider then
			local shape = lovr.physics.newTerrainShape(
				self._Size,
				self._HeightMapCallback,
				self._Size / self._Resolution
			)

			self.Shape = shape
			self._Collider:addShape(shape)
		end

		return true, collider
	end
end

function TerrainCollider:GetSize()
	return self._Size
end

function TerrainCollider:GetResolution()
	return self._Resolution
end

function TerrainCollider:GetHeightMapCallback()
	return self._HeightMapCallback
end

function TerrainCollider:Destroy()
	if not self._Destroyed then
		self._HeightMapCallback()
		self._HeightMapCallback = nil

		Collider.Destroy(self)
	end
end

return Class.CreateClass(TerrainCollider, "TerrainCollider", Collider, scriptpath())