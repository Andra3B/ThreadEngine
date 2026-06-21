local Body = {}

function Body.Create()
    local self = Class.CreateInstance(WorldNode.Create(), Body)

	self._Mesh = nil

    return self
end

function Body:Draw(pass)
	if self._Mesh then
		pass:send("WorldTransform", self.Transform.Components)
		pass:send("InverseWorldTransform", self.InverseTransform.Components)

		
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