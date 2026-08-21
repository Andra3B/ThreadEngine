local Mesh = {}

function Mesh.Create(mesh, aabb)
	local self = Class.CreateInstance(WorldObject.Create(), Mesh)
	
	self._Mesh = mesh

	self._Material = nil

	self._Skeleton = nil

	self._DoubleSided = false

	self._AABB = aabb

	return self
end

function Mesh:Draw(pass)
	if self._Mesh then
		local model = self:GetAncestorWithType("Model")

		if model then
			local skeleton = model:GetChildWithName(self._Skeleton)

			if skeleton then
				skeleton:SendToPass(pass)
			end
		end

		pass:setFaceCull(self._DoubleSided and "none" or "back")

		local material = self._Material or Thread.Materials.Default
		material:SendToPass(pass)

		pass:draw(self._Mesh, self.LovrTransform, 1)
	end
end

function Mesh:GetMesh()
	return self._Mesh
end

function Mesh:GetMaterial()
	return self._Material
end

function Mesh:SetMaterial(material)
	if material ~= self._Material then
		self._Material = material

		return true, material
	end
end

function Mesh:GetSkeleton()
	return self._Skeleton
end

function Mesh:SetSkeleton(skeleton)
	if skeleton ~= self._Skeleton then
		self._Skeleton = skeleton

		return true, skeleton
	end
end

function Mesh:GetDoubleSided()
	return self._DoubleSided
end

function Mesh:SetDoubleSided(doubleSided)
	if doubleSided ~= self._DoubleSided then
		self._DoubleSided = doubleSided

		return true, doubleSided
	end
end

function Mesh:GetAABB()
	return self._AABB
end

function Mesh:Destroy()
	if not self._Destroyed then
		self._Mesh:release()
		self._Mesh = nil

		self._Material = nil

		self._AABB = nil

		WorldObject.Destroy(self)
	end
end

return Class.CreateClass(Mesh, "Mesh", WorldObject, scriptpath())