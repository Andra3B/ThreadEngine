CBindings = require("CBindings")

os.remove("cgltf/cgltf.dll")
os.remove("cgltf/init.lua")

local errorMessage, defines, declarations = CBindings.ParseHeader("cgltf/cgltf_build.h", {"cgltf"}, false)

if errorMessage then
	print(errorMessage)
else
	errorMessage = CBindings.CreateBindings(
		"cgltf/init.lua",
		"cgltf/cgltf.dll",
		defines,
		declarations,
		false
	)

	if errorMessage then
		print(errorMessage)
	else
		os.execute("gcc cgltf/cgltf_build.c -O3 -shared -o cgltf/cgltf.dll -I cgltf")
	end
end