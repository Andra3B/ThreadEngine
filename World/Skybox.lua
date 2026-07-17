local Skybox = {}

local skyboxUpdateQueue = {}

function Skybox.Update(pass)
	local skybox = nil

	repeat
		skybox = table.remove(skyboxUpdateQueue, 1)
	until not skybox or not skybox.Destroyed

	if skybox then
		pass:setCanvas(skybox._CubeTexture)

		pass:setShader(Thread.Shaders.SkyboxUpdate)
		pass:send("Skybox", skybox._Texture)

		pass:setProjection(1, Thread.SkyboxUpdateMatrices[1])
		pass:setProjection(2, Thread.SkyboxUpdateMatrices[1])
		pass:setProjection(3, Thread.SkyboxUpdateMatrices[1])
		pass:setProjection(4, Thread.SkyboxUpdateMatrices[1])
		pass:setProjection(5, Thread.SkyboxUpdateMatrices[1])
		pass:setProjection(6, Thread.SkyboxUpdateMatrices[1])

		pass:setViewPose(1, Thread.SkyboxUpdateMatrices[2])
		pass:setViewPose(2, Thread.SkyboxUpdateMatrices[3])
		pass:setViewPose(3, Thread.SkyboxUpdateMatrices[4])
		pass:setViewPose(4, Thread.SkyboxUpdateMatrices[5])
		pass:setViewPose(5, Thread.SkyboxUpdateMatrices[6])
		pass:setViewPose(6, Thread.SkyboxUpdateMatrices[7])

		pass:draw(Thread.Meshes.Cube)
	end
end

function Skybox.Create(path)
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
		self._CubeTexture = lovr.graphics.newTexture(1024, 1024, {
			type = "cube",
			format = "rgba16f",
			linear = true,
			mipmaps = false,
			usage = {"sample", "render"}
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

function Skybox:GetTexture()
	return self._Texture
end

function Skybox:GetCubeTexture()
	return self._CubeTexture
end

function Skybox:Destroy()
	if not self._Destroyed then
		self._Texture:release()
		self._Texture = nil

		self._CubeTexture:release()
		self._CubeTexture = nil		

		Object.Destroy(self)
	end
end

return Class.CreateClass(Skybox, "Skybox", Object)