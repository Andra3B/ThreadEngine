local Skybox = {}

local skyboxUpdateQueue = {}

function Skybox.Update(renderPass, computePass)
	local skybox = nil

	repeat
		skybox = table.remove(skyboxUpdateQueue, 1)
	until not skybox or not skybox.Destroyed

	if skybox then
		renderPass:setCanvas(skybox._CubeTexture)

		renderPass:setShader(Thread.Shaders.SkyboxUpdate)
		renderPass:send("Skybox", skybox._Texture)

		renderPass:setProjection(1, Thread.SkyboxUpdateMatrices[1])
		renderPass:setProjection(2, Thread.SkyboxUpdateMatrices[1])
		renderPass:setProjection(3, Thread.SkyboxUpdateMatrices[1])
		renderPass:setProjection(4, Thread.SkyboxUpdateMatrices[1])
		renderPass:setProjection(5, Thread.SkyboxUpdateMatrices[1])
		renderPass:setProjection(6, Thread.SkyboxUpdateMatrices[1])

		renderPass:setViewPose(1, Thread.SkyboxUpdateMatrices[2])
		renderPass:setViewPose(2, Thread.SkyboxUpdateMatrices[3])
		renderPass:setViewPose(3, Thread.SkyboxUpdateMatrices[4])
		renderPass:setViewPose(4, Thread.SkyboxUpdateMatrices[5])
		renderPass:setViewPose(5, Thread.SkyboxUpdateMatrices[6])
		renderPass:setViewPose(6, Thread.SkyboxUpdateMatrices[7])

		renderPass:draw(Thread.Meshes.Cube)

		local skyboxSize = skybox._CubeTexture:getWidth()
		skybox._HarmonicsBuffer:clear()

		computePass:setShader(Thread.Shaders.SkyboxHarmonicsPass1)
		computePass:send("Skybox", skybox._CubeTexture)
		computePass:send("OutputBuffer", Thread.SkyboxBlockHarmonicsBuffer)

		computePass:compute(skyboxSize / 16, skyboxSize / 16, 6)

		computePass:barrier()

		computePass:setShader(Thread.Shaders.SkyboxHarmonicsPass2)
		computePass:send("BlockCount", skyboxSize * skyboxSize * 6 / 256)
		computePass:send("InputBuffer", Thread.SkyboxBlockHarmonicsBuffer)
		computePass:send("OutputBuffer", skybox._HarmonicsBuffer)

		computePass:compute(1, 1, 1)
	end
end

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
		self._CubeTexture = lovr.graphics.newTexture(size, size, {
			type = "cube",
			format = "rgba16f",
			linear = true,
			mipmaps = true,
			usage = {"sample", "render", "transfer"}
		})

		self._HarmonicsBuffer = lovr.graphics.newBuffer({"vec3", layout = "std140"}, 9)

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

function Skybox:GetHarmonicsBuffer()
	return self._HarmonicsBuffer
end

function Skybox:Destroy()
	if not self._Destroyed then
		self._Texture:release()
		self._Texture = nil

		self._CubeTexture:release()
		self._CubeTexture = nil		

		self._HarmonicsBuffer:release()
		self._HarmonicsBuffer = nil

		Object.Destroy(self)
	end
end

return Class.CreateClass(Skybox, "Skybox", Object)