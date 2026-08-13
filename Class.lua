local Class = {}

local function IndexMetamethod(self, name)
	local getter = self.Class["Get"..name] or self.Class["Is"..name]

	if getter then
		return getter(self)
	else
		return self.Class[name]
	end
end

local function NewIndexMetamethod(self, name, value)
	local setter = self.Class["Set"..name]

	if setter then		
		if setter(self, value) or value == Class.NIL then
			local selfDependents = self.Class.DEPENDENCIES.Self[name]
			
			if selfDependents then
				for _, dependency in pairs(selfDependents) do
					self[dependency] = Class.NIL
				end
			end
		end
	else
		rawset(self, name, value)
	end
end

Class.__index = Class
Class.Type = "Class"

Class.NIL = setmetatable(table.new(0, 0), {__tostring = function() return "NIL" end})

Class.INSTANCE_METATABLE = {__index = IndexMetamethod, __newindex = NewIndexMetamethod}
Class.DEPENDENCIES = {
	Parent = table.empty,
	Self = table.empty,
	Children = table.empty
}

function Class.CreateClass(class, typeName, base, classPath, indexMetamethod, newIndexMetamethod)
	base = base or Class
	
	for name, value in pairs(base) do
		if string.sub(name, 1, 2) == "__" and not class[name] then
			class[name] = value
		end
	end

	class.__index = class
	class.Type = typeName
	
	class.INSTANCE_METATABLE = {}
	class.CLASS_INDICATOR = true
	
	for name, value in pairs(class) do
		if string.sub(name, 1, 2) == "__" then
			class.INSTANCE_METATABLE[name] = value
		end
	end
	
	class.INSTANCE_METATABLE.__index = indexMetamethod or base.INSTANCE_METATABLE.__index
	class.INSTANCE_METATABLE.__newindex = newIndexMetamethod or base.INSTANCE_METATABLE.__newindex

	class.DEPENDENCIES = table.clone(base.DEPENDENCIES)
	
	if classPath then
		local functionName = nil
		local attributeName = nil
		local attributeArguments = nil

		for line in string.gmatch(lovr.filesystem.read(classPath), "(.-)\n") do
			local attribute, arguments = string.match(line, "%-%-%[%[%s*([%w_]+)%s*:?(.*)%s*%]%]%-%-")
			
			if attribute then
				functionName = nil
				
				attributeName = attribute
				attributeArguments = {}
				
				for argument in string.gmatch(arguments, "[%w_]+") do
					table.insert(attributeArguments, argument)
				end
			else
				functionName = string.match(line, "function .+:([%w_]+)") or functionName
			end

			if attributeName == "DependsOn" then
				if functionName then
					local property = string.match(functionName, "Get(.+)") or string.match("Is(.+)")

					if property then
						for _, dependentProperty in pairs(attributeArguments) do
							local dependents = nil

							if dependentProperty ~= "Parent" and string.sub(dependentProperty, 1, 6) == "Parent" then
								dependentProperty = string.sub(dependentProperty, 7)
								dependents = class.DEPENDENCIES.Parent[dependentProperty]

								if not dependents then
									dependents = {}

									class.DEPENDENCIES.Parent[dependentProperty] = dependents
								end
							elseif dependentProperty ~= "Children" and string.sub(dependentProperty, 1, 8) == "Children" then
								dependentProperty = string.sub(dependentProperty, 9)
								dependents = class.DEPENDENCIES.Children[dependentProperty]

								if not dependents then
									dependents = {}

									class.DEPENDENCIES.Children[dependentProperty] = dependents
								end
							else
								dependents = class.DEPENDENCIES.Self[dependentProperty]

								if not dependents then
									dependents = {}

									class.DEPENDENCIES.Self[dependentProperty] = dependents
								end
							end

							local contains = false

							for _, dependent in pairs(dependents) do
								if dependent == property then
									contains = true
									break
								end
							end

							if not contains then
								table.insert(dependents, property)
							end
						end
					end

					attributeName = nil
					attributeArguments = nil
				end
			end
		end
	end

	return setmetatable(class, base)
end

function Class.CreateInstance(instance, class)
	instance = instance or {}
	
	instance.Class = class
	instance.CLASS_INSTANCE_INDICATOR = true

	return setmetatable(instance, class.INSTANCE_METATABLE)
end

function Class:IsA(typeName)
	if type(typeName) == "string" then
		local luaType = type(self)

		if luaType == "table" and self.CLASS_INSTANCE_INDICATOR then
			for class in self:IterateInheritance() do
				if class.Type == typeName then
					return true
				end
			end

			return false
		end
		
		return luaType == typeName
	end

	return false
end

function Class:GetType()
	local luaType = type(self)

	if luaType == "table" and self.CLASS_INDICATOR then
		return self.CLASS_INSTANCE_INDICATOR and self.Class.Type or self.Type
	end

	return luaType
end

local function InheritanceIterator(stopAt, currentClass)
	if currentClass.CLASS_INSTANCE_INDICATOR then
		return currentClass.Class
	else
		local nextClass = getmetatable(currentClass)

		if nextClass ~= stopAt then
			return nextClass
		end
	end
end

function Class:IterateInheritance(stopAt)
	return InheritanceIterator, stopAt, self
end

function Class.__tostring(entity)
	return entity.CLASS_INSTANCE_INDICATOR and entity.Class.Type.." Instance" or entity.Type.." Class"
end

return Class