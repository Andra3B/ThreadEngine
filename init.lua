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

Assimp = require("Assimp")

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

Thread._Passes = {}

Thread.Shaders = {}
Thread.Meshes = {}
Thread.Materials = {}

Thread.LovrMatrixIdentity = nil
Thread.CubemapMatrices = table.new(7, 0)

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

	table.erase(Thread._Passes, LovrResourceRelease)

	Thread._SkyboxBlockHarmonicsBuffer:release()
	Thread._SkyboxBlockHarmonicsBuffer = nil
end

function Thread.Load() end
function Thread.Update(deltaTime) end
function Thread.PhysicsUpdate(deltaTime) end
function Thread.Quit(exitCode) end
function Thread.Restart() end

function Thread.AddPass(pass)
	table.insert(Thread._Passes, pass)
end

function Thread.UpdateSkybox(skybox)
	local mipmapCount = skybox.EnvironmentMap:getMipmapCount()
	local skyboxSize = skybox.EnvironmentMap:getWidth()

	for mipmap = 1, mipmapCount, 1 do
		local view = lovr.graphics.newTextureView(skybox.EnvironmentMap, {["mipmap"] = mipmap})
		local renderPass = lovr.graphics.newPass(view)
		view:release()

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

		renderPass:draw(Thread.Meshes.Cube.Mesh)

		Thread.AddPass(renderPass)
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

	Thread.AddPass(computePass)
end

local function GetASCIICharacterFromHexValue(hex)
	return string.char(tonumber(hex, 16))
end

local function URIToASCIIString(path)
	return string.gsub(path, "%%(%x%x)", GetASCIICharacterFromHexValue)
end

local function GetStringFromAiString(value)
	return value.length > 0 and ffi.string(value.data, value.length) or nil
end

local function GetMatrix4FromAiMatrix(transformation)
	return Matrix4.Create({
		transformation.a1, transformation.b1, transformation.c1, transformation.d1,
		transformation.a2, transformation.b2, transformation.c2, transformation.d2,
		transformation.a3, transformation.b3, transformation.c3, transformation.d3,
		transformation.a4, transformation.b4, transformation.c4, transformation.d4
	})
end

local function PointerToNumber(pointer)
	return tonumber(ffi.cast("uintptr_t", pointer))
end

local assimpFiles = {Active = 0}
local assimpFileCallbacks = {
	ReadProc = function(assimpFile, buffer, elementSize, count)
		local file = assimpFiles[PointerToNumber(assimpFile[0].UserData)][1]

		elementSize = tonumber(elementSize)
		count = tonumber(count)

		local content, bytesRead = file:read(elementSize * count)

		if content and bytesRead > 0 then
			ffi.copy(buffer, content, bytesRead)

			return bytesRead / elementSize
		end

		return 0
	end,

	WriteProc = function(assimpFile, buffer, elementSize, count)
		local file = assimpFiles[PointerToNumber(assimpFile[0].UserData)][1]

		elementSize = tonumber(elementSize)
		count = tonumber(count)

		local preWritePosition = file:tell()

		file:write(ffi.string(buffer, elementSize * count))

		return (file:tell() - preWritePosition) / elementSize
	end,

	TellProc = function(assimpFile)
		local file = assimpFiles[PointerToNumber(assimpFile[0].UserData)][1]

		return file:tell()
	end,

	FileSizeProc = function(assimpFile)
		local file = assimpFiles[PointerToNumber(assimpFile[0].UserData)][1]

		return file:getSize() or 0
	end,

	SeekProc = function(assimpFile, position, origin)
		local file = assimpFiles[PointerToNumber(assimpFile[0].UserData)][1]

		position = tonumber(position)

		if origin == Assimp.aiOrigin_SET then
			file:seek(position)
		elseif origin == Assimp.aiOrigin_CUR then
			file:seek(file:tell() + position)
		else
			file:seek(file:getSize() - position)
		end

		return Assimp.aiReturn_SUCCESS
	end,

	FlushProc = function(assimpFile)
	end
}

local assimpFileIO = ffi.new("aiFileIO[1]", {{
	OpenProc = function(_, path, mode)
		-- Paths may still be % encoded so convert it
		local file = lovr.filesystem.newFile(
			URIToASCIIString(ffi.string(path)),
			string.find(ffi.string(mode), "r", 1, true) and "r" or "w"
		)

		if file then
			local assimpFile = ffi.new("aiFile", {
				ReadProc = assimpFileCallbacks.ReadProc,
				WriteProc = assimpFileCallbacks.WriteProc,
				TellProc = assimpFileCallbacks.TellProc,
				FileSizeProc = assimpFileCallbacks.FileSizeProc,
				SeekProc = assimpFileCallbacks.SeekProc,
				FlushProc = assimpFileCallbacks.FlushProc,
				UserData = ffi.cast("char*", #assimpFiles + 1)
			})

			table.insert(assimpFiles, {file, assimpFile})
			assimpFiles.Active = assimpFiles.Active + 1

			return assimpFile
		end
	end,

	CloseProc = function(_, assimpFile)
		assimpFiles.Active = assimpFiles.Active - 1

		if assimpFiles.Active == 0 then
			while #assimpFiles > 0 do
				local currentAssimpFile = table.remove(assimpFiles)

				currentAssimpFile[1]:release()
				currentAssimpFile[1] = nil
				currentAssimpFile[2] = nil
			end
		end
	end
}})

local function LoadAssimpScene(path)
	if type(path) == "cdata" then
		return path, false
	elseif type(path) == "string" then
		local properties = Assimp.aiCreatePropertyStore()

		Assimp.aiSetImportPropertyInteger(
			properties, Assimp.AI_CONFIG_PP_RVC_FLAGS,
			bit.bor(Assimp.aiComponent_LIGHTS, Assimp.aiComponent_CAMERAS)
		)
		Assimp.aiSetImportPropertyInteger(properties, Assimp.AI_CONFIG_PP_LBW_MAX_WEIGHTS, 4)
		Assimp.aiSetImportPropertyInteger(properties, Assimp.AI_CONFIG_IMPORT_FBX_PRESERVE_PIVOTS, 0)

		local scene = Assimp.aiImportFileExWithProperties(
			path,
			bit.bor(
				Assimp.aiProcess_CalcTangentSpace,
				Assimp.aiProcess_JoinIdenticalVertices,
				Assimp.aiProcess_Triangulate,
				Assimp.aiProcess_RemoveComponent,
				Assimp.aiProcess_LimitBoneWeights,
				Assimp.aiProcess_ValidateDataStructure,
				Assimp.aiProcess_ImproveCacheLocality,
				Assimp.aiProcess_FixInfacingNormals,
				Assimp.aiProcess_PopulateArmatureData,
				Assimp.aiProcess_GenUVCoords,
				Assimp.aiProcess_TransformUVCoords,
				Assimp.aiProcess_GenBoundingBoxes,
				Assimp.aiProcess_FlipUVs
			),
			assimpFileIO,
			properties
		)
		
		Assimp.aiReleasePropertyStore(properties)

		if scene == nil then
			return nil, false, "Failed to import \""..path.."\"!: "..ffi.string(Assimp.aiGetErrorString())
		else
			return scene, true
		end
	end
end

local function PopulateCacheNodes(node, cache, depth)
	local nodeInfo = {
		Node = node,
		Name = GetStringFromAiString(node.mName),
		Class = Body,
		Depth = depth,
		Parent = cache.Nodes[PointerToNumber(node.mParent)],
		Object = nil
	}

	cache.Nodes[PointerToNumber(node)] = nodeInfo

	table.insert(cache.OrderedNodes, nodeInfo)

	for index = 0, node.mNumChildren - 1, 1 do
		PopulateCacheNodes(node.mChildren[index], cache, depth + 1)
	end
end

local function GetLowestCommonAncestorNode(a, b)
	while a.Depth > b.Depth do
		a = a.Parent
	end

	while a.Depth < b.Depth do
		b = b.Parent
	end

	while a ~= b do
		a = a.Parent
		b = b.Parent
	end

	return a
end

local function CreateCacheFromScene(sourcePath, scene)
	local cache = {
		Nodes = {},
		OrderedNodes = {},
		Meshes = {},
		Materials = {},
		Textures = {},
		Samplers = {},
		Animations = {},
		SourceDirectory = string.match(sourcePath, "(.+[/\\])")
	}

	PopulateCacheNodes(scene.mRootNode, cache, 0)

	for _, nodeInfo in ipairs(cache.OrderedNodes) do
		local node = nodeInfo.Node

		for index = 0, node.mNumMeshes - 1, 1 do
			local mesh = scene.mMeshes[node.mMeshes[index]]
			local skeleton = nil

			for boneIndex = 0, mesh.mNumBones - 1, 1 do
				local bone = mesh.mBones[boneIndex]
				local boneInfo = cache.Nodes[PointerToNumber(bone.mNode)]

				boneInfo.Class = Bone
				boneInfo.BoneIndex = boneIndex
				boneInfo.InverseBindMatrix = GetMatrix4FromAiMatrix(bone.mOffsetMatrix)

				skeleton = skeleton and GetLowestCommonAncestorNode(skeleton, boneInfo) or boneInfo
			end

			if skeleton then
				if skeleton.Class == Bone then
					skeleton = skeleton.Parent
				end

				skeleton.Class = Skeleton
			end
		end
	end

	return cache
end

local GL_NEAREST = 9728
local GL_LINEAR = 9729
local GL_NEAREST_MIPMAP_NEAREST = 9984
local GL_NEAREST_MIPMAP_LINEAR = 9986
local GL_LINEAR_MIPMAP_LINEAR = 9987

local TEXTURE_WRAP_MODES = {
	[Assimp.aiTextureMapMode_Wrap] = "repeat",
	[Assimp.aiTextureMapMode_Clamp] = "clamp",
	[Assimp.aiTextureMapMode_Mirror] = "mirror",
	[Assimp.aiTextureMapMode_Decal] = "clamp"
}

local function GetMaterialInteger(material, key, textureType, default)
	local value = ffi.new("int[1]")

	return 
		Assimp.aiGetMaterialIntegerArray(material, key, textureType or 0, 0, value, nil) == Assimp.aiReturn_SUCCESS and
		value[0] or
		default
end

local function GetMaterialFloat(material, key, textureType, default)
	local value = ffi.new("ai_real[1]")

	return 
		Assimp.aiGetMaterialFloatArray(material, key, textureType or 0, 0, value, nil) == Assimp.aiReturn_SUCCESS and
		value[0] or
		default
end

local function GetMaterialColour(material, key, default)
	local colour = ffi.new("aiColor4D[1]")

	return
		Assimp.aiGetMaterialColor(material, key, 0, 0, colour) == Assimp.aiReturn_SUCCESS and
		Vector4.Create(colour[0].r, colour[0].g, colour[0].b, colour[0].a) or
		default
end

local function GetMaterialString(material, key, default)
	local stringData = ffi.new("aiString[1]")

	return
		Assimp.aiGetMaterialString(material, key, 0, 0, stringData) == Assimp.aiReturn_SUCCESS and
		GetStringFromAiString(stringData[0]) or
		default
end

local function GetMaterialUVChannel(material)
	local path = ffi.new("aiString[1]")
	local uvChannel = ffi.new("unsigned int[1]")

	return (
		Assimp.aiGetMaterialTexture(material, Assimp.aiTextureType_BASE_COLOR, 0, path, nil, uvChannel, nil, nil, nil, nil) == Assimp.aiReturn_SUCCESS or
		Assimp.aiGetMaterialTexture(material, Assimp.aiTextureType_DIFFUSE, 0, path, nil, uvChannel, nil, nil, nil, nil) == Assimp.aiReturn_SUCCESS
	) and uvChannel[0] or 0
end

local function FindEmbeddedTexture(scene, textureFilename)
	if string.sub(textureFilename, 1, 1) == "*" then
		return tonumber(string.sub(textureFilename, 2))
	end

	for index = 0, scene.mNumTextures - 1, 1 do
		if string.match(GetStringFromAiString(scene.mTextures[index].mFilename), "[^/\\]*$") == textureFilename then
			return index
		end
	end
end

local function LoadTexture(scene, material, textureTypes, linear, cache)
	local texturePath = ffi.new("aiString[1]")
	local textureWrapping = ffi.new("aiTextureMapMode[2]")

	for _, textureType in ipairs(textureTypes) do
		textureWrapping[0] = Assimp.aiTextureMapMode_Wrap
		textureWrapping[1] = Assimp.aiTextureMapMode_Wrap

		if Assimp.aiGetMaterialTexture(
			material, textureType, 0,
			texturePath, nil, nil,
			nil, nil, textureWrapping, nil
		) == Assimp.aiReturn_SUCCESS then
			local luaTexturePath = GetStringFromAiString(texturePath[0])

			local textureFilename = string.match(luaTexturePath, "[^/\\]*$")
			local textureIndex = FindEmbeddedTexture(scene, textureFilename)

			local texture = cache.Textures[textureIndex or textureFilename]

			if not texture then
				if textureIndex then
					local textureData = scene.mTextures[textureIndex]

					if textureData.mHeight == 0 then
						local textureBlob = lovr.data.newBlob(textureData.mWidth)
						ffi.copy(textureBlob:getPointer(), textureData.pcData, textureData.mWidth)

						texture = lovr.graphics.newTexture(textureBlob, {
							type = "2d",
							linear = linear,
							mipmaps = true,
							usage = {"sample"}
						})

						textureBlob:release()
					else
						local texelCount = textureData.mWidth * textureData.mHeight

						local textureBlob = lovr.data.newBlob(texelCount * 4)
						local pixels = ffi.cast("uint8_t*", textureBlob:getPointer())
						local texels = textureData.pcData

						for index = 0, texelCount - 1, 1 do
							local texel = texels[index]
							local offset = index * 4

							pixels[offset] = texel.r
							pixels[offset + 1] = texel.g
							pixels[offset + 2] = texel.b
							pixels[offset + 3] = texel.a
						end

						local image = lovr.data.newImage(width, height, "rgba8", textureBlob)
						texture = lovr.graphics.newTexture(image, {
							type = "2d",
							linear = linear,
							mipmaps = true,
							usage = {"sample"}
						})

						image:release()
						textureBlob:release()
					end
				else
					texture = lovr.graphics.newTexture(cache.SourceDirectory..textureFilename, {
						type = "2d",
						linear = linear,
						mipmaps = true,
						usage = {"sample"}
					})

					cache.Textures[textureFilename] = texture
				end

				if texture then
					local minFilter = GetMaterialInteger(material, Assimp._AI_MATKEY_GLTF_MAPPINGFILTER_MIN_BASE, textureType, GL_LINEAR_MIPMAP_LINEAR)
					local magFilter = GetMaterialInteger(material, Assimp._AI_MATKEY_GLTF_MAPPINGFILTER_MAG_BASE, textureType, GL_LINEAR)
					local wrapU = TEXTURE_WRAP_MODES[textureWrapping[0]] or "repeat"
					local wrapV = TEXTURE_WRAP_MODES[textureWrapping[1]] or "repeat"

					local samplerKey = minFilter..":"..magFilter..":"..wrapU..":"..wrapV
					local sampler = cache.Samplers[samplerKey]

					if not sampler then
						local samplerOptions = {
							filter = {
								(minFilter == GL_NEAREST or minFilter == GL_NEAREST_MIPMAP_NEAREST or minFilter == GL_NEAREST_MIPMAP_LINEAR) and "nearest" or "linear",
								magFilter == GL_NEAREST and "nearest" or "linear",
								(minFilter == GL_NEAREST_MIPMAP_LINEAR or minFilter == GL_LINEAR_MIPMAP_LINEAR) and "linear" or "nearest"
							},
							wrap = {wrapU, wrapV, "repeat"}
						}

						-- Non-mipmapped filters sample the base level only
						if minFilter == GL_NEAREST or minFilter == GL_LINEAR then
							samplerOptions.mipmaprange = {0, 0}
						end

						sampler = lovr.graphics.newSampler(samplerOptions)
						cache.Samplers[samplerKey] = sampler
					end
					
					texture:setSampler(sampler)

					cache.Textures[textureIndex or textureFilename] = texture
				end
			end
			
			return texture, textureType
		end
	end
end

local function LoadMaterial(scene, index, cache)
	local material = cache.Materials[index]

	if material then
		return material
	end

	local materialData = scene.mMaterials[index - 1]

	material = Material.Create()
	material.Name = GetMaterialString(materialData, Assimp.AI_MATKEY_NAME)

	local colour =
		GetMaterialColour(materialData, Assimp.AI_MATKEY_BASE_COLOR) or
		GetMaterialColour(materialData, Assimp.AI_MATKEY_COLOR_DIFFUSE)
	
	if colour then
		colour.W = GetMaterialFloat(materialData, Assimp.AI_MATKEY_OPACITY, 0, colour.W)
		material.Colour = colour
	end

	material.ColourTexture = LoadTexture(
		scene, materialData,
		{Assimp.aiTextureType_BASE_COLOR, Assimp.aiTextureType_DIFFUSE},
		false, cache
	)

	local glowTexture = LoadTexture(
		scene, materialData,
		{Assimp.aiTextureType_EMISSION_COLOR, Assimp.aiTextureType_EMISSIVE},
		false, cache
	)

	colour = GetMaterialColour(materialData, Assimp.AI_MATKEY_COLOR_EMISSIVE)
	local glowStrength = GetMaterialFloat(materialData, Assimp.AI_MATKEY_EMISSIVE_INTENSITY, 0, 1)

	if colour then
		colour.W = glowStrength
		material.Glow = colour
	elseif glowTexture then
		material.Glow = Vector4.Create(1, 1, 1, glowStrength)
	end

	material.GlowTexture = glowTexture

	local metalness = GetMaterialFloat(materialData, Assimp.AI_MATKEY_METALLIC_FACTOR, 0)

	if metalness then
		material.Metalness = metalness
	end

	material.MetalnessTexture = LoadTexture(
		scene, materialData,
		{Assimp.aiTextureType_METALNESS},
		true, cache
	)

	local roughness = GetMaterialFloat(materialData, Assimp.AI_MATKEY_ROUGHNESS_FACTOR, 0)

	if roughness then
		material.Roughness = roughness
	end

	material.RoughnessTexture = LoadTexture(
		scene, materialData,
		{Assimp.aiTextureType_DIFFUSE_ROUGHNESS},
		true, cache
	)

	local normalTexture, normalType = LoadTexture(
		scene, materialData,
		{Assimp.aiTextureType_NORMALS},
		true, cache
	)

	if normalTexture then
		material.NormalTexture = normalTexture
		material.NormalScale = GetMaterialFloat(materialData, Assimp._AI_MATKEY_GLTF_SCALE_BASE, normalType, 1)
	end

	local occlusionTexture, occlusionType = LoadTexture(
		scene, materialData,
		{Assimp.aiTextureType_AMBIENT_OCCLUSION, Assimp.aiTextureType_LIGHTMAP},
		true, cache
	)

	if occlusionTexture then
		material.OcclusionTexture = occlusionTexture
		material.OcclusionStrength = GetMaterialFloat(materialData, Assimp._AI_MATKEY_GLTF_STRENGTH_BASE, occlusionType, 1)
	end

	cache.Materials[index] = material

	return material
end

function Thread.LoadMaterials(path, index, cache)
	local result = nil
	
	local scene, destroyData, errorMessage = LoadAssimpScene(path)
	
	if scene ~= nil then
		cache = cache or CreateSceneCache(path, scene)

		if index then
			if index >= 1 and index <= scene.mNumMaterials then
				result = LoadMaterial(scene, index, cache)
			else
				errorMessage = "Material "..tostring(index).." doesn't exist!"
			end
		else
			result = {}

			for index = 1, scene.mNumMaterials, 1 do
				table.insert(result, LoadMaterial(scene, index, cache))
			end
		end

		if destroyData then
			Assimp.aiReleaseImport(scene)
		end
	end

	return result, cache, errorMessage
end

local function LoadMesh(scene, index, cache)
	local mesh = cache.Meshes[index]

	if mesh then
		return mesh
	end

	local meshData = scene.mMeshes[index - 1]

	if meshData.mPrimitiveTypes == Assimp.aiPrimitiveType_TRIANGLE then
		local vertices = table.new(meshData.mNumVertices, 0)

		local containsTangents = meshData.mTangents ~= nil
		local containsColours = meshData.mColors[0] ~= nil
		local uvChannel = GetMaterialUVChannel(scene.mMaterials[meshData.mMaterialIndex])
		local containsUVs =
			meshData.mTextureCoords[uvChannel] ~= nil and
			meshData.mNumUVComponents[uvChannel] == 2
		local containsBones = meshData.mNumBones > 0
		
		local vertexSize =
			6 + (containsTangents and 3 or 0) + (containsColours and 3 or 0) + (containsUVs and 2 or 0) + (containsBones and 8 or 0)
		
		local vertexFormat = {
			{"VertexPosition", "vec3"},
			{"VertexNormal", "vec3"}
		}

		if containsTangents then
			table.insert(vertexFormat, {"VertexTangent", "vec3"})
		end

		if containsColours then
			table.insert(vertexFormat, {"VertexColor", "vec3"})
		end

		if containsUVs then
			table.insert(vertexFormat, {"VertexUV", "vec2"})
		end

		if containsBones then
			table.insert(vertexFormat, {"VertexBoneIndices", "u8x4"})
			table.insert(vertexFormat, {"VertexBoneWeights", "un8x4"})
		end
			
		for vertexIndex = 1, meshData.mNumVertices, 1 do
			local vertex = table.new(vertexSize, 0)

			local vertexPositionData = meshData.mVertices[vertexIndex - 1]
			local vertexNormalData = meshData.mNormals[vertexIndex - 1]
			local vertexTangentData = meshData.mTangents[vertexIndex - 1]
			local vertexColourData = containsColours and meshData.mColors[0][vertexIndex - 1]
			local vertexUVData = containsUVs and meshData.mTextureCoords[uvChannel][vertexIndex - 1]

			vertex[1] = vertexPositionData.x
			vertex[2] = vertexPositionData.y
			vertex[3] = vertexPositionData.z

			vertex[4] = vertexNormalData.x
			vertex[5] = vertexNormalData.y
			vertex[6] = vertexNormalData.z

			if containsTangents then
				vertex[7] = vertexTangentData.x
				vertex[8] = vertexTangentData.y
				vertex[9] = vertexTangentData.z
			end

			if containsColours then
				table.insert(vertex, vertexColourData.r)
				table.insert(vertex, vertexColourData.g)
				table.insert(vertex, vertexColourData.b)
			end

			if containsUVs then
				table.insert(vertex, vertexUVData.x)
				table.insert(vertex, vertexUVData.y)
			end

			if containsBones then
				table.insert(vertex, 0)
				table.insert(vertex, 0)
				table.insert(vertex, 0)
				table.insert(vertex, 0)

				table.insert(vertex, 0)
				table.insert(vertex, 0)
				table.insert(vertex, 0)
				table.insert(vertex, 0)
			end

			vertices[vertexIndex] = vertex
		end

		local skeleton = nil

		if containsBones then
			local slotCounts = table.new(meshData.mNumVertices, 0)
			local indexOffset = vertexSize - 8
			local weightOffset = vertexSize - 4

			for index = 1, #vertices, 1 do
				slotCounts[index] = 0
			end

			for boneIndex = 0, meshData.mNumBones - 1, 1 do
				local bone = meshData.mBones[boneIndex]
				local boneInfo = cache.Nodes[PointerToNumber(bone.mNode)]

				if not skeleton then
					repeat
						skeleton = boneInfo.Parent
					until skeleton.Class == Skeleton
				end

				for weightIndex = 0, bone.mNumWeights - 1, 1 do
					local weightData = bone.mWeights[weightIndex]
					local vertexIndex = weightData.mVertexId + 1
					local vertex = vertices[vertexIndex]
					local slot = slotCounts[vertexIndex] + 1

					if weightData.mWeight > 0 and slot <= 4 then
						vertex[indexOffset + slot] = boneInfo.BoneIndex
						vertex[weightOffset + slot] = weightData.mWeight

						slotCounts[vertexIndex] = slot
					end
				end
			end

			for vertexIndex = 1, #vertices, 1 do
				local vertex = vertices[vertexIndex]
				local weightSum = vertex[weightOffset + 1] + vertex[weightOffset + 2] + vertex[weightOffset + 3] + vertex[weightOffset + 4]

				if weightSum == 0 then
					-- No influences then follow the first bone rather than collapsing to the origin
					vertex[weightOffset + 1] = 1
				else
					vertex[weightOffset + 1] = vertex[weightOffset + 1] / weightSum
					vertex[weightOffset + 2] = vertex[weightOffset + 2] / weightSum
					vertex[weightOffset + 3] = vertex[weightOffset + 3] / weightSum
					vertex[weightOffset + 4] = vertex[weightOffset + 4] / weightSum
				end
			end

			if meshData.mNumBones > 256 then
				Log.Warn("Thread", "Skeleton \"%s\" has %d bones; only 256 are supported!", skeleton.Name, meshData.mNumBones)
			end
		end

		local indices = table.new(meshData.mNumFaces * 3, 0)

		for faceIndex = 0, meshData.mNumFaces - 1, 1 do
			local face = meshData.mFaces[faceIndex]

			local offset = faceIndex * 3 + 1

			indices[offset] = face.mIndices[0] + 1
			indices[offset + 1] = face.mIndices[1] + 1
			indices[offset + 2] = face.mIndices[2] + 1
		end
		
		local meshAABBData = meshData.mAABB
		local meshAABB = Extents3.Create(
			meshAABBData.mMin.x, meshAABBData.mMin.y, meshAABBData.mMin.z,
			meshAABBData.mMax.x, meshAABBData.mMax.y, meshAABBData.mMax.z
		) 

		local lovrMesh = lovr.graphics.newMesh(vertexFormat, vertices, {storage = "gpu"})

		lovrMesh:setIndices(indices)
		lovrMesh:setDrawMode("triangles")
		lovrMesh:setBoundingBox(
			meshAABB.Min.X, meshAABB.Min.Y, meshAABB.Min.Z,
			meshAABB.Max.X, meshAABB.Max.Y, meshAABB.Max.Z
		)

		mesh = Mesh.Create(lovrMesh, meshAABB)

		mesh.Name = GetStringFromAiString(meshData.mName)

		mesh.Material = Thread.LoadMaterials(scene, meshData.mMaterialIndex + 1, cache)

		mesh.Skeleton = skeleton and skeleton.Name or nil
		
		mesh.DoubleSided = GetMaterialInteger(
			scene.mMaterials[meshData.mMaterialIndex],
			Assimp.AI_MATKEY_TWOSIDED
		)

		cache.Meshes[index] = mesh
	else
		errorMessage = "Meshes can only consist of triangle or polygon primitives!"
	end

	return mesh, errorMessage
end

function Thread.LoadMeshes(path, index, cache)
	local result = nil

	local scene, destroyData, errorMessage = LoadAssimpScene(path)
	
	if scene ~= nil then
		cache = cache or CreateCacheFromScene(path, scene)

		if index then
			if index >= 1 and index <= scene.mNumMeshes then
				result = LoadMesh(scene, index, cache)
			else
				errorMessage = "Mesh "..tostring(index).." doesn't exist!"
			end
		else
			result = {}

			for index = 1, scene.mNumMeshes, 1 do
				table.insert(result, LoadMesh(scene, index, cache))
			end
		end

		if destroyData then
			Assimp.aiReleaseImport(scene)
		end
	end

	return result, cache, errorMessage
end

local function AddAnimationChannel(animation, target, property, keys, keyCount, ticksPerSecond)
	if keyCount == 0 then
		return
	end

	local propertyType =
		property == "Orientation" and Enum.AnimationPropertyType.Quaternion or
		Enum.AnimationPropertyType.Vector

	local smoothing =
		keys[0].mInterpolation == Assimp.aiAnimInterpolation_Step and Enum.AnimationSmoothing.Step or
		Enum.AnimationSmoothing.Linear

	local channel = AnimationChannel.Create(target, property, propertyType, smoothing)

	for keyIndex = 0, keyCount - 1, 1 do
		local key = keys[keyIndex]
		local value = key.mValue

		channel:AddKeyframe(
			key.mTime / ticksPerSecond,
			propertyType == Enum.AnimationPropertyType.Quaternion and
			Quaternion.Create(value.w, value.x, value.y, value.z) or
			Vector3.Create(value.x, value.y, value.z)
		)
	end

	animation:AddChannel(channel)
end

local function LoadAnimation(scene, index, cache)
	local animation = cache.Animations[index]

	if animation then
		return animation
	end

	local animationData = scene.mAnimations[index - 1]

	animation = Animation.Create()
	animation.Name = GetStringFromAiString(animationData.mName)

	local ticksPerSecond = animationData.mTicksPerSecond > 0 and animationData.mTicksPerSecond or 25

	for channelIndex = 0, animationData.mNumChannels - 1, 1 do
		local channelData = animationData.mChannels[channelIndex]
		local target = GetStringFromAiString(channelData.mNodeName)

		if target then
			AddAnimationChannel(animation, target, "Position", channelData.mPositionKeys, channelData.mNumPositionKeys, ticksPerSecond)
			AddAnimationChannel(animation, target, "Orientation", channelData.mRotationKeys, channelData.mNumRotationKeys, ticksPerSecond)
			AddAnimationChannel(animation, target, "Scale", channelData.mScalingKeys, channelData.mNumScalingKeys, ticksPerSecond)
		end
	end

	cache.Animations[index] = animation

	return animation
end

function Thread.LoadAnimations(path, index, cache)
	local result = nil

	local scene, destroyData, errorMessage = LoadAssimpScene(path)

	if scene ~= nil then
		cache = cache or CreateCacheFromScene(path, scene)

		if index then
			if index >= 1 and index <= scene.mNumAnimations then
				result = LoadAnimation(scene, index, cache)
			else
				errorMessage = "Animation "..tostring(index).." doesn't exist!"
			end
		else
			result = {}

			for index = 1, scene.mNumAnimations, 1 do
				table.insert(result, LoadAnimation(scene, index, cache))
			end
		end

		if destroyData then
			Assimp.aiReleaseImport(scene)
		end
	end

	return result, cache, errorMessage
end

function Thread.LoadModel(path, cache)
	local result = nil

	local scene, destroyScene, errorMessage = LoadAssimpScene(path)

	if scene ~= nil then
		cache = cache or CreateCacheFromScene(path, scene)

		local modelInfo = cache.OrderedNodes[1]
		modelInfo.Class = Model

		local objects = {}

		for _, nodeInfo in ipairs(cache.OrderedNodes) do
			local node = nodeInfo.Node

			local object = nodeInfo.Class.Create()

			if nodeInfo.Class == Bone then
				object._BoneIndex = nodeInfo.BoneIndex
				object.InverseBindMatrix = nodeInfo.InverseBindMatrix
			end

			local localTransform = GetMatrix4FromAiMatrix(nodeInfo.Node.mTransformation)

			object.Position = localTransform.Position
			object.Orientation = localTransform.Orientation
			object.Scale = localTransform.Scale

			object.Name = nodeInfo.Name or nodeInfo.Class.Type

			nodeInfo.Object = object

			if nodeInfo.Parent then
				object.Parent = nodeInfo.Parent.Object
			end

			for index = 0, node.mNumMeshes - 1, 1 do
				local mesh = Thread.LoadMeshes(scene, node.mMeshes[index] + 1, cache)

				if mesh then
					mesh.Parent = object
				end
			end

			objects[object.Name] = object
		end

		for animationIndex = 0, tonumber(scene.mNumAnimations) - 1, 1 do
			local animationData = scene.mAnimations[animationIndex]
 
			for channelIndex = 0, tonumber(animationData.mNumChannels) - 1, 1 do
				local target = GetStringFromAiString(animationData.mChannels[channelIndex].mNodeName)
 
				if objects[target] then
					Thread.LoadAnimations(scene, animationIndex + 1, cache).Parent = modelInfo.Object
					
					break
				end
			end
		end

		result = modelInfo.Object

		if destroyScene then
			Assimp.aiReleaseImport(scene)
		end
	end

	return result, cache, errorMessage
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

	Thread.Shaders.World = lovr.graphics.newShader(
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

	Thread.Meshes.Square = Mesh.Create(square)

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
	
	Thread.Meshes.Cube = Mesh.Create(cube)

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

		Thread.AddPass(windowPass)

		lovr.graphics.submit(Thread._Passes)
		lovr.graphics.present()

		table.erase(Thread._Passes, LovrResourceRelease)
	end
end

return Thread