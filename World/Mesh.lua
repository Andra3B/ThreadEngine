local Mesh = {}

Enum.DrawMode = Enum.Create({
	Points = "points",
	Lines = "lines",
	LineStrip = "linestrip",
	LineLoop = "lineloop",
	Strip = "strip",
	Triangles = "triangles",
	Fan = "fan"
})

function Mesh.Create(mesh)
	local self = Class.CreateInstance(Object.Create(), Mesh)

	self._Mesh = mesh

	self._HasTangents = false
	for _, vertexFormat in ipairs(mesh:getVertexFormat()) do
		if vertexFormat[1] == "VertexTangents" then
			self._HasTangents = true

			break
		end
	end


	self._Parts = {}

	return self
end

function Mesh:GetMesh(index)
	if index then
		local part = self._Parts[index]

		if part then
			self._Mesh:setDrawMode(part.DrawMode)
			self._Mesh:setDrawRange(part.RangeStart, part.RangeCount)

			return self._Mesh, part.Material
		end
	else
		self._Mesh:setDrawMode(Enum.DrawMode.Triangles)
		self._Mesh:setDrawRange()

		return self._Mesh
	end
end

function Mesh:GetHasTangents()
	return self._HasTangents
end

function Mesh:GetParts()
	return self._Parts
end

function Mesh:AddPart(material, drawMode, rangeStart, rangeCount)
	table.insert(self._Parts, {
		DrawMode = drawMode,
		RangeStart = rangeStart,
		RangeCount = rangeCount,
		Material = material
	})

	return #self._Parts
end

function Mesh:RemovePart(index)
	table.remove(self._Parts, index)
end

function Mesh:Destroy()
	if not self._Destroyed then
		self._Mesh:release()
		self._Mesh = nil

		table.erase(self._Parts, nil, true)
		self._Parts = nil

		Object.Destroy(self)
	end
end

return Class.CreateClass(Mesh, "Mesh", Object, scriptpath())