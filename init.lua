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

table.new = require("table.new")
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
WorldNode = require("World.WorldNode")
Model = require("World.Model")
Body = require("World.Body")
Camera = require("World.Camera")
Skybox = require("World.Skybox")
Light = require("World.Lights.Light")
PointLight = require("World.Lights.PointLight")

InterfaceObject = require("Interface.InterfaceObject")
Interface = require("Interface.Interface")
Frame = require("Interface.Frame")
Label = require("Interface.Label")

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

Thread.Events = nil

Thread.World = nil
Thread.Interface = nil

Thread.SkyboxUpdatePass = nil
Thread.SkyboxUpdateMatrices = table.new(0, 7)

Thread.DefaultSkybox = nil

Thread.LovrMatrixIdentity = nil

Thread.Shaders = {}
Thread.Meshes = {}

local function LovrResourceRelease(resource)
	resource:release()
end

local function ThreadQuit(exitCode)
	Thread.Quit(exitCode)

	Timer.DestroyTimers()
	Input.DestroyInputs()

	table.erase(Thread.Shaders, LovrResourceRelease)
	table.erase(Thread.Meshes, LovrResourceRelease)

	Thread.SkyboxUpdatePass:release()
	Thread.SkyboxUpdatePass = nil

	table.erase(Thread.SkyboxUpdateMatrices)

	Thread.DefaultSkybox:Destroy()
	Thread.DefaultSkybox = nil

	Thread.LovrMatrixIdentity = nil

	Thread.Interface:Destroy()
	Thread.Interface = nil

	Thread.World:Destroy()
	Thread.World = nil

	Thread.Events:Destroy()
	Thread.Events = nil
end

function Thread.Load() end
function Thread.Update(deltaTime) end
function Thread.Quit(exitCode) end
function Thread.Restart() end 

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
	Thread.Events = EventDirector.Create(Thread)

	Thread.SkyboxUpdatePass = lovr.graphics.newPass()

	Thread.SkyboxUpdateMatrices[1] = lovr.math.newMat4(Matrix4.CreatePerspectiveProjection(1, math.rad(90), 0.1, 1):Unpack())
	Thread.SkyboxUpdateMatrices[2] = lovr.math.newMat4(Matrix4.CreateTransform(Vector3.Zero, Vector3.Create(0, math.rad(-90), 0)):Unpack()) -- +X
	Thread.SkyboxUpdateMatrices[3] = lovr.math.newMat4(Matrix4.CreateTransform(Vector3.Zero, Vector3.Create(0, math.rad(90), 0)):Unpack())	-- -X
	Thread.SkyboxUpdateMatrices[4] = lovr.math.newMat4(Matrix4.CreateTransform(Vector3.Zero, Vector3.Create(math.rad(90), 0, 0)):Unpack())	-- +Y
	Thread.SkyboxUpdateMatrices[5] = lovr.math.newMat4(Matrix4.CreateTransform(Vector3.Zero, Vector3.Create(math.rad(-90), 0, 0)):Unpack())	-- -Y
	Thread.SkyboxUpdateMatrices[6] = lovr.math.newMat4(Matrix4.CreateTransform(Vector3.Zero, Vector3.Create(0, math.rad(0), 0)):Unpack())	-- +Z
	Thread.SkyboxUpdateMatrices[7] = lovr.math.newMat4(Matrix4.CreateTransform(Vector3.Zero, Vector3.Create(0, math.rad(180), 0)):Unpack())	-- -Z

	Thread.DefaultSkybox = Skybox.Create("Assets/Skyboxes/CloudySky.hdr")

	Thread.LovrMatrixIdentity = lovr.math.newMat4()

	Thread.World = World.Create()
	Thread.Interface = Interface.Create()

	Thread.Shaders.Interface = lovr.graphics.newShader(
		"Assets/Shaders/Interface.vert",
		"Assets/Shaders/Interface.frag",
		{label = "Interface"}
	)

	Thread.Shaders.World = lovr.graphics.newShader(
		"Assets/Shaders/World.vert",
		"Assets/Shaders/World.frag",
		{label = "World", flags = {
			tonemap = true
		}}
	)

	Thread.Shaders.Skybox = lovr.graphics.newShader(
		"Assets/Shaders/Skybox.vert",
		"Assets/Shaders/Skybox.frag",
		{label = "Skybox"}
	)

	Thread.Shaders.SkyboxUpdate = lovr.graphics.newShader(
		"Assets/Shaders/World.vert",
		"Assets/Shaders/SkyboxUpdate.frag",
		{label = "SkyboxUpdate"}
	)

	Thread.Meshes.Square = lovr.graphics.newMesh({
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

	Thread.Meshes.Square:setIndices({
		1, 2, 3,
		1, 3, 4
	})

	Thread.Meshes.Cube = lovr.graphics.newMesh({
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

	Thread.Meshes.Cube:setIndices({
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

		Skybox.Update(Thread.SkyboxUpdatePass)

		local windowPass = lovr.graphics.getWindowPass()

		Thread.World:Draw(windowPass)
		Thread.Interface:Draw(windowPass)

		lovr.graphics.submit(Thread.SkyboxUpdatePass, windowPass)
		lovr.graphics.present()
	end
end

return Thread