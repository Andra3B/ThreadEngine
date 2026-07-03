local Skybox = {}

function Skybox.Create()
	local self = Class.CreateInstance(Object.Create(), Skybox)

	return self
end

function Skybox:Destroy()
	if not self._Destroyed then
		

		Object.Destroy(self)
	end
end

return Class.CreateClass(Skybox, "Skybox", Object)