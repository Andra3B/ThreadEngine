local Skybox = {}

function Skybox.Create(path, size)
	size = math.clamp(size or 512, 32, 512)

	local texture = lovr.graphics.newTexture(path, {
		type = "2d",
		format = "rgba16f",
		linear = true,
		mipmaps = false,
		usage = {"sample"}
	})

	if texture then
		local self = Class.CreateInstance(Object.Create(), Skybox)

		self._Texture = texture
		self._EnvironmentMap = lovr.graphics.newTexture(size, size, {
			type = "cube",
			format = "rgba16f",
			linear = true,
			mipmaps = true,
			usage = {"sample", "render"}
		})

		self._HarmonicsBuffer = lovr.graphics.newBuffer({"vec3", layout = "std430"}, 9)
		
		Thread.UpdateSkybox(self)
		return self
	end
end

function Skybox:GetTexture()
	return self._Texture
end

function Skybox:GetEnvironmentMap()
	return self._EnvironmentMap
end

function Skybox:GetHarmonicsBuffer()
	return self._HarmonicsBuffer
end

function Skybox:Destroy()
	if not self._Destroyed then
		self._Texture:release()
		self._Texture = nil

		self._EnvironmentMap:release()
		self._EnvironmentMap = nil		

		self._HarmonicsBuffer:release()
		self._HarmonicsBuffer = nil

		Object.Destroy(self)
	end
end

return Class.CreateClass(Skybox, "Skybox", Object)