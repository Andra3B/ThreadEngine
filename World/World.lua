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

local function OnCollisionStarted(colliderOne, colliderTwo, contact)

end

local function OnCollisionFinished(colliderOne, colliderTwo)

end

function World.Create(tags)
	local self = Class.CreateInstance(WorldObject.Create(), World)

	self._Camera = Camera.Create()

	self._Skybox = Thread.DefaultSkybox

	self._PhysicsWorld = lovr.physics.newWorld({
		["tags"] = tags,
		staticTags = {"Static"}
	})

	self._PhysicsWorld:setCallbacks({
		filter = nil,
		enter = OnCollisionStarted,
		exit = OnCollisionFinished,
		contact = nil
	})

	self._Gravity = Vector3.Create(self._PhysicsUpdatePeriod:getGravity())

	self._TimeSincePhysicsUpdate = 0
	self._PhysicsUpdatePeriod = 1 / 30

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

local raycastResults = nil
local intersections = 0
local function RaycastCallback(collider, shape, x, y, z, normalX, normalY, normalZ, triangleIndex, relativeDistance)
	intersections = intersections + 1

	for i, intersection in ipairs(raycastResults) do
		if relativeDistance <= intersection.RelativeDistance then
			for j = #raycastResults - 1, i, -1 do
				local currentIntersection = raycastResults[j]
				local nextIntersection = raycastResults[j + 1]

				nextIntersection.Collider = currentIntersection.Collider

				nextIntersection.Position.X = currentIntersection.Position.X
				nextIntersection.Position.Y = currentIntersection.Position.Y
				nextIntersection.Position.Z = currentIntersection.Position.Z

				nextIntersection.Normal.X = currentIntersection.Normal.X
				nextIntersection.Normal.Y = currentIntersection.Normal.Y
				nextIntersection.Normal.Z = currentIntersection.Normal.Z

				nextIntersection.RelativeDistance = currentIntersection.RelativeDistance
			end

			intersection.Collider = collider

			intersection.Position.X = x
			intersection.Position.Y = y
			intersection.Position.Z = z

			intersection.Normal.X = normalX
			intersection.Normal.Y = normalY
			intersection.Normal.Z = normalZ

			intersection.Fraction = fraction

			break
		end
	end

	if intersections >= #raycastResults then
		return raycastResults[#raycastResults].fraction
	else
		return 1
	end
end

function World:Raycast(origin, direction, length, filter, intersectionCount)
	intersectionCount = math.max(intersectionCount or 1, 1)
	local to = origin + (direction * length)

	
	if intersectionCount == 1 then
		local collider, shape, x, y, z, normalX, normalY, normalZ, triangleIndex = self._PhysicsWorld:raycast(
			origin.X, origin.Y, origin.Z,
			to.X, to.Y, to.Z,
			filter
		)

		return {{
			Collider = collider,
			Position = Vector3.Create(x, y, z),
			Normal = Vector3.Create(normalX, normalY, normalZ),
			RelativeDistance = ((x - origin.X)^2 + (y - origin.Y)^2 + (z - origin.Z)^2) / length
		}}
	else
		local results = {}

		for _ = 1, intersectionCount, 1 do
			table.insert(results, {RelativeDistance = math.huge})
		end

		raycastResults = results
		intersections = 0

		self._PhysicsWorld:raycast(
			origin.X, origin.Y, origin.Z,
			to.X, to.Y, to.Z,
			filter,
			RaycastCallback
		)

		raycastResults = nil

		return results 
	end
end

function World:Update(deltaTime)
	self._TimeSincePhysicsUpdate = self._TimeSincePhysicsUpdate + deltaTime

	while self._TimeSincePhysicsUpdate >= self._PhysicsUpdatePeriod then
		self._PhysicsWorld:update(self._PhysicsUpdatePeriod)

		self._TimeSincePhysicsUpdate = self._TimeSincePhysicsUpdate - self._PhysicsUpdatePeriod
	end

	world:interpolate(self._TimeSincePhysicsUpdate / self._PhysicsUpdatePeriod)
end

function World:Draw(pass)
	if self._Camera then
		pass:setProjection("matrix", self._Camera.Projection:Unpack())
		pass:setViewPose(1, self._Camera.LovrInverseTransform, true)
		
		pass:setColor(1, 1, 1, 1)
		
		pass:setFaceCull("front")
		pass:setDepthTest("lequal")
		pass:setDepthWrite(true)

		pass:setShader(Thread.Shaders.Cubemap)
		pass:send("Cubemap", self._Skybox.EnvironmentMap)
		pass:send("LOD", 0)

		pass:draw(Thread.Meshes.Cube.Mesh)
		
		pass:setFaceCull("back")

		pass:setShader(Thread.Shaders.WorldTangents)

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

function World:GetGravity()
	return self._Gravity
end

function World:SetGravity(gravity)
	if gravity ~= self._Gravity then
		self._Gravity = gravity

		return true, gravity
	end
end

function World:GetTimeSincePhysicsUpdate()
	return self._TimeSincePhysicsUpdate
end

function World:GetPhysicsUpdateFrequency()
	return 1 / self._PhysicsUpdatePeriod
end

function World:SetPhysicsUpdateFrequency(frequency)
	local period = 1 / frequency 

	if period ~= self._PhysicsUpdatePeriod then
		self._PhysicsUpdatePeriod = period

		return true, frequency
	end
end

function World:Destroy()
	if not self._Destroyed then
		self._Camera = nil
		
		self._Skybox = nil

		self._PhysicsWorld:destroy()
		self._PhysicsWorld:release()
		self._PhysicsWorld = nil

		self._Gravity = nil

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