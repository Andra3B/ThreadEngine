if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
	require("lldebugger").start()
end

table.erase = function(tab, cleanupCallback, recurse)
	for key, value in pairs(tab) do
		if recurse and Class.GetType(value) == "table" then
			table.erase(value, cleanupCallback, recurse)
		elseif cleanupCallback then
			cleanupCallback(value)
		end

		tab[key] = nil
	end
end

table.clone = function(tab, cloneCallback)
	local clonedTable = {}

	for key, value in pairs(tab) do
		if Class.GetType(value) == "table" then
			clonedTable[key] = table.clone(value, cloneCallback)
		else
			clonedTable[key] = cloneCallback and cloneCallback(value) or value
		end
	end

	return clonedTable
end

string.replace = function(str, from, to, with)
	if to >= #str then
		return string.sub(str, 1, from - 1)..with
	else
		return string.sub(str, 1, from - 1)..with..string.sub(str, to + 1)
	end
end

math.clamp = function(value, min, max)
	if value < min then
		return min
	elseif value > max then
		return max
	else
		return value
	end
end

math.sign = function(value)
	if value < 0 then
		return -1
	elseif value > 0 then
		return 1
	else
		return 0
	end
end

scriptpath = function()
	return debug.getinfo(2, "S").short_src
end

require("table.new")
require("table.clear")

table.empty = table.new(0, 0)

bit = require("bit")
ffi = require("ffi")
utf8 = require("utf8")
buffer = require("string.buffer")

Class = require("Class")

CBindings = require("CBindings")

Entity = require("Entity")
Object = require("Object")
Hierarchy = require("Hierarchy")

Enum = require("Enum")
Log = require("Log")

EventDirector = require("EventDirector")
EventListener = require("EventListener")

Vector2 = require("Math.Vector2")
Vector3 = require("Math.Vector3")
Vector4 = require("Math.Vector4")
Extents2 = require("Math.Extents2")
Extents3 = require("Math.Extents3")
ScaleOffset = require("Math.ScaleOffset")
ScaleOffset2 = require("Math.ScaleOffset2")
ScaleOffset3 = require("Math.ScaleOffset3")
ScaleOffset4 = require("Math.ScaleOffset4")
Quaternion = require("Math.Quaternion")
Matrix4 = require("Math.Matrix4")

Timer = require("Timer")
Input = require("Input")

WorldObject = require("World.WorldObject")
World = require("World.World")
Model = require("World.Model")
Mesh = require("World.Mesh")
Submesh = require("World.Submesh")
Skeleton = require("World.Skeleton")
Bone = require("World.Bone")
Body = require("World.Body")
Camera = require("World.Camera")
Skybox = require("World.Skybox")
Material = require("World.Material")

Light = require("World.Lights.Light")
PointLight = require("World.Lights.PointLight")

Animation = require("Animation.Animation")
AnimationChannel = require("Animation.AnimationChannel")
Animator = require("Animation.Animator")

InterfaceObject = require("Interface.InterfaceObject")
Interface = require("Interface.Interface")
Frame = require("Interface.Frame")
Label = require("Interface.Label")
Button = require("Interface.Button")
ScrollFrame = require("Interface.ScrollFrame")

cgltf = require("cgltf")

local MOUSE_INPUTS = {
	"m_leftmousebutton",
	"m_rightmousebutton",
	"m_middlemousebutton",
	"m_firstmousebutton",
	"m_secondmousebutton"
}

local DEFAULT_ENGINE_OPTIONS = {
	Window = {
		width = 1080,
		height = 720,
		fullscreen = false,
		resizable = true,
		title = "Thread Engine",
		icon = nil
	}
}

Thread = {}

Thread._SkyboxBlockHarmonicsBuffer = nil

Thread.Shaders = {}
Thread.Meshes = {}
Thread.Materials = {}

Thread.LovrMatrixIdentity = nil
Thread.CubemapMatrices = table.new(0, 7)

Thread.DefaultSkybox = nil

Thread.WhiteTexture = nil
Thread.BlackTexture = nil

Thread.Events = nil

Thread.Keybinds = {
	Interface = {}
}

Thread.World = nil
Thread.Interface = nil

local function LovrResourceRelease(resource)
	resource:release()
end

local function ThreadQuit(exitCode)
	Thread.Quit(exitCode)

	Timer.DestroyTimers()
	Input.DestroyInputs()

	Thread.Interface:Destroy()
	Thread.Interface = nil
	
	Thread.World:Destroy()
	Thread.World = nil

	table.erase(Thread.Keybinds, Input.Destroy, true)

	Thread.Events:Destroy()
	Thread.Events = nil

	Thread.BlackTexture:release()
	Thread.BlackTexture = nil

	Thread.WhiteTexture:release()
	Thread.WhiteTexture = nil

	Thread.DefaultSkybox:Destroy()
	Thread.DefaultSkybox = nil

	table.erase(Thread.CubemapMatrices)
	Thread.LovrMatrixIdentity = nil

	table.erase(Thread.Materials, Material.Destroy)
	table.erase(Thread.Meshes, Mesh.Destroy)
	table.erase(Thread.Shaders, LovrResourceRelease)

	Thread._SkyboxBlockHarmonicsBuffer:release()
	Thread._SkyboxBlockHarmonicsBuffer = nil
end

function Thread.Load() end
function Thread.Update(deltaTime) end
function Thread.PhysicsUpdate(deltaTime) end
function Thread.Quit(exitCode) end
function Thread.Restart() end

