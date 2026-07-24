local Body = {}

function Body.Create()
    local self = Class.CreateInstance(WorldNode.Create(), Body)

	self._Mesh = Thread.Meshes.Cube
	self._MeshParts = {}

	self._Material = nil

    return self
end

function Body:Draw(pass)
	if self._Mesh then
		if not self._Mesh.HasTangents then
			pass:setShader(Thread.Shaders.WorldNoTangents)
		end

		if #self._MeshParts > 0 then
			for _, partIndex in ipairs(self._MeshParts) do
				local mesh, material = self._Mesh:GetMesh(partIndex)
				
				if mesh then
					material = material or self._Material or Thread.DefaultMaterial

					material:SendToPass(pass)
					pass:draw(mesh, self.LovrTransform, 1)
				end
			end
		else
			if #self._Mesh.Parts > 0 then
				for partIndex = 1, #self._Mesh.Parts, 1 do
					local mesh, material = self._Mesh:GetMesh(partIndex)
					material = material or self._Material or Thread.DefaultMaterial

					material:SendToPass(pass)
					pass:draw(mesh, self.LovrTransform, 1)
				end
			else
				local material = self._Material or Thread.DefaultMaterial

				material:SendToPass(pass)
				pass:draw(self._Mesh.Mesh, self.LovrTransform, 1)
			end
		end
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

function Body:GetMeshParts()
	return self._MeshParts
end

function Body:SetMeshParts(parts)
	if parts ~= self._MeshParts then
		self._MeshParts = parts

		return true, parts
	end
end

function Body:GetMaterial()
	return self._Material
end

function Body:SetMaterial(material)
	if material ~= self._Material then
		self._Material = material

		return true, material
	end
end

function Body:Destroy()
    if not self._Destroyed then
		self._Mesh = nil
		self._MeshParts = nil

		self._Material = nil

		WorldNode.Destroy(self)
	end
end

return Class.CreateClass(Body, "Body", WorldNode, scriptpath())