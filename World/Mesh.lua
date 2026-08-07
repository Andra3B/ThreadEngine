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

local function CreateFromFile(path)
	local modelData = lovr.data.newModelData(path)

	if modelData then
		local meshes = {}
		local materials = {}

		for meshIndex = 1, modelData:getMeshCount(), 1 do
			local meshFormat = nil
						
			local hasTangents = false

			local vertexCount = modelData:getMeshVertexCount(meshIndex)
			local vertices = table.new(0, vertexCount)

			for vertexIndex = 1, vertexCount, 1 do
				local x, y, z, normalX, normalY, normalZ, u, v, u2, v2, r, g, b, a, tangentX, tangentY, tangentZ = modelData:getMeshVertex(meshIndex, vertexIndex)

				if not meshFormat then
					meshFormat = {
						{name = "VertexPosition", type = "vec3"},
						{name = "VertexUV", type = "vec2"},
						{name = "VertexUV2", type = "vec2"},
						{name = "VertexColor", type = "vec4"},
						{name = "VertexNormal", type = "vec3"}
					}

					hasTangents = tangentX^2 + tangentY^2 + tangentZ^2 > 0
					if hasTangents then
						table.insert(meshFormat, {name = "VertexTangent", type = "vec3"})
					end
				end

				local vertex = {
					x, y, z,
					u, v,
					u2, v2,
					r / 255, g / 255, b / 255, a / 255,
					normalX, normalY, normalZ
				}

				if hasTangents then
					table.insert(vertex, tangentX)
					table.insert(vertex, tangentY)
					table.insert(vertex, tangentZ)
				end

				table.insert(vertices, vertex)
			end

			local indexCount = modelData:getMeshIndexCount(meshIndex)
			local indicies = nil

			if indexCount > 0 then
				indicies = table.new(0, indexCount)

				for indexIndex = 1, indexCount, 1 do
					table.insert(indicies, modelData:getMeshIndex(meshIndex, indexIndex))
				end
			end

			local mesh = lovr.graphics.newMesh(
				meshFormat,
				vertices,
				{storage = "gpu"}
			)

			mesh:setIndices(indicies)

			mesh = Mesh.Create(mesh)

			for partIndex = 1, modelData:getMeshPartCount(meshIndex), 1 do
				local materialIndex = modelData:getMeshMaterial(meshIndex, partIndex)
				local material = nil

				if materialIndex then
					if materials[materialIndex] then
						material = materials[materialIndex]
					else
						local rawMaterial = modelData:getMaterial(materialIndex)

						material = Material.Create()

						material.Name = modelData:getMaterialName(materialIndex) or "Material"..materialIndex

						material.Colour = Vector4.Create(unpack(rawMaterial.color))
						material.ColourTexture = rawMaterial.texture and lovr.graphics.newTexture(rawMaterial.texture, {
							type = "2d",
							format = "rgba8",
							linear = false,
							mipmaps = true,
							usage = {"sample"}
						}) or nil

						material.Glow = Vector4.Create(unpack(rawMaterial.glow))
						material.GlowTexture = rawMaterial.glowTexture and lovr.graphics.newTexture(rawMaterial.glowTexture, {
							type = "2d",
							format = "rgba8",
							linear = false,
							mipmaps = true,
							usage = {"sample"}
						}) or nil

						material.Metalness = rawMaterial.metalness
						material.MetalnessTexture = rawMaterial.metalnessTexture and lovr.graphics.newTexture(rawMaterial.metalnessTexture, {
							type = "2d",
							format = "rgba8",
							linear = true,
							mipmaps = true,
							usage = {"sample"}
						}) or nil

						material.Roughness = rawMaterial.roughness
						if rawMaterial.roughnessTexture then
							material.RoughnessTexture =
								rawMaterial.roughnessTexture == rawMaterial.metalnessTexture and material.MetalnessTexture or lovr.graphics.newTexture(rawMaterial.roughnessTexture, {
									type = "2d",
									format = "rgba8",
									linear = true,
									mipmaps = true,
									usage = {"sample"}
								}) or nil
						end

						material.NormalScale = rawMaterial.normalScale
						material.NormalTexture = rawMaterial.normalTexture and lovr.graphics.newTexture(rawMaterial.normalTexture, {
							type = "2d",
							format = "rgba8",
							linear = true,
							mipmaps = true,
							usage = {"sample"}
						}) or nil

						material.OcclusionStrength = rawMaterial.occlusionStrength
						if rawMaterial.occlusionTexture then
							material.OcclusionTexture = rawMaterial.occlusionTexture == rawMaterial.metalnessTexture and material.MetalnessTexture or lovr.graphics.newTexture(rawMaterial.occlusionTexture, {
								type = "2d",
								format = "rgba8",
								linear = true,
								mipmaps = true,
								usage = {"sample"}
							}) or nil
						end

						material.UVShift = Vector2.Create(unpack(rawMaterial.uvShift))
						material.UVScale = Vector2.Create(unpack(rawMaterial.uvScale))

						material.AlphaCutoff = rawMaterial.alphaCutoff

						materials[materialIndex] = material
					end
				end

				mesh:AddPart(
					material,
					modelData:getMeshDrawMode(meshIndex, partIndex),
					modelData:getMeshDrawRange(meshIndex, partIndex)
				)
			end

			meshes[meshIndex] = mesh
		end

		modelData:release()

		return meshes
	end
end

function Mesh.Create(mesh)
	if type(mesh) == "string" then
		return CreateFromFile(mesh)
	else
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