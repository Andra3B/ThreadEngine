local Model = {}

function Model.Create()
	local self = Class.CreateInstance(WorldNode.Create(), Model)

	return self
end

function Model:Destroy()
	if not self._Destroyed then

		WorldNode.Destroy(self)
	end
end

return Class.CreateClass(Model, "Model", WorldNode)