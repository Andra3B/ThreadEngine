local CompoundCollider = {}

function CompoundCollider.Create()
	local self = Class.CreateInstance(Collider.Create(), CompoundCollider)

	self._Colliders = {}

	return self
end

function CompoundCollider:Refresh()
	local world = Collider.Refresh(self)

	if world and not self._Shape then
		for _, collider in pairs(self._Colliders) do
			collider.Collider = self._Collider

			collider:Refresh()
		end
		
		self._Shape = true
	end
end

function CompoundCollider:GetColliders()
	return self._Colliders
end

function CompoundCollider:AddCollider(collider)
	local hasCollider = false

	for _, currentCollider in ipairs(self._Colliders) do
		if collider == currentCollider then
			hasCollider = true

			break
		end
	end

	if not hasCollider then
		collider.Body = self._Body

		table.insert(self._Colliders, collider)
	end
end

function CompoundCollider:RemoveCollider(collider)
	for index, currentCollider in ipairs(self._Colliders) do
		if collider == currentCollider then
			table.remove(self._Colliders, index)

			break
		end
	end
end

function CompoundCollider:Destroy(destroyColliders)
	if not self._Destroyed then
		if destroyColliders then
			while #self._Colliders > 0 do
				table.remove(self._Colliders):Destroy()
			end
		end

		self._Colliders = nil

		Collider.Destroy(self)
	end
end

return Class.CreateClass(CompoundCollider, "CompoundCollider", Collider, scriptpath())