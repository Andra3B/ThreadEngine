local Object = {}

local function NewIndexMetamethod(self, name, value)
	local setter = self.Class["Set"..name]

	if setter then
		local oldValue = self["_"..name]
		local set, setValue = setter(self, value)
		
		if set or value == Class.NIL then
			local selfDependents = self.Class.DEPENDENCIES.Self[name]
			
			if selfDependents then
				for _, dependency in pairs(selfDependents) do
					self[dependency] = Class.NIL
				end
			end

			if not self.Destroyed then
				self._Events:Trigger(name.."Changed", setValue, oldValue)
			end
		end
	else
		rawset(self, name, value)
	end
end

function Object.Create()
	local self = Class.CreateInstance(Entity.Create(), Object)

	self._Events = EventDirector.Create(self)

	self._Name = nil

	return self
end

function Object:Update()
	self._Events:Update()
end

function Object:GetName()
	return self._Name
end

function Object:SetName(name)
	if name ~= self._Name then
		self._Name = name

		return true, name
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

function Object.__tostring(object)
	if object._Name and #object._Name > 0 then
		return object._Name
	else
		return Entity.__tostring(object)
	end
end

return Class.CreateClass(Object, "Object", Entity, nil, nil, NewIndexMetamethod)