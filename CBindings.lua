local ffi = require("ffi")

local CBindings = {}

function CBindings.ParseHeader(headerPath, includePaths, preprocessed, gccPath)
	gccPath = gccPath or "gcc"

	if not preprocessed then
		local command = gccPath.." -E -dD -P -o CBindingsPreprocessedHeader.i \""..headerPath.."\""

		if includePaths then
			for _, path in ipairs(includePaths) do
				command = command.." -I \""..path.."\""
			end
		end

		os.execute(command)

		headerPath = "CBindingsPreprocessedHeader.i"
	end

	local headerFile, errorMessage = io.open(headerPath, "r")

	local defines = {}
	local finalDeclarationString = ""
	
	if headerFile then
		local declarationString = ""

		for line in headerFile:lines() do
			local preprocessorDirective = string.match(line, "^%s*#([%w_]+)")

			if preprocessorDirective then
				if preprocessorDirective == "define" then
					local name, value = string.match(line,"^%s*#define ([%w_]+) (.*)")

					if name then
						if not (string.find(value, "\"", 1, true) or string.find(value, "0x", 1, true)) then
							value = string.gsub(value, "(%d+)[UuLlFf]+$", "%1")
						end

						local chunk = load("return "..value, nil, "t", defines)

						if chunk then
							local success, value = pcall(chunk)

							if success then
								defines[name] = value
							end
						end
					end
				elseif preprocessorDirective == "undef" then
					local name = string.match(line,"^%s*#undef ([%w_]+)")

					if name then
						defines[name] = nil
					end
				end
			elseif string.find(line, "%g") and not string.find(line, "^%s*%[%[") then
				declarationString = declarationString..line.."\n"

				if string.find(declarationString, ";", 1, true) then
					local braceCount = 0

					for brace in string.gmatch(declarationString, "[{}]") do
						braceCount = braceCount + (brace == "{" and 1 or -1)
					end

					if braceCount == 0 then
						if pcall(ffi.cdef, declarationString) then
							finalDeclarationString = finalDeclarationString..declarationString
						end
						
						declarationString = ""
					end
				end
			end
		end
		
		headerFile:close()
	end

	os.remove("CBindingsPreprocessedHeader.i")

	return errorMessage, defines, finalDeclarationString
end

function CBindings.CreateBindings(outputPath, libraryPath, defines, declarationString, globalSymbols)
	local outputFile, errorMessage = io.open(outputPath, "w+")

	if outputFile then
		outputFile:setvbuf("full")

		outputFile:write([[
local ffi = require("ffi")

local function IndexMetamethod(self, name)
	local value = self.Defines[name]

	if value == nil then
		return self.Library[name]
	else
		return value
	end
end

local defines = {}

]])

		for name, value in pairs(defines) do
			local valueType = type(value)

			if valueType == "string" then
				outputFile:write("defines[\""..name.."\"] = \""..value.."\"\n")
			elseif valueType == "number" or valueType == "boolean" then
				outputFile:write("defines[\""..name.."\"] = "..tostring(value).."\n")
			end
		end

		outputFile:write("\nffi.cdef([[\n"..declarationString.."]])\n")

		if type(libraryPath) == "table" then
			outputFile:write("\nlocal libraries = {}\n")

			for _, library in ipairs(libraryPath) do
				outputFile:write("libraries[\""..library[1].."\"] = setmetatable({Library = ffi.load(\""..library[2].."\", "..(globalSymbols and "true" or "false").."), Defines = defines}, {__index = IndexMetamethod})\n")
			end

			outputFile:write("\nreturn libraries")
		else
			outputFile:write("\nreturn setmetatable({Library = ffi.load(\""..libraryPath.."\", "..(globalSymbols and "true" or "false").."), Defines = defines}, {__index = IndexMetamethod})")
		end

		outputFile:close()
	end

	return errorMessage
end

return CBindings