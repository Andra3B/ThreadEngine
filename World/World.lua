local World = {}

local worldResults = nil
local worldResultsCount = nil

local function OnDescendantAdded(world, descendant)
	if Class.IsA(descendant, "Body") then
		if descendant.Collider then
			descendant.Collider:Refresh()
		end
	elseif Class.IsA(descendant, "Light") then
		local lightIndex = #world._Lights + 1

		if lightIndex <= 32 then
			table.insert(world._Lights, descendant)
			
			descendant._LightIndex = lightIndex
			descendant.Changed = Class.NIL
		end
	end
end

local function OnDescendantRemoved(world, descendant)
	if Class.IsA(descendant, "Body") then
		if descendant.Collider then
			descendant.Collider:Refresh()
		end
	elseif Class.IsA(descendant, "Light") then
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
	print("Collision Started")
end

local function OnCollisionFinished(colliderOne, colliderTwo)
	print("Collision Finished")
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

	self._Gravity = Vector3.Create(self._PhysicsWorld:getGravity())

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

function World:Update(deltaTime)
	WorldObject.Update(self, deltaTime)

	self._TimeSincePhysicsUpdate = self._TimeSincePhysicsUpdate + deltaTime

	while self._TimeSincePhysicsUpdate >= self._PhysicsUpdatePeriod do
		self._PhysicsWorld:update(self._PhysicsUpdatePeriod)
		
		for descendant in self:IterateDescendants() do
			if descendant.PostPhysicsUpdate then
				descendant:PhysicsUpdate(self._TimeSincePhysicsUpdate)
			end
		end

		self._TimeSincePhysicsUpdate = self._TimeSincePhysicsUpdate - self._PhysicsUpdatePeriod
	end

	self._PhysicsWorld:interpolate(self._TimeSincePhysicsUpdate / self._PhysicsUpdatePeriod)
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

