local Skybox = {}

local skyboxUpdateQueue = {}

function Skybox.UpdateSkyboxes(pass)
	while #skyboxUpdateQueue > 0 do
		local skybox = table.remove(skyboxUpdateQueue, 1)

		
	end
end

function Skybox.Create(path, skyboxSize)
	skyboxSize = skyboxSize or 1024
	
	local skyboxImage = lovr.data.newImage(path)

	if skyboxImage then
		local self = Class.CreateInstance(Object.Create(), Skybox)

		self._SkyboxImage = skyboxImage
		self._SkyboxTexture = lovr.graphics.newTexture(skyboxSize, skyboxSize, {
			type = "cube",
			linear = true,
			mipmaps = false,
			usage = {sample, render}
		})

		self._Updated = true
		self:Refresh()
		
		return self
	end
end

function Skybox:Refresh()
	if self._Updated then
		self._Updated = false

		table.insert(skyboxUpdateQueue, self)
	end
end

function Skybox:GetSkyboxTexture()
	return self._SkyboxTexture
end

function Skybox:Destroy()
	if not self._Destroyed then
		self._SkyboxImage:release()
		self._SkyboxImage = nil

		self._SkyboxTexture:release()
		self._SkyboxTexture = nil		

		Object.Destroy(self)
	end
end

return Class.CreateClass(Skybox, "Skybox", Object)