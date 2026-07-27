local Model = {}

local function CreateFromFile(path)
	local modelData = lovr.data.newModelData(path)

	if modelData then
		local model = Model.Create()

		local bodies = {}
		local meshes = {}
		local materials = {}

		local nodeCount = modelData:getNodeCount()
		local rootIndex = modelData:getRootNode()

		for index = 1, nodeCount, 1 do
			if index == rootIndex then
				model.Name = modelData:getNodeName(index) or "Model"

				bodies[index] = model
			end

			if index ~= rootIndex or nodeCount == 1 then
				local body = Body.Create()
				
				body.Name = modelData:getNodeName(index) or "Body"..math.max(index - 1, 1)
				
				local meshIndex = modelData:getNodeMesh(index)
				local mesh = nil

				if meshIndex then
					if meshes[meshIndex] then
						mesh = meshes[meshIndex]
					else
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

						local _mesh = lovr.graphics.newMesh(
							meshFormat,
							vertices,
							{storage = "gpu"}
						)

						_mesh:setIndices(indicies)

						mesh = Mesh.Create(_mesh)

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
				end

				body.Mesh = mesh

				local angle, axisX, axisY, axisZ = modelData:getNodeOrientation(index)
				body.Position = Vector3.Create(modelData:getNodePosition(index))
				body.Scale = Vector3.Create(modelData:getNodeScale(index))
				body.Orientation = Quaternion.CreateAxisRotation(angle, Vector3.Create(axisX, axisY, axisZ))

				bodies[index] = body
			end
		end

		if nodeCount == 1 then
			bodies[1].Parent = model
		else
			for index, body in ipairs(bodies) do
				local parentIndex = modelData:getNodeParent(index)

				if parentIndex then
					body.Parent = bodies[parentIndex]
				end
			end
		end

		modelData:release()

		return model
	end
end

function Model.Create(path)
	if path then
		return CreateFromFile(path)
	else
		local self = Class.CreateInstance(WorldObject.Create(), Model)

		return self
	end
end

function Model:Destroy()
	if not self._Destroyed then
		WorldObject.Destroy(self)
	end
end

return Class.CreateClass(Model, "Model", WorldObject)