local function RaycastCallback(collider, shape, x, y, z, normalX, normalY, normalZ, triangleIndex, relativeDistance)
	worldResultsCount = worldResultsCount + 1

	for i, intersection in ipairs(worldResults) do
		if relativeDistance <= intersection.RelativeDistance then
			for j = #worldResults - 1, i, -1 do
				local currentIntersection = worldResults[j]
				local nextIntersection = worldResults[j + 1]

				nextIntersection.Body = currentIntersection.Body

				nextIntersection.Position.X = currentIntersection.Position.X
				nextIntersection.Position.Y = currentIntersection.Position.Y
				nextIntersection.Position.Z = currentIntersection.Position.Z

				nextIntersection.Normal.X = currentIntersection.Normal.X
				nextIntersection.Normal.Y = currentIntersection.Normal.Y
				nextIntersection.Normal.Z = currentIntersection.Normal.Z

				nextIntersection.RelativeDistance = currentIntersection.RelativeDistance
			end

			intersection.Body = collider:getUserData()

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

	if intersections >= #worldResults then
		return worldResults[#worldResults].fraction
	else
		return 1
	end
end

function World:Raycast(origin, direction, length, filter, intersectionCount)
	intersectionCount = math.max(intersectionCount or 1, 1)
	local to = origin + (direction * length)

	if intersectionCount == 1 then
		local collider, shape, x, y, z, normalX, normalY, normalZ, triangleIndex, relativeDistance = self._PhysicsWorld:raycast(
			origin.X, origin.Y, origin.Z,
			to.X, to.Y, to.Z,
			filter
		)

		return {{
			Body = collider:getUserData(),
			Position = Vector3.Create(x, y, z),
			Normal = Vector3.Create(normalX, normalY, normalZ),
			RelativeDistance = relativeDistance
		}}
	else
		worldResults = {}
		worldResultsCount = 0

		for _ = 1, intersectionCount, 1 do
			table.insert(worldResults, {RelativeDistance = math.huge})
		end

		self._PhysicsWorld:raycast(
			origin.X, origin.Y, origin.Z,
			to.X, to.Y, to.Z,
			filter,
			RaycastCallback
		)

		local results = worldResults
		worldResults = nil

		return results 
	end
end

function World:Shapecast(shape, position, orientation, direction, length, filter, intersectionCount)
	local to = position + (direction * length)
	local angle, axisX, axisY, axisZ = orientation:GetAngleAxis(true)

	if intersectionCount == 1 then
		local collider, collisionShape, x, y, z, normalX, normalY, normalZ, triangleIndex, relativeDistance = self._PhysicsWorld:shapecast(
			shape,
			position.X, position.Y, position.Z,
			to.X, to.Y, to.Z,
			angle, axisX, axisY, axisZ,
			filter
		)

		return {{
			Body = collider:getUserData(),
			Position = Vector3.Create(x, y, z),
			Normal = Vector3.Create(normalX, normalY, normalZ),
			RelativeDistance = relativeDistance
		}}
	else
		worldResults = {}
		worldResultsCount = 0

		for _ = 1, intersectionCount, 1 do
			table.insert(worldResults, {RelativeDistance = math.huge})
		end

		self._PhysicsWorld:shapecast(
			shape,
			position.X, position.Y, position.Z,
			to.X, to.Y, to.Z,
			angle, axisX, axisY, axisZ,
			filter,
			RaycastCallback
		)

		local results = worldResults
		worldResults = nil

		return results 
	end
end

local function OverlappingBodiesCallback(collider, collisionShape, x, y, z, penetrationX, penetrationY, penetrationZ)
	table.insert(worldResults, {
		Body = collider:getUserData(),
		Position = Vector3.Create(x, y, z),
		Penetration = Vector3.Create(penetrationX, penetrationY, penetrationZ)
	})
end

function World:GetOverlappingBodies(shape, position, orientation, filter, detectionDistance, firstOnly)
	detectionDistance = detectionDistance or 0

	local angle, axisX, axisY, axisZ = orientation:GetAngleAxis(true)

	if firstOnly then
		local collider, collisionShape, x, y, z, penetrationX, penetrationY, penetrationZ = self._PhysicsWorld:overlapShape(
			shape,
			position.X, position.Y, position.Z,
			angle, axisX, axisY, axisZ,
			detectionDistance,
			filter
		)

		return {{
			Body = collider:getUserData(),
			Position = Vector3.Create(x, y, z),
			Penetration = Vector3.Create(penetrationX, penetrationY, penetrationZ),
		}}
	else
		worldResults = {}

		self._PhysicsWorld:overlapShape(
			shape,
			position.X, position.Y, position.Z,
			angle, axisX, axisY, axisZ,
			detectionDistance,
			filter,
			OverlappingBodiesCallback
		)

		local results = {}
		worldResults = nil

		return results
	end
end

local function QueryBodiesInShapeCallback(collider)
	table.insert(worldResults, collider)
end

function World:QueryBodiesInBox(position, size, filter, firstOnly)
	bodyCount = math.max(bodyCount or 1, 1)

	if firstOnly then
		local collider = self._PhysicsWorld:queryBox(
			position.X, position.Y, position.Z,
			size.X, size.Y, size.Z,
			filter 
		)

		return {collider:getUserData()}
	else
		worldResults = results

		self._PhysicsWorld:queryBox(
			position.X, position.Y, position.Z,
			size.X, size.Y, size.Z,
			filter,
			QueryBodiesInShapeCallback
		)

		local results = worldResults
		worldResults = nil

		return results
	end
end

function World:QueryBodiesInSphere(position, radius, filter, firstOnly)
	if firstOnly then
		local collider = self._PhysicsWorld:querySphere(
			position.X, position.Y, position.Z,
			radius,
			filter 
		)

		return {collider:getUserData()}
	else
		worldResults = results

		self._PhysicsWorld:querySphere(
			position.X, position.Y, position.Z,
			radius,
			filter,
			QueryBodiesInShapeCallback
		)

		local results = worldResults
		worldResults = nil

		return results
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

function World:GetPhysicsWorld()
	return self._PhysicsWorld
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