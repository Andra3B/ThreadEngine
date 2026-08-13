local Submesh = {}

function Submesh.Create(mesh)
	local self = Class.CreateInstance(Object.Create(), Submesh)

	self._Mesh = mesh
	self._Material = nil

	self._DoubleSided = false

	self._HasTangents = false

	for _, vertexFormat in ipairs(mesh:getVertexFormat()) do
		if vertexFormat[1] == "VertexTangents" then
			self._HasTangents = true

			break
		end
	end

	return self
end

function Submesh:GetMesh()
	return self._Mesh
end

function Submesh:GetMaterial()
	return self._Material
end

function Submesh:SetMaterial(material)
	if material ~= self._Material then
		self._Material = material

		return true, material
	end
end

function Submesh:IsDoubleSided()
	return self._DoubleSided
end

function Submesh:SetDoubleSided(doubleSided)
	if doubleSided ~= self._DoubleSided then
		self._DoubleSided = doubleSided

		return true, doubleSided
	end
end

function Submesh:GetHasTangents()
	return self._HasTangents
end

function Submesh:Destroy()
	if not self._Destroyed then
		self._Mesh:release()
		self._Mesh = nil

		self._Material = nil

		Object.Destroy(self)
	end
end

return Class.CreateClass(Submesh, "Submesh", Object)