function Thread.UpdateSkybox(skybox)
	local mipmapCount = skybox.EnvironmentMap:getMipmapCount()
	local skyboxSize = skybox.EnvironmentMap:getWidth()

	local passes = table.new(0, mipmapCount + 1)

	for mipmap = 1, mipmapCount, 1 do
		local view = lovr.graphics.newTextureView(skybox.EnvironmentMap, {["mipmap"] = mipmap})
		local renderPass = lovr.graphics.newPass(view)

		renderPass:setFaceCull("front")

		renderPass:setShader(Thread.Shaders.SkyboxUpdate)
		renderPass:send("Skybox", skybox.Texture)
		renderPass:send("SkyboxSamples", 512)
			
		renderPass:send("Mipmap", mipmap)
		renderPass:send("MipmapCount", mipmapCount)

		renderPass:setProjection(1, Thread.CubemapMatrices[1])
		renderPass:setProjection(2, Thread.CubemapMatrices[1])
		renderPass:setProjection(3, Thread.CubemapMatrices[1])
		renderPass:setProjection(4, Thread.CubemapMatrices[1])
		renderPass:setProjection(5, Thread.CubemapMatrices[1])
		renderPass:setProjection(6, Thread.CubemapMatrices[1])

		renderPass:setViewPose(1, Thread.CubemapMatrices[2])
		renderPass:setViewPose(2, Thread.CubemapMatrices[3])
		renderPass:setViewPose(3, Thread.CubemapMatrices[4])
		renderPass:setViewPose(4, Thread.CubemapMatrices[5])
		renderPass:setViewPose(5, Thread.CubemapMatrices[6])
		renderPass:setViewPose(6, Thread.CubemapMatrices[7])

		renderPass:draw(Thread.Meshes.Cube.Submeshes[1].Mesh)

		table.insert(passes, renderPass)
		view:release()
	end

	local computePass = lovr.graphics.newPass()

	skybox.HarmonicsBuffer:clear()

	computePass:barrier()

	computePass:setShader(Thread.Shaders.SkyboxHarmonicsPass1)
	computePass:send("Skybox", skybox.EnvironmentMap)
	computePass:send("OutputBuffer", Thread._SkyboxBlockHarmonicsBuffer)

	computePass:compute(skyboxSize / 8, skyboxSize / 8, 6)

	computePass:barrier()

	computePass:setShader(Thread.Shaders.SkyboxHarmonicsPass2)
	computePass:send("BlockCount", skyboxSize * skyboxSize * 6 / 64)
	computePass:send("InputBuffer", Thread._SkyboxBlockHarmonicsBuffer)
	computePass:send("OutputBuffer", skybox.HarmonicsBuffer)

	computePass:compute(1, 1, 1)

	table.insert(passes, computePass)
	
	lovr.graphics.submit(passes)
	table.erase(passes, LovrResourceRelease)
end

local cgltfStrings = {Active = 0}
local cgltfOptions = ffi.new("cgltf_options[1]", {{
	file = {
		read = function(_, _, path, size, data)
			local content = lovr.filesystem.read(ffi.string(path))

			if content then
				table.insert(cgltfStrings, content)
				cgltfStrings.Active = cgltfStrings.Active + 1

				size[0] = #content
				data[0] = ffi.cast("void*", content)

				return cgltf.cgltf_result_success
			end

			return cgltf.cgltf_result_file_not_found
		end,

		release = function()
			cgltfStrings.Active = cgltfStrings.Active - 1

			if cgltfStrings.Active == 0 then
				while #cgltfStrings > 0 do
					table.remove(cgltfStrings)
				end
			end
		end
	}
}})

local function LoadCgltfData(path)
	local cgltfData = ffi.new("cgltf_data*[1]")

	if
		cgltf.cgltf_parse_file(cgltfOptions, path, cgltfData) == cgltf.cgltf_result_success and
		cgltf.cgltf_validate(cgltfData[0]) == cgltf.cgltf_result_success
	then
		cgltfData = cgltfData[0]

		if cgltf.cgltf_load_buffers(cgltfOptions, cgltfData, path) == cgltf.cgltf_result_success then
			return cgltfData
		else
			cgltf.cgtlf_free(cgltfData)
		end
	end
end

