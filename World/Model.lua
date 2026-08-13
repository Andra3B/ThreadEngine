local Model = {}

function Model.Create()
	local self = Class.CreateInstance(WorldObject.Create(), Model)

	return self
end

function Model:Destroy()
	if not self._Destroyed then
		WorldObject.Destroy(self)
	end
end

return Class.CreateClass(Model, "Model", WorldObject)