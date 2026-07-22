local World = {}

local function OnDescendantAdded(world, descendant)
	if Class.IsA(descendant, "Light") then
		local lightIndex = #world._Lights + 1

		if lightIndex <= 32 then
			table.insert(world._Lights, descendant)
			
			descendant._LightIndex = lightIndex
			descendant.Changed = Class.NIL
		end
	end
end

local function OnDescendantRemoved(world, descendant)
	if Class.IsA(descendant, "Light") then
		local lightIndex = descendant._LightIndex

		if lightIndex ~= 0 then
			table.remove(world._Lights, lightIndex)
			descendant._LightIndex = 0

			for object in world:IterateDescendants() do
				if Class.IsA(object, "Light") and object._LightIndex == 0 then
					OnDescendantAdded(world, object)
				end
			end

			for index = lightIndex, #world._Lights, 1 do
				local light = world._Lights[index]

				light._LightIndex = index
				light.Changed = Class.NIL
			end
		end
	end
end

function World.Create()
	local self = Class.CreateInstance(WorldObject.Create(), World)

	self._Camera = Camera.Create()

	self._Skybox = Thread.DefaultSkybox

	self._Lights = table.new(0, 32)
	self._LightBuffer = lovr.graphics.newBuffer({{
			name = "Lights", length = 32, type = {
				{name = "Enabled", type = "uint"},
				{name = "Type", type = "uint"},
				{name = "FallOffType", type = "uint"},
				{name = "FallOffCoefficient", type = "float"},
				{name = "Radius", type = "float"},
				{name = "Range", type = "float"},
				{name = "Intensity", type = "vec3"},
				{name = "Position", type = "vec3"},
				{name = "Direction", type = "vec3"}
			}
		},
		layout = "std430"
	})

	self._DescendantAddedListener = self._Events:Listen("DescendantAdded", OnDescendantAdded)
	self._DescendantRemovedListener = self._Events:Listen("DescendantAdded", OnDescendantRemoved)

	self._Camera.Parent = self

	return self
end

function World:Draw(pass)
	if self._Camera then
		pass:setProjection("matrix", self._Camera.Projection:Unpack())
		pass:setViewPose(1, self._Camera.LovrInverseTransform, true)
		
		pass:setColor(1, 1, 1, 1)
		
		pass:setFaceCull("none")
		pass:setDepthTest("gequal")
		pass:setDepthWrite(true)

		pass:setShader(Thread.Shaders.Cubemap)
		pass:send("Cubemap", self._Skybox.EnvironmentMap)
		pass:send("LOD", 0)

		pass:draw(Thread.Meshes.Cube)
		
		pass:setFaceCull("back")

		pass:setShader(Thread.Shaders.World)

		pass:send("Skybox", self._Skybox.EnvironmentMap)
		pass:send("SkyboxHarmonics", self._Skybox.HarmonicsBuffer)
		
		for _, light in ipairs(self._Lights) do
			light:Upload()
		end

		pass:send("LightBuffer", self._LightBuffer)
		pass:send("LightCount", #self._Lights)

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

function World:Destroy()
	if not self._Destroyed then
		self._Camera = nil
		
		self._Skybox = nil

		table.erase(self._Lights)
		self._Lights = nil

		self._LightBuffer:release()
		self._LightBuffer = nil

		self._DescendantAddedListener:Destroy()
		self._DescendantAddedListener = nil

		self._DescendantRemovedListener:Destroy()
		self._DescendantRemovedListener = nil

		WorldObject.Destroy(self)
	end
end

return Class.CreateClass(World, "World", WorldObject)