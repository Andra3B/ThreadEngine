local Mesh = {}

function Mesh.Create(mesh)
	local self = Class.CreateInstance(Object.Create(), Mesh)
	
	self._Submeshes = {}

	return self
end

function Mesh:GetSubmeshes()
	return self._Submeshes
end

function Mesh:AddSubmesh(submesh)
	for _, currentSubmesh in ipairs(self._Submeshes) do
		if submesh == currentSubmesh then
			return
		end
	end

	table.insert(self._Submeshes, submesh)
end

function Mesh:RemoveSubmesh(submesh)
	for index, currentSubmesh in ipairs(self._Submeshes) do
		if submesh == currentSubmesh then
			table.remove(self._Submeshes, index)

			return
		end
	end
end

function Mesh:Destroy()
	if not self._Destroyed then
		table.erase(self._Submeshes, Submesh.Destroy)
		self._Submeshes = nil

		Object.Destroy(self)
	end
end

return Class.CreateClass(Mesh, "Mesh", Object, scriptpath())