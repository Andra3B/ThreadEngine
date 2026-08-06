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

		renderPass:draw(Thread.Meshes.Cube.Mesh)

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

		lovr.graphics.submit(windowPass)
		lovr.graphics.present()
	end
end

return Thread