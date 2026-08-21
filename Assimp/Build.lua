if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
	require("lldebugger").start()
end

local clPath = ...

CBindings = require("CBindings")

os.remove("Assimp/init.lua")

local errorMessage, defines, declarations = CBindings.ParseHeader("Assimp/assimp.h", {"Assimp"}, false, clPath)

if not errorMessage then
	errorMessage = CBindings.CreateBindings(
		"Assimp/init.lua",
		"Assimp/assimp.dll",
		defines,
		declarations,
		false
	)
end

if errorMessage then
	print(errorMessage)
end