local function GetBase64DecodedSize(base64) 
    base64 = ffi.string(base64)

    local padding = 0

    if #base64 > 0 and string.sub(base64, -1) == "=" then
		padding = padding + 1
	end

    if #base64 > 1 and string.sub(base64, -2, -2) == "=" then
		padding = padding + 1
	end

    return (#base64 * 3 / 4) - padding
end

local function LoadCgltfTexture(texture, gltfPath, textureOptions)
	if texture == nil then return end

	local imageData = texture.image
	local samplerData = texture.sampler

	local texture = nil

	if imageData.uri ~= nil then
		local uri = ffi.string(imageData.uri)

		if string.sub(uri, 1, 5) == "data:" and string.find(uri, ";base64", 1, true) then
			local commaStart = string.find(uri, ",", 1, true)

			if commaStart then
				local pixelData = ffi.new("void*[1]")
				local base64Data = imageData.uri + commaStart

				if cgltf.cgltf_load_buffer_base64(cgltfOptions, 0, base64Data, pixelData) == cgltf.cgltf_result_success then
					local pixelByteData = lovr.data.newBlob(GetBase64DecodedSize(base64Data))
					ffi.copy(pixelByteData:getPointer(), pixelData, pixelByteData:getSize())

					texture = lovr.graphics.newTexture(pixelByteData, textureOptions)
					pixelByteData:release()
					cgltf.cgltf_free(pixelData)
				end
			end
		else
			local directory = string.match(gltfPath, ".+[/\\]")
			texture = lovr.graphics.newTexture(directory and directory..uri or uri, textureOptions)
		end
	elseif imageData.buffer_view ~= nil then
		local pixelByteData = lovr.data.newBlob(tonumber(imageData.buffer_view.size))

		ffi.copy(
			pixelByteData:getPointer(),
			ffi.cast("char*", imageData.buffer_view.buffer.data) + imageData.buffer_view.offset,
			pixelByteData:getSize()
		)

		texture = lovr.graphics.newTexture(pixelByteData, textureOptions)
		pixelByteData:release()
	end

	if texture and samplerData ~= nil then
		local minFilterType = samplerData.min_filter
		local magFilterType = samplerData.mag_filter

		local horizontalWrapType = samplerData.wrap_s
		local verticalWrapType = samplerData.wrap_t

		texture:setSampler(lovr.graphics.newSampler({
			filter = {(
					minFilterType == cgltf.cgltf_filter_type_undefined or
					minFilterType == cgltf.cgltf_filter_type_linear or
					minFilterType == cgltf.cgltf_filter_type_linear_mipmap_nearest or
					minFilterType == cgltf.cgltf_filter_type_linear_mipmap_linear
				) and "linear" or "nearest", (
					magFilterType == cgltf.cgltf_filter_type_undefined or
					magFilterType == cgltf.cgltf_filter_type_linear or
					magFilterType == cgltf.cgltf_filter_type_linear_mipmap_nearest or
					magFilterType == cgltf.cgltf_filter_type_linear_mipmap_linear
				) and "linear" or "nearest", (
					minFilterType == cgltf.cgltf_filter_type_undefined or
					minFilterType == cgltf.cgltf_filter_type_nearest_mipmap_linear or
					minFilterType == cgltf.cgltf_filter_type_linear_mipmap_linear
				) and "linear" or "nearest"
			},

			wrap = {
				(horizontalWrapType == cgltf.cgltf_wrap_mode_clamp_to_edge and "clamp") or
				(horizontalWrapType == cgltf.cgltf_wrap_mode_mirrored_repeat and "mirror") or
				"repeat",
				(verticalWrapType == cgltf.cgltf_wrap_mode_clamp_to_edge and "clamp") or
				(verticalWrapType == cgltf.cgltf_wrap_mode_mirrored_repeat and "mirror") or
				"repeat",
				"repeat"
			}
		}))
	end

	return texture
end

local function NodeDescendantIterator(node)
	for index = 0, tonumber(node.children_count) - 1, 1 do
		coroutine.yield(node.children[index])
	end

	for index = 0, tonumber(node.children_count) - 1, 1 do
		NodeDescendantIterator(node.children[index])
	end
end

local function IterateNodeDescendants(node)
	return coroutine.wrap(NodeDescendantIterator), node, nil
end

function Thread.LoadMaterials(cgltfData, materialIndex, gltfPath, cache)
	cache = cache or {}

	if not cache.Materials then
		cache.Materials = {}
	end

	local result = cache.Materials[materialIndex]
	if result then return result end

	local destroyData = false
	if type(cgltfData) == "string" then
		gltfPath = cgltfData
		cgltfData = LoadCgltfData(gltfPath)
		destroyData = true
	end

	result = {}

	if cgltfData ~= nil then
		for index = materialIndex and materialIndex - 1 or 0, materialIndex and materialIndex - 1 or tonumber(cgltfData.materials_count) - 1, 1 do
			local material = cache.Materials[index + 1]
			
			if not material then
				material = Material.Create()

				local cgltfMaterial = cgltfData.materials[index]

				material.Name = cgltfMaterial.name ~= nil and ffi.string(cgltfMaterial.name) or nil

				local colour = cgltfMaterial.pbr_metallic_roughness.base_color_factor
				material.Colour = Vector4.Create(colour[0], colour[1], colour[2], colour[3])
				material.ColourTexture = LoadCgltfTexture(
					cgltfMaterial.pbr_metallic_roughness.base_color_texture.texture,
					gltfPath, {
						type = "2d",
						format = "rgba8",
						linear = false,
						mipmaps = true,
						usage = {"sample"}
					}
				)

				local glow = cgltfMaterial.emissive_factor
				material.Glow = Vector4.Create(glow[0], glow[1], glow[2], cgltfMaterial.emissive_strength.emissive_strength)
				material.GlowTexture = LoadCgltfTexture(
					cgltfMaterial.emissive_texture.texture,
					gltfPath, {
						type = "2d",
						format = "rgba8",
						linear = false,
						mipmaps = true,
						usage = {"sample"}
					}
				)

				material.Metalness = cgltfMaterial.pbr_metallic_roughness.metallic_factor
				material.MetalnessTexture = LoadCgltfTexture(
					cgltfMaterial.pbr_metallic_roughness.metallic_roughness_texture.texture,
					gltfPath, {
						type = "2d",
						format = "rgba8",
						linear = true,
						mipmaps = true,
						usage = {"sample"}
					}
				)

				material.Roughness = cgltfMaterial.pbr_metallic_roughness.roughness_factor
				material.RoughnessTexture = material.MetalnessTexture

				material.NormalScale = cgltfMaterial.normal_texture.scale
				material.NormalTexture = LoadCgltfTexture(
					cgltfMaterial.normal_texture.texture,
					gltfPath, {
						type = "2d",
						format = "rgba8",
						linear = true,
						mipmaps = true,
						usage = {"sample"}
					}
				)

				material.OcclusionStrength = cgltfMaterial.occlusion_texture.scale
				material.OcclusionTexture =
					cgltfMaterial.occlusion_texture.texture == cgltfMaterial.pbr_metallic_roughness.metallic_roughness_texture.texture and material.MetalnessTexture or LoadCgltfTexture(
					cgltfMaterial.occlusion_texture.texture,
					gltfPath, {
						type = "2d",
						format = "rgba8",
						linear = true,
						mipmaps = true,
						usage = {"sample"}
					}
				)

				material.AlphaCutoff = cgltfMaterial.alpha_cutoff

				cache.Materials[index + 1] = material
			end

			if materialIndex then
				result = material
			else
				table.insert(result, material)
			end
		end

		if destroyData then
			cgltf.cgltf_free(cgltfData)
		end
	end

	return result, cache
end

Enum.DrawMode = Enum.Create({
	Points = "points",
	Lines = "lines",
	Triangles = "triangles"
})

function Thread.LoadMeshes(cgltfData, meshIndex, gltfPath, cache)
	cache = cache or {}

	if not cache.Meshes then
		cache.Meshes = {}
	end

	local result = cache.Meshes[meshIndex]
	if result then return result end

	local destroyData = false
	if type(cgltfData) == "string" then
		gltfPath = cgltfData
		cgltfData = LoadCgltfData(gltfPath)
		destroyData = true
	end

	result = {}

	if cgltfData ~= nil then
		local vertices = {}
		local indices = {}

		for index = meshIndex and meshIndex - 1 or 0, meshIndex and meshIndex - 1 or tonumber(cgltfData.meshes_count) - 1, 1 do
			local mesh = cache.Meshes[index + 1]
			
			if not mesh then
				mesh = Mesh.Create()

				local cgltfMesh = cgltfData.meshes[index]

				mesh.Name = cgltfMesh.name ~= nil and ffi.string(cgltfMesh.name) or nil

				for submeshIndex = 0, tonumber(cgltfMesh.primitives_count) - 1, 1 do
					local cgltfSubmesh = cgltfMesh.primitives[submeshIndex]
					local drawMode =
						(cgltfSubmesh.type == cgltf.cgltf_primitive_type_points and Enum.DrawMode.Points) or
						(cgltfSubmesh.type == cgltf.cgltf_primitive_type_lines and Enum.DrawMode.Lines) or
						(cgltfSubmesh.type == cgltf.cgltf_primitive_type_triangles and Enum.DrawMode.Triangles) or
						nil

					if cgltfSubmesh.attributes_count > 0 and drawMode then
						local position = ffi.new("cgltf_float[3]")
						local normal = ffi.new("cgltf_float[3]")
						local tangent = ffi.new("cgltf_float[3]")
						local uv = ffi.new("cgltf_float[2]")
						local colour = ffi.new("cgltf_float[4]")
						local boneIDs = ffi.new("cgltf_uint[4]")
						local boneWeights = ffi.new("cgltf_float[4]")

						local hasTangents = false
						local hasUVs = false
						local hasColours = false
						local hasSkeleton = false

						for vertexIndex = 0, tonumber(cgltfSubmesh.attributes[0].data.count) - 1, 1 do
							for attributeIndex = 0, tonumber(cgltfSubmesh.attributes_count) - 1, 1 do
								local attribute = cgltfSubmesh.attributes[attributeIndex]

								if attribute.type == cgltf.cgltf_attribute_type_position then
									cgltf.cgltf_accessor_read_float(attribute.data, vertexIndex, position, 3)
								elseif attribute.type == cgltf.cgltf_attribute_type_normal then
									cgltf.cgltf_accessor_read_float(attribute.data, vertexIndex, normal, 3)
								elseif attribute.type == cgltf.cgltf_attribute_type_tangent then
									cgltf.cgltf_accessor_read_float(attribute.data, vertexIndex, tangent, 3)

									hasTangents = true
								elseif attribute.type == cgltf.cgltf_attribute_type_texcoord then
									cgltf.cgltf_accessor_read_float(attribute.data, vertexIndex, uv, 2)

									hasUVs = true
								elseif attribute.type == cgltf.cgltf_attribute_type_color then
									cgltf.cgltf_accessor_read_float(attribute.data, vertexIndex, colour, 4)

									hasColours = true
								elseif attribute.type == cgltf.cgltf_attribute_type_joints then
									cgltf.cgltf_accessor_read_uint(attribute.data, vertexIndex, boneIDs, 4)

									hasSkeleton = true
								elseif attribute.type == cgltf.cgltf_attribute_type_weights then
									cgltf.cgltf_accessor_read_float(attribute.data, vertexIndex, boneWeights, 4)

									hasSkeleton = true
								end
							end

							local vertex = {
								position[0], position[1], position[2],
								normal[0], normal[1], normal[2]
							}

							if hasTangents then
								table.insert(vertex, tangent[0])
								table.insert(vertex, tangent[1])
								table.insert(vertex, tangent[2])
							end

							if hasUVs then
								table.insert(vertex, uv[0])
								table.insert(vertex, uv[1])
							end

							if hasColours then
								table.insert(vertex, colour[0])
								table.insert(vertex, colour[1])
								table.insert(vertex, colour[2])
								table.insert(vertex, colour[3])
							end

							if hasSkeleton then
								table.insert(vertex, boneIDs[0])
								table.insert(vertex, boneIDs[1])
								table.insert(vertex, boneIDs[2])
								table.insert(vertex, boneIDs[3])

								local weightSum = boneWeights[0] + boneWeights[1] + boneWeights[2] + boneWeights[3]

								if weightSum == 0 then
									boneWeights[0] = 1
									weightSum = 1
								end

								local weightFactor = 1 / weightSum 

								table.insert(vertex, boneWeights[0] * weightFactor)
								table.insert(vertex, boneWeights[1] * weightFactor)
								table.insert(vertex, boneWeights[2] * weightFactor)
								table.insert(vertex, boneWeights[3] * weightFactor)
							end

							table.insert(vertices, vertex)
						end

						if cgltfSubmesh.indices ~= nil then
							local index = ffi.new("cgltf_uint[1]")

							for indexIndex = 0, tonumber(cgltfSubmesh.indices.count) - 1, 1 do
								cgltf.cgltf_accessor_read_uint(cgltfSubmesh.indices, indexIndex, index, 1)
								table.insert(indices, index[0] + 1)
							end
						end

						local vertexFormat = {
							{"VertexPosition", "vec3"},
							{"VertexNormal", "vec3"}
						}

						if hasTangents then
							table.insert(vertexFormat, {"VertexTangent", "vec3"})
						end

						if hasUVs then
							table.insert(vertexFormat, {"VertexUV", "vec2"})
						end

						if hasColours then
							table.insert(vertexFormat, {"VertexColor", "vec4"})
						end

						if hasSkeleton then
							table.insert(vertexFormat, {"VertexBoneIDs", "u8x4"})
							table.insert(vertexFormat, {"VertexBoneWeights", "un8x4"})
						end

						local submesh = lovr.graphics.newMesh(vertexFormat, vertices, {storage = "gpu"})

						submesh:setIndices(indices)
						submesh:setDrawMode(drawMode)

						submesh = Submesh.Create(submesh)

						if cgltfSubmesh.material ~= nil then
							submesh.Material = Thread.LoadMaterials(
								cgltfData,
								tonumber(cgltf.cgltf_material_index(cgltfData, cgltfSubmesh.material)) + 1,
								gltfPath,
								cache
							)
						end
						
						mesh:AddSubmesh(submesh)

						table.clear(vertices)
						table.clear(indices)
					end
				end

				cache.Meshes[index + 1] = mesh
			end

			if meshIndex then
				result = mesh
			else
				table.insert(result, mesh)
			end
		end

		if destroyData then
			cgltf.cgltf_free(cgltfData)
		end
	end

	return result, cache
end

function Thread.LoadAnimations(cgltfData, animationIndex, cache)
	cache = cache or {}

	if not cache.Animations then
		cache.Animations = {}
	end

	local result = cache.Animations[animationIndex]
	if result then return result end

	local destroyData = false
	if type(cgltfData) == "string" then
		cgltfData = LoadCgltfData(cgltfData)
		destroyData = true
	end

	result = {}

	if cgltfData ~= nil then
		for index = animationIndex and animationIndex - 1 or 0, animationIndex and animationIndex - 1 or tonumber(cgltfData.animations_count) - 1, 1 do
			local animation = cache.Animations[index + 1]
			
			if not animation then
				animation = Animation.Create()

				local cgltfAnimation = cgltfData.animations[index]

				animation.Name = cgltfAnimation.name ~= nil and ffi.string(cgltfAnimation.name) or nil

				for channelIndex = 0, tonumber(cgltfAnimation.channels_count) - 1, 1 do
					local cgltfChannel = cgltfAnimation.channels[channelIndex]

					local target = cgltfChannel.target_node.name
					target = target ~= nil and ffi.string(target) or nil

					if target then
						local targetProperty = cgltfChannel.target_path
						targetProperty =
							(targetProperty == cgltf.cgltf_animation_path_type_translation and "Position") or
							(targetProperty == cgltf.cgltf_animation_path_type_rotation and "Orientation") or
							(targetProperty == cgltf.cgltf_animation_path_type_scale and "Scale") or
							nil

						if targetProperty then
							local cgltfChannelSampler = cgltfChannel.sampler

							local smoothingType = cgltfChannelSampler.interpolation
							smoothingType =
								(smoothingType == cgltf.cgltf_interpolation_type_linear and Enum.AnimationSmoothing.Linear) or
								(smoothingType == cgltf.cgltf_interpolation_type_step and Enum.AnimationSmoothing.Step) or
								nil

							if smoothingType then
								local channel = AnimationChannel.Create(
									target,
									targetProperty,
									targetProperty == "Orientation" and Enum.AnimationPropertyType.Quaternion or Enum.AnimationPropertyType.Vector,
									smoothingType
								)

								local timePointer = ffi.new("cgltf_float[1]")

								local valueSize = channel.PropertyType == Enum.AnimationPropertyType.Quaternion and 4 or 3
								local valueBuffer = ffi.new("cgltf_float[?]", valueSize)

								for keyframeIndex = 0, tonumber(cgltfChannelSampler.input.count) - 1, 1 do
									cgltf.cgltf_accessor_read_float(cgltfChannelSampler.input, keyframeIndex, timePointer, 1)
									cgltf.cgltf_accessor_read_float(cgltfChannelSampler.output, keyframeIndex, valueBuffer, valueSize)

									channel:AddKeyframe(
										timePointer[0],
										(valueSize == 4 and Quaternion.Create(valueBuffer[3], valueBuffer[0], valueBuffer[1], valueBuffer[2])) or
										Vector3.Create(valueBuffer[0], valueBuffer[1], valueBuffer[2])
									)
								end

								animation:AddChannel(channel)
							end
						end
					end
				end

				cache.Animations[index + 1] = animation
			end

			if animationIndex then
				result = animation
			else
				table.insert(result, animation)
			end
		end

		if destroyData then
			cgltf.cgltf_free(cgltfData)
		end
	end

	return result, cache
end

function Thread.LoadSkeletons(cgltfData, skeletonIndex)
	local destroyData = false
	if type(cgltfData) == "string" then
		cgltfData = LoadCgltfData(cgltfData)
		destroyData = true
	end

	local skeletons = {}
	local bones = {}
	local skeletonBones = {}

	if cgltfData ~= nil then
		for index = skeletonIndex and skeletonIndex - 1 or 0, skeletonIndex and skeletonIndex - 1 or tonumber(cgltfData.skins_count) - 1, 1 do
			local skeleton = Skeleton.Create()

			local cgltfSkeleton = cgltfData.skins[index]

			skeleton.Name = cgltfSkeleton.name ~= nil and ffi.string(cgltfSkeleton.name) or nil

			for boneIndex = 0, tonumber(cgltfSkeleton.joints_count) - 1, 1 do
				local bone = Bone.Create(boneIndex + 1)

				local cgltfBone = cgltfSkeleton.joints[boneIndex]

				bone.Name = cgltfBone.name ~= nil and ffi.string(cgltfBone.name) or nil

				if cgltfBone.has_matrix == 0 then
					bone.Position = cgltfBone.has_translation ~= 0 and Vector3.Create(
						cgltfBone.translation[0], cgltfBone.translation[1], cgltfBone.translation[2]
					) or Vector3.Zero

					bone.Orientation = cgltfBone.has_rotation ~= 0 and Quaternion.Create(
						cgltfBone.rotation[3], cgltfBone.rotation[0], cgltfBone.rotation[1], cgltfBone.rotation[2]
					) or Quaternion.One

					bone.Scale = cgltfBone.has_scale ~= 0 and Vector3.Create(
						cgltfBone.scale[0], cgltfBone.scale[1], cgltfBone.scale[2]
					) or Vector3.One
				else
					local components = cgltfBone.matrix

					local localTransform = Matrix4.Create({
						components[0], components[1], components[2], components[3],
						components[4], components[5], components[6], components[7],
						components[8], components[9], components[10], components[11],
						components[12], components[13], components[14], components[15]
					})

					bone.Position = localTransform.Position
					bone.Orientation = localTransform.Orientation
					bone.Scale = localTransform.Scale
				end

				local boneNodeIndex = tonumber(cgltf.cgltf_node_index(cgltfData, cgltfBone)) + 1

				skeletonBones[boneNodeIndex] = bone
				bones[boneNodeIndex] = bone
			end

			for boneIndex, bone in pairs(skeletonBones) do
				local cgltfBone = cgltfData.nodes[boneIndex - 1]

				bone.Parent = skeletonBones[tonumber(cgltf.cgltf_node_index(cgltfData, cgltfBone.parent)) + 1] or skeleton
			end

			table.clear(skeletonBones)

			if skeletonIndex then
				skeletons = skeleton
			else
				table.insert(skeletons, skeleton)
			end
		end

		if destroyData then
			cgltf.cgltf_free(cgltfData)
		end
	end

	return skeletons, bones
end

function Thread.LoadModel(cgltfData, modelIndex, gltfPath, cache)
	cache = cache or {}

	local destroyData = false
	if type(cgltfData) == "string" then
		gltfPath = cgltfData
		cgltfData = LoadCgltfData(gltfPath)
		destroyData = true
	end

	local model

	if cgltfData ~= nil then
		local cgltfModelNode

		if not modelIndex then
			if cgltfData.scene ~= nil and cgltfData.scene.nodes_count > 0 then
				cgltfModelNode = cgltfData.scene.nodes[0]
				modelIndex = tonumber(cgltf.cgltf_node_index(cgltfData, cgltfModelNode)) + 1
			end
		elseif type(modelIndex) == "number" then
			if modelIndex > 0 and modelIndex <= cgltfData.nodes_count then
				cgltfModelNode = cgltfData.nodes[modelIndex - 1]
			end
		elseif type(modelIndex) == "string" then
			for nodeIndex = 0, tonumber(cgltfData.nodes_count) - 1, 1 do
				local cgltfNode = cgltfData.nodes[nodeIndex]

				if cgltfNode.name ~= nil and modelIndex == ffi.string(cgltfNode.name) then
					cgltfModelNode = cgltfNode
					modelIndex = nodeIndex + 1

					break
				end
			end
		end

		if cgltfModelNode then
			model = Model.Create()

			model.Name = cgltfModelNode.name ~= nil and ffi.string(cgltfModelNode.name) or nil

			if cgltfModelNode.has_matrix == 0 then
				model.Position = cgltfModelNode.has_translation ~= 0 and Vector3.Create(
					cgltfModelNode.translation[0], cgltfModelNode.translation[1], cgltfModelNode.translation[2]
				) or Vector3.Zero

				model.Orientation = cgltfModelNode.has_rotation ~= 0 and Quaternion.Create(
					cgltfModelNode.rotation[3], cgltfModelNode.rotation[0], cgltfModelNode.rotation[1], cgltfModelNode.rotation[2]
				) or Quaternion.One

				model.Scale = cgltfModelNode.has_scale ~= 0 and Vector3.Create(
					cgltfModelNode.scale[0], cgltfModelNode.scale[1], cgltfModelNode.scale[2]
				) or Vector3.One
			else
				local components = cgltfModelNode.matrix

				local localTransform = Matrix4.Create({
					components[0], components[1], components[2], components[3],
					components[4], components[5], components[6], components[7],
					components[8], components[9], components[10], components[11],
					components[12], components[13], components[14], components[15]
				})

				model.Position = localTransform.Position
				model.Orientation = localTransform.Orientation
				model.Scale = localTransform.Scale
			end

			local objects = {[modelIndex] = model}
			local skeletons = {}

			if cgltfModelNode.mesh ~= nil then
				local body = Body.Create()

				body.Name = model.Name

				body.Mesh = Thread.LoadMeshes(
					cgltfData,
					tonumber(cgltf.cgltf_mesh_index(cgltfData, cgltfModelNode.mesh)) + 1,
					gltfPath,
					cache
				)

				if cgltfModelNode.skin ~= nil then
					local skeletonIndex = tonumber(cgltf.cgltf_skin_index(cgltfData, cgltfModelNode.skin)) + 1
					local skeleton, bones = Thread.LoadSkeletons(cgltfData, skeletonIndex)
						
					for boneIndex, bone in pairs(bones) do
						objects[boneIndex] = bone
					end

					skeleton.Parent = model
					
					skeletons[skeletonIndex] = skeleton

					object.Skeleton = skeleton.Name
				end

				body.Parent = model
			end

			for cgltfObject in IterateNodeDescendants(cgltfModelNode) do
				local object = objects[tonumber(cgltf.cgltf_node_index(cgltfData, cgltfObject)) + 1]

				if not object then
					if cgltfObject.light ~= nil then
						error("TODO")
					elseif cgltfObject.mesh ~= nil then
						object = Body.Create()

						object.Mesh = Thread.LoadMeshes(
							cgltfData,
							tonumber(cgltf.cgltf_mesh_index(cgltfData, cgltfObject.mesh)) + 1,
							gltfPath,
							cache
						)

						if cgltfObject.skin ~= nil then
							local skeletonIndex = tonumber(cgltf.cgltf_skin_index(cgltfData, cgltfObject.skin)) + 1
							local skeleton, bones = skeletons[skeletonIndex]

							if not skeleton then
								skeleton, bones = Thread.LoadSkeletons(cgltfData, skeletonIndex)
								
								for boneIndex, bone in pairs(bones) do
									objects[boneIndex] = bone
								end

								skeleton.Parent = model

								skeletons[skeletonIndex] = skeleton
							end

							object.Skeleton = skeleton.Name
						end
					end

					if object then
						object.Name = cgltfObject.name ~= nil and ffi.string(cgltfObject.name) or nil

						if cgltfObject.has_matrix == 0 then
							object.Position = cgltfObject.has_translation ~= 0 and Vector3.Create(
								cgltfObject.translation[0], cgltfObject.translation[1], cgltfObject.translation[2]
							) or Vector3.Zero

							object.Orientation = cgltfObject.has_rotation ~= 0 and Quaternion.Create(
								cgltfObject.rotation[3], cgltfObject.rotation[0], cgltfObject.rotation[1], cgltfObject.rotation[2]
							) or Quaternion.One

							object.Scale = cgltfObject.has_scale ~= 0 and Vector3.Create(
								cgltfObject.scale[0], cgltfObject.scale[1], cgltfObject.scale[2]
							) or Vector3.One
						else
							local components = cgltfObject.matrix

							local localTransform = Matrix4.Create({
								components[0], components[1], components[2], components[3],
								components[4], components[5], components[6], components[7],
								components[8], components[9], components[10], components[11],
								components[12], components[13], components[14], components[15]
							})

							object.Position = localTransform.Position
							object.Orientation = localTransform.Orientation
							object.Scale = localTransform.Scale
						end

						objects[tonumber(cgltf.cgltf_node_index(cgltfData, cgltfObject)) + 1] = object
					end
				end
			end

			for animationIndex = 0, tonumber(cgltfData.animations_count) - 1, 1 do
				for channelIndex = 0, tonumber(cgltfData.animations[animationIndex].channels_count) - 1, 1 do
					local target = cgltfData.animations[animationIndex].channels.target_node

					if target ~= nil and objects[tonumber(cgltf.cgltf_node_index(cgltfData, target)) + 1] then
						Thread.LoadAnimations(cgltfData, animationIndex + 1, cache).Parent = model

						break
					end
				end
			end

			for index, object in pairs(objects) do
				if not object:IsA("Bone") then
					local cgltfParent = cgltfData.nodes[index - 1].parent

					object.Parent =
						cgltfParent ~= nil and objects[tonumber(cgltf.cgltf_node_index(cgltfData, cgltfParent)) + 1] or model
				end
			end
		end

		if destroyData then
			cgltf.cgltf_free(cgltfData)
		end
	end

	return model, cache
end

function lovr.keypressed(key) Input.TriggerInput("k_"..key, Vector3.Forward, false) end
function lovr.keyreleased(key) Input.TriggerInput("k_"..key, Vector3.Forward, true) end
function lovr.mousemoved(x, y, dx, dy) Input.TriggerInput("m_movement", Vector3.Create(dx, dy, nil)) end
function lovr.wheelmoved(dx, dy) Input.TriggerInput("m_wheelmovement", Vector3.Create(dx, dy, nil)) end
function lovr.mousepressed(x, y, button) Input.TriggerInput(MOUSE_INPUTS[button], Vector3.Forward, false) end
function lovr.mousereleased(x, y, button) Input.TriggerInput(MOUSE_INPUTS[button], Vector3.Forward, true) end

function lovr.errhand(message)
	Log.Error("Thread", debug.traceback(tostring(message), 2):gsub("\n[^\n]+$", ""))

	ThreadQuit(1)
end

function lovr.resize(width, height)
	if Thread.World.Camera then
		Thread.World.Camera.Projection = Class.NIL
	end

	Thread.Interface.Size = ScaleOffset2.Create(0, 0, width, height)
	Thread.Interface.Projection = Matrix4.CreateInterfaceProjection(width, height)
end

function lovr.run()
	Thread._SkyboxBlockHarmonicsBuffer = lovr.graphics.newBuffer({"vec3", layout = "std430"}, 221184)

	Thread.Shaders.Interface = lovr.graphics.newShader(
		"Assets/Shaders/Interface/Interface.vert", "Assets/Shaders/Interface/Interface.frag"
	)

	Thread.Shaders.WorldTangents = lovr.graphics.newShader(
		"Assets/Shaders/World/World.vert", "Assets/Shaders/World/World.frag",
		{flags = {
			passColor = true,
			materialColor = false,
			vertexColors = true,
			uvTransform = false,
			alphaCutoff = false,
			glow = false,
			normalMap = false,
			vertexTangents = true,
			colorTexture = false,
			glowTexture = false,
			metalnessTexture = false,
			roughnessTexture = false,
			ambientOcclusion = false,
			clearcoatTexture = false,
			tonemap = true
		}}
	)

	Thread.Shaders.WorldNoTangents = lovr.graphics.newShader(
		"Assets/Shaders/World/World.vert", "Assets/Shaders/World/World.frag",
		{flags = {
			passColor = true,
			materialColor = false,
			vertexColors = true,
			uvTransform = false,
			alphaCutoff = false,
			glow = false,
			normalMap = false,
			vertexTangents = false,
			colorTexture = false,
			glowTexture = false,
			metalnessTexture = false,
			roughnessTexture = false,
			ambientOcclusion = false,
			clearcoatTexture = false,
			tonemap = true
		}}
	)

	Thread.Shaders.Cubemap = lovr.graphics.newShader(
		"Assets/Shaders/Other/Cubemap.vert", "Assets/Shaders/Other/Cubemap.frag",
		{flags = {tonemap = true}}
	)

	Thread.Shaders.SkyboxUpdate = lovr.graphics.newShader(
		"Assets/Shaders/World/World.vert", "Assets/Shaders/Skybox/SkyboxUpdate.frag"
	)

	Thread.Shaders.SkyboxHarmonicsPass1 = lovr.graphics.newShader(
		"Assets/Shaders/Skybox/SkyboxHarmonicsPass1.comp"
	)

	Thread.Shaders.SkyboxHarmonicsPass2 = lovr.graphics.newShader(
		"Assets/Shaders/Skybox/SkyboxHarmonicsPass2.comp"
	)

	Thread.Shaders.SkyboxHarmonics = lovr.graphics.newShader(
		"Assets/Shaders/Other/Cubemap.vert", "Assets/Shaders/Debug/SkyboxHarmonics.frag",
		{flags = {tonemap = true}}
	)

	local square = lovr.graphics.newMesh({
		{name = "VertexPosition", type = "vec2"},
		{name = "VertexUV", type = "vec2"}
	}, {
		{0, 0, 0, 0},
		{0, 1, 0, 1},
		{1, 1, 1, 1},
		{1, 0, 1, 0}
	}, {
		storage = "gpu"
	})

	square:setIndices({
		1, 2, 3,
		1, 3, 4
	})

	Thread.Meshes.Square = Mesh.Create()
	Thread.Meshes.Square:AddSubmesh(Submesh.Create(square))

	local cube = lovr.graphics.newMesh({
		{name = "VertexPosition", type = "vec3"},
		{name = "VertexNormal", type = "vec3"},
		{name = "VertexUV", type = "vec2"}
	}, {
		-- FRONT FACE (+Z) - Normal: 0, 0, 1
        {-0.5, -0.5,  0.5,    0,  0,  1,    0.0, 1.0}, -- 1: Bottom-Left
        { 0.5, -0.5,  0.5,    0,  0,  1,    1.0, 1.0}, -- 2: Bottom-Right
        { 0.5,  0.5,  0.5,    0,  0,  1,    1.0, 0.0}, -- 3: Top-Right
        {-0.5,  0.5,  0.5,    0,  0,  1,    0.0, 0.0}, -- 4: Top-Left

        -- BACK FACE (-Z) - Normal: 0, 0, -1
        { 0.5, -0.5, -0.5,    0,  0, -1,    0.0, 1.0}, -- 5: Bottom-Left (from back)
        {-0.5, -0.5, -0.5,    0,  0, -1,    1.0, 1.0}, -- 6: Bottom-Right (from back)
        {-0.5,  0.5, -0.5,    0,  0, -1,    1.0, 0.0}, -- 7: Top-Right (from back)
        { 0.5,  0.5, -0.5,    0,  0, -1,    0.0, 0.0}, -- 8: Top-Left (from back)

        -- LEFT FACE (-X) - Normal: -1, 0, 0
        {-0.5, -0.5, -0.5,   -1,  0,  0,    0.0, 1.0}, -- 9: Bottom-Left
        {-0.5, -0.5,  0.5,   -1,  0,  0,    1.0, 1.0}, -- 10: Bottom-Right
        {-0.5,  0.5,  0.5,   -1,  0,  0,    1.0, 0.0}, -- 11: Top-Right
        {-0.5,  0.5, -0.5,   -1,  0,  0,    0.0, 0.0}, -- 12: Top-Left

        -- RIGHT FACE (+X) - Normal: 1, 0, 0
        { 0.5, -0.5,  0.5,    1,  0,  0,    0.0, 1.0}, -- 13: Bottom-Left
        { 0.5, -0.5, -0.5,    1,  0,  0,    1.0, 1.0}, -- 14: Bottom-Right
        { 0.5,  0.5, -0.5,    1,  0,  0,    1.0, 0.0}, -- 15: Top-Right
        { 0.5,  0.5,  0.5,    1,  0,  0,    0.0, 0.0}, -- 16: Top-Left

        -- TOP FACE (+Y) - Normal: 0, 1, 0
        {-0.5,  0.5,  0.5,    0,  1,  0,    0.0, 1.0}, -- 17: Bottom-Left
        { 0.5,  0.5,  0.5,    0,  1,  0,    1.0, 1.0}, -- 18: Bottom-Right
        { 0.5,  0.5, -0.5,    0,  1,  0,    1.0, 0.0}, -- 19: Top-Right
        {-0.5,  0.5, -0.5,    0,  1,  0,    0.0, 0.0}, -- 20: Top-Left

        -- BOTTOM FACE (-Y) - Normal: 0, -1, 0
        {-0.5, -0.5, -0.5,    0, -1,  0,    0.0, 1.0}, -- 21: Bottom-Left
        { 0.5, -0.5, -0.5,    0, -1,  0,    1.0, 1.0}, -- 22: Bottom-Right
        { 0.5, -0.5,  0.5,    0, -1,  0,    1.0, 0.0}, -- 23: Top-Right
        {-0.5, -0.5,  0.5,    0, -1,  0,    0.0, 0.0}  -- 24: Top-Left
	}, {
		storage = "gpu"
	})

	cube:setIndices({
		-- Front face
        1, 2, 3,    3, 4, 1,
        -- Back face
        5, 6, 7,    7, 8, 5,
        -- Left face
        9, 10, 11,  11, 12, 9,
        -- Right face
        13, 14, 15, 15, 16, 13,
        -- Top face
        17, 18, 19, 19, 20, 17,
        -- Bottom face
        21, 22, 23, 23, 24, 21
	})
	
	Thread.Meshes.Cube = Mesh.Create()
	Thread.Meshes.Cube:AddSubmesh(Submesh.Create(cube))

	Thread.Materials.Default = Material.Create()

	Thread.Materials.Red = Material.Create()
	Thread.Materials.Red.Colour = Vector4.Create(0.2, 0, 0, 1)

	Thread.Materials.Green = Material.Create()
	Thread.Materials.Green.Colour = Vector4.Create(0, 0.2, 0, 1)

	Thread.Materials.Blue = Material.Create()
	Thread.Materials.Blue.Colour = Vector4.Create(0, 0, 0.2, 1)

	Thread.LovrMatrixIdentity = lovr.math.newMat4()

	Thread.CubemapMatrices[1] = lovr.math.newMat4(Matrix4.CreatePerspectiveProjection(1, math.rad(90), 0.1, 1):Unpack())
	Thread.CubemapMatrices[2] = lovr.math.newMat4(Matrix4.CreateTransform(Vector3.Zero, Vector3.Create(0, math.rad(-90), 0)):Unpack())	-- +X
	Thread.CubemapMatrices[3] = lovr.math.newMat4(Matrix4.CreateTransform(Vector3.Zero, Vector3.Create(0, math.rad(90), 0)):Unpack())	-- -X
	Thread.CubemapMatrices[4] = lovr.math.newMat4(Matrix4.CreateTransform(Vector3.Zero, Vector3.Create(math.rad(90), 0, 0)):Unpack())	-- +Y
	Thread.CubemapMatrices[5] = lovr.math.newMat4(Matrix4.CreateTransform(Vector3.Zero, Vector3.Create(math.rad(-90), 0, 0)):Unpack())	-- -Y
	Thread.CubemapMatrices[6] = lovr.math.newMat4(Matrix4.CreateTransform(Vector3.Zero, Vector3.Create(0, math.rad(0), 0)):Unpack())	-- +Z
	Thread.CubemapMatrices[7] = lovr.math.newMat4(Matrix4.CreateTransform(Vector3.Zero, Vector3.Create(0, math.rad(180), 0)):Unpack())	-- -Z

	Thread.DefaultSkybox = Skybox.Create("Assets/Skyboxes/ClearNight.hdr")

	local image = lovr.data.newImage(1, 1, "rgba8")
	image:setPixel(0, 0, 1, 1, 1, 1)

	Thread.WhiteTexture = lovr.graphics.newTexture(image, {
		type = "2d",
		format = "rgba8",
		linear = true,
		mipmaps = false,
		usage = {"sample"}
	})

	image:setPixel(0, 0, 0, 0, 0, 1)

	Thread.BlackTexture = lovr.graphics.newTexture(image, {
		type = "2d",
		format = "rgba8",
		linear = true,
		mipmaps = false,
		usage = {"sample"}
	})

	image:release()

	Thread.Events = EventDirector.Create(Thread)

	Thread.Keybinds.Interface.Select = Input.Create("InterfaceSelect")
	Thread.Keybinds.Interface.Select:SetMapping(Enum.Input.LeftMouseButton)
	Thread.Keybinds.Interface.Select:SetMapping(Enum.Input.MouseMovement)

	Thread.Keybinds.Interface.Scroll = Input.Create("InterfaceScroll")
	Thread.Keybinds.Interface.Scroll:SetMapping(Enum.Input.MouseWheelMovement)
	Thread.Keybinds.Interface.Scroll:SetMapping(Enum.Input.LeftControl)

	Thread.World = World.Create()
	Thread.Interface = Interface.Create()

	engineOptions = Thread.Load() or DEFAULT_ENGINE_OPTIONS

	lovr.system.openWindow(engineOptions.Window or DEFAULT_ENGINE_OPTIONS.Window)
	
	lovr.graphics.setBackgroundColor(0, 0, 0, 1)
	
	lovr.resize(lovr.system.getWindowDimensions())
	
	lovr.timer.step()
	
	return function()
		lovr.system.pollEvents()
		
		for name, a, b, c, d in lovr.event.poll() do
			if name == "restart" then
				return "restart", Thread.Restart()
			elseif name == "quit" then
				a = a or 0
				ThreadQuit(a)
				
				return a
			elseif lovr.handlers[name] then
				lovr.handlers[name](a, b, c, d)
			end
		end
		
		local deltaTime = lovr.timer.step()
		
		Timer.Update(deltaTime)
		
		Thread.Update(deltaTime)
		
		Thread.World:Update(deltaTime)
		Thread.Interface:Update(deltaTime)

		local windowPass = lovr.graphics.getWindowPass()
		windowPass:setClear({0, 0, 0, 1, depth = 1})

		Thread.World:Draw(windowPass)
		Thread.Interface:Draw(windowPass)

		lovr.graphics.submit(windowPass)
		lovr.graphics.present()
	end
end

return Thread