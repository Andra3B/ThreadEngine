local Body = {}

function Body.Create()
    local self = Class.CreateInstance(WorldNode.Create(), Body)

	self._Mesh = Thread.Meshes.Cube

    return self
end

function Body:Draw(pass)
	if self._Mesh then
		pass:draw(self._Mesh, self.LovrTransform, 1)
	end
end

function Body:GetMesh()
	return self._Mesh
end

function Body:SetMesh(mesh)
	if mesh ~= self._Mesh then
		self._Mesh = mesh

		return true, mesh
	end
end

function Body:Destroy()
    if not self._Destroyed then
		self._Mesh = nil

		WorldNode.Destroy(self)
	end
end

return Class.CreateClass(Body, "Body", WorldNode, scriptpath())