local World = {}

function World.Create()
	local self = Class.CreateInstance(WorldObject.Create(), World)

	self._Camera = Camera.Create()

	self._Skybox = Thread.DefaultSkybox

	self._LightStateBuffer = lovr.graphics.newBuffer({
		{name = "Position", type = "vec4", length = 32},
		{name = "Direction", type = "vec4", length = 32},
		{name = "Intensity", type = "vec4", length = 32},
		{name = "FallOff", type = "vec4", length = 32},
		layout = "std140"
	})

	self._LightState = {
		Position = table.new(32, 0),
		Direction = table.new(32, 0),
		Intensity = table.new(32, 0),
		FallOff = table.new(32, 0),

		Lights = table.new(32, 0),
		Changed = false
	}

	self._Camera.Parent = self

	return self
end

function World:Draw(pass)
	if self._Camera then
		pass:setProjection("matrix", self._Camera.Projection:Unpack())
		pass:setViewPose(1, self._Camera.LovrInverseTransform, true)
		
		pass:setColor(1, 1, 1, 1)

		pass:setFaceCull("front")

		pass:setShader(Thread.Shaders.Skybox)

		pass:send("Skybox", self._Skybox.CubeTexture)
		pass:draw(Thread.Meshes.Cube)
		
		pass:setFaceCull("back")

		pass:setShader(Thread.Shaders.World)

		pass:setDepthTest("gequal")
		pass:setDepthWrite(true)

		for descendant in self:IterateDescendants() do
			if Class.IsA(descendant, "Light") and descendant.WorldStateRefresh then
				self:RefreshLight(descendant, false)
			end
		end

		if self._LightState.Changed then
			self._LightStateBuffer:setData(self._LightState)
			self._LightState.Changed = false
		end

		pass:send("Lights", self._LightStateBuffer)
		pass:send("LightCount", #self._LightState.Lights)

		for descendant in self:IterateDescendants() do
			if Class.IsA(descendant, "Body") then
				pass:push("state")
				descendant:Draw(pass)
				pass:pop("state")
			end
		end
	end
end

function World:GetCamera()
	return self._Camera
end

function World:SetCamera(camera)
	if camera ~= self._Camera then
		self._Camera = camera

		camera.Projection = Class.NIL

		return true, camera
	end
end

function World:GetSkybox()
	return self._Skybox
end

function World:SetSkybox(skybox)
	if skybox ~= self._Skybox then
		self._Skybox = skybox

		return true, skybox
	end
end

function World:RefreshLight(light, remove)
	if remove then
		if light._LightIndex == 0 then
			return
		else
			local lightIndex = 4 * (light._LightIndex - 1) + 1

			table.remove(self._LightState.Position, lightIndex)
			table.remove(self._LightState.Position, lightIndex)
			table.remove(self._LightState.Position, lightIndex)
			table.remove(self._LightState.Position, lightIndex)

			table.remove(self._LightState.Direction, lightIndex)
			table.remove(self._LightState.Direction, lightIndex)
			table.remove(self._LightState.Direction, lightIndex)
			table.remove(self._LightState.Direction, lightIndex)

			table.remove(self._LightState.Intensity, lightIndex)
			table.remove(self._LightState.Intensity, lightIndex)
			table.remove(self._LightState.Intensity, lightIndex)
			table.remove(self._LightState.Intensity, lightIndex)

			table.remove(self._LightState.FallOff, lightIndex)
			table.remove(self._LightState.FallOff, lightIndex)
			table.remove(self._LightState.FallOff, lightIndex)
			table.remove(self._LightState.FallOff, lightIndex)

			table.remove(self._LightState.Lights, lightIndex)

			for _lightIndex = lightIndex, #self._LightState.Lights, 1 do
				self._LightState.Lights[_lightIndex]._LightIndex = _lightIndex
			end
		end
	else
		if light._LightIndex == 0 then
			table.insert(self._LightState.Lights, light)

			light._LightIndex = #self._LightState.Lights
		end

		local lightIndex = 4 * (light._LightIndex - 1) + 1

		self._LightState.Position[lightIndex] = light.AbsolutePosition.X
		self._LightState.Position[lightIndex + 1] = light.AbsolutePosition.Y
		self._LightState.Position[lightIndex + 2] = light.AbsolutePosition.Z
		self._LightState.Position[lightIndex + 3] = light.Enabled and 1 or 0

		self._LightState.Direction[lightIndex] = light.Forward.X 
		self._LightState.Direction[lightIndex + 1] = light.Forward.Y
		self._LightState.Direction[lightIndex + 2] = light.Forward.Z
		self._LightState.Direction[lightIndex + 3] = light.Radius or 0

		self._LightState.Intensity[lightIndex] = light.Colour.X * light.Intensity
		self._LightState.Intensity[lightIndex + 1] = light.Colour.Y * light.Intensity
		self._LightState.Intensity[lightIndex + 2] = light.Colour.Z * light.Intensity
		self._LightState.Intensity[lightIndex + 3] = 0

		self._LightState.FallOff[lightIndex] = light.LightType
		self._LightState.FallOff[lightIndex + 1] = light.FallOffType or 0
		self._LightState.FallOff[lightIndex + 2] = light.FallOffCoefficient or 0
		self._LightState.FallOff[lightIndex + 3] = light.Range or 0
	end

	self._LightState.Changed = true
end

function World:Destroy()
	if not self._Destroyed then
		self._Camera = nil
		
		self._Skybox = nil

		self._LightStateBuffer:release()
		self._LightStateBuffer = nil

		table.erase(self._LightState, nil, false)
		self._LightState = nil

		WorldObject.Destroy(self)
	end
end

return Class.CreateClass(World, "World", WorldObject)