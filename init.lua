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

Thread.Interface = nil

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

	Thread.Interface:Destroy()
	Thread.Interface = nil

	Thread.Events:Destroy()
	Thread.Events = nil
end

function Thread.Load() end
function Thread.Update(deltaTime) end
function Thread.Quit(exitCode) end
function Thread.Restart() end 

function lovr.keypressed(key) Input.TriggerInput("k_"..key, Vector3.Backward, false) end
function lovr.keyreleased(key) Input.TriggerInput("k_"..key, Vector3.Backward, true) end
function lovr.mousemoved(x, y, dx, dy) Input.TriggerInput("m_movement", Vector3.Create(dx, dy, nil)) end
function lovr.wheelmoved(dx, dy) Input.TriggerInput("m_wheelmovement", Vector3.Create(dx, dy, nil)) end
function lovr.mousepressed(x, y, button) Input.TriggerInput(MOUSE_INPUTS[button], Vector3.Backward, false) end
function lovr.mousereleased(x, y, button) Input.TriggerInput(MOUSE_INPUTS[button], Vector3.Backward, true) end

function lovr.errhand(message)
	Log.Error("Thread", debug.traceback(tostring(message), 2):gsub("\n[^\n]+$", ""))

	ThreadQuit(1)
end

function lovr.resize(width, height)
	Thread.Interface.AbsoluteSize = Vector2.Create(width, height)
	Thread.Interface.Projection = Matrix4.CreateInterfaceProjection(width, height)
end

function lovr.run()
	Thread.Events = EventDirector.Create(Thread)
	Thread.Interface = Interface.Create()
	
	engineOptions = Thread.Load() or DEFAULT_ENGINE_OPTIONS

	lovr.system.openWindow(engineOptions.Window or DEFAULT_ENGINE_OPTIONS.Window)
	
	lovr.graphics.setBackgroundColor(0, 0, 0, 1)

	local windowPass = lovr.graphics.getWindowPass()
	
	windowPass:setWinding("counterclockwise")
	windowPass:setDepthTest("none")
	windowPass:setDepthWrite(false)

	Thread.Shaders.Interface = lovr.graphics.newShader(
		"Assets/Shaders/Interface.vert",
		"Assets/Shaders/Interface.frag",
		{label = "Interface"}
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

		local windowPass = lovr.graphics.getWindowPass()

		windowPass:push("state")
		Thread.Interface:Draw(windowPass)
		windowPass:pop("state")

		lovr.graphics.submit(windowPass)
		lovr.graphics.present()
	end
end

return Thread