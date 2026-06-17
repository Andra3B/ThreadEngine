local Object = {}

local function NewIndexMetamethod(self, name, value)
	local setter = self.Class["Set"..name]

	if setter then
		local oldValue = self["_"..name]
		local set, setValue = setter(self, value)
		
		if set or value == Class.NIL then
			local dependents = self.Class.PROPERTY_DEPENDENCIES[name]
			
			if dependents then
				for _, dependency in pairs(dependents) do
					self[dependency] = Class.NIL
				end
			end

			if not self.Destroyed then
				self.Events:Trigger(name.."Changed", setValue, oldValue)
			end
		end
	else
		rawset(self, name, value)
	end
end

function Object.Create()
	local self = Class.CreateInstance(Entity.Create(), Object)

	self._Events = EventDirector.Create(self)

	self._Name = ""

	return self
end

function Object:Update(deltaTime)
	self._Events:Update()
end

function Object:GetName()
	return self._Name
end

function Object:SetName(name)
	name = tostring(name)

	if name ~= self._Name then
		self._Name = name

		return true, self._Name
	end
end

function Object:GetEvents()
	return self._Events
end

function Object:Destroy()
	if not self._Destroyed then
		self._Events:Trigger("Destroyed")
		self._Events:Destroy()
		self._Events = nil
		
		Entity.Destroy(self)
	end
end

return Class.CreateClass(Object, "Object", Entity, nil, NewIndexMetamethod)