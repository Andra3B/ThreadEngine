local Body = {}

function Body.Create()
    local self = Class.CreateInstance(WorldObject.Create(), Body)

	self._Mesh = nil
	self._MeshParts = {}

	self._Material = nil

	self._Collider = nil
	self._ColliderShapes = {}

	self._LinearDamping = 0
	self._AngularDamping = 0

	self._Friction = 0.2
	self._Restitution = 0.1 

	self._Density = 1

	self._Kinematic = false
	self._ContinuousCollisionDetection = false

	self._GravityScale = 1

	self._CanSleep = true

	self._IsSensor = false

	self._CollisionTag = nil

	self._ColliderEnabled = true

    return self
end

function Body:Update(deltaTime)
	WorldObject.Update(self, deltaTime)

	if self._Collider then
		self.AbsolutePosition = Vector3.Create(self._Collider:getPosition())
		self.AbsoluteOrientation = Quaternion.CreateAxisRotation(self._Collider:getOrientation())
	end
end

function Body:Draw(pass)
	if self._Mesh then
		if not self._Mesh.HasTangents then
			pass:setShader(Thread.Shaders.WorldNoTangents)
		end

		if #self._MeshParts > 0 then
			for _, partIndex in ipairs(self._MeshParts) do
				local mesh, material = self._Mesh:GetMesh(partIndex)
				
				if mesh then
					material = material or self._Material or Thread.Materials.Default

					material:SendToPass(pass)
					pass:draw(mesh, self.LovrTransform, 1)
				end
			end
		else
			if #self._Mesh.Parts > 0 then
				for partIndex = 1, #self._Mesh.Parts, 1 do
					local mesh, material = self._Mesh:GetMesh(partIndex)
					material = material or self._Material or Thread.Materials.Default

					material:SendToPass(pass)
					pass:draw(mesh, self.LovrTransform, 1)
				end
			else
				local material = self._Material or Thread.Materials.Default

				material:SendToPass(pass)
				pass:draw(self._Mesh.Mesh, self.LovrTransform, 1)
			end
		end
	end
end

function Body:SetParent(parent)
	if WorldObject.SetParent(self, parent) then
		local world = self:GetAncestorWithType("World")

		if world then
			if not self.Collider or world.PhysicsWorld ~= self._Collider:getWorld() then
				self.Collider = world.PhysicsWorld:newCollider(0, 0, 0)
			end
		else
			self.Collider = nil
		end
	end
end

function Body:SetAbsolutePosition(position)
	if WorldObject.SetAbsolutePosition(self, position) then
		if self.Collider and position ~= Class.NIL then
			self._Collider:setPosition(position:Unpack())
		end

		return true, position
	end
end

function Body:SetAbsoluteOrientation(orientation)
	if WorldObject.SetAbsoluteOrientation(self, orientation) then
		if self.Collider and orientation ~= Class.NIL then
			self._Collider:setOrientation(orientation:GetAngleAxis(true))
		end

		return true, orientation
	end
end

function Body:GetMesh()
	return self._Mesh
end

function Body:SetMesh(mesh)
	if mesh ~= self._Mesh then
		self._Mesh = mesh

		return true, mesh
	end
end

function Body:GetMeshParts()
	return self._MeshParts
end

function Body:SetMeshParts(parts)
	if parts ~= self._MeshParts then
		self._MeshParts = parts

		return true, parts
	end
end

function Body:GetMaterial()
	return self._Material
end

function Body:SetMaterial(material)
	if material ~= self._Material then
		self._Material = material

		return true, material
	end
end

function Body:GetCollider()
	local collider = self._Collider

	if collider then
		if collider:isDestroyed() then 
			self._Collider = nil
		else
			return collider
		end
	end
end

function Body:SetCollider(collider)
	if collider ~= self.Collider then
		if self._Collider then
			for _, shape in ipairs(self._ColliderShapes) do
				self._Collider:removeShape(shape)
			end

			self._Collider:setUserData(nil)
			self._Collider:destroy()
			self._Collider:release()
		end

		if collider then
			collider:setUserData(self)
			
			collider:setPose(
				self.AbsolutePosition.X, self.AbsolutePosition.Y, self.AbsolutePosition.Z,
				self.AbsoluteOrientation:GetAngleAxis(true)
			)

			collider:setLinearDamping(self._LinearDamping)
			collider:setAngularDamping(self._AngularDamping)

			collider:setFriction(self._Friction)
			collider:setRestitution(self._Restitution)

			collider:setKinematic(self._Kinematic)

			collider:setContinuous(self._ContinuousCollisionDetection)

			collider:setGravityScale(self._GravityScale)

			collider:setSleepingAllowed(self._CanSleep)

			collider:setSensor(self._Sensor)

			collider:setTag(self._CollisionTag)

			collider:setEnabled(self._ColliderEnabled and #self._ColliderShapes > 0)

			for _, shape in ipairs(self._ColliderShapes) do
				shape:setDensity(self._Density)
				collider:addShape(shape)
			end
		end

		self._Collider = collider

		return true, collider
	end
end

function Body:GetColliderShapes()
	return self._ColliderShapes
end

function Body:HasColliderShape(shape)
	for _, currentShape in ipairs(self._ColliderShapes) do
		if shape == currentShape then
			return true
		end
	end

	return false
end

function Body:AddColliderShape(shape)
	if not self:HasColliderShape(shape) then
		if self.Collider then
			self._Collider:addShape(shape)
			self._Collider:setEnabled(self._ColliderEnabled)
		end

		table.insert(self._ColliderShapes, shape)
	end
end

function Body:RemoveColliderShape(shape)
	local collider = self.Collider

	for index, currentShape in ipairs(self._ColliderShapes) do
		if shape == currentShape then
			if collider then
				self._Collider:removeShape(shape)
			end

			table.remove(self._ColliderShapes, index)

			break
		end
	end

	if collider and #self._ColliderShapes == 0 then
		self._Collider:setEnabled(false)
	end
end

function Body:GetLinearVelocity(position, localPosition) 
	if self.Collider then
		if position then
			return
				localPosition and 
				Vector3.Create(collider:getLinearVelocityFromLocalPoint(position:Unpack())) or
				Vector3.Create(collider:getLinearVelocityFromWorldPoint(position:Unpack()))
		else
			return Vector3.Create(collider:getLinearVelocity())
		end
	else
		return Vector3.Zero
	end
end

function Body:SetLinearVelocity(velocity)
	if self.Collider and velocity ~= self._Collider:getLinearVelocity() then
		self._Collider:setLinearVelocity(velocity:Unpack())

		return true, velocity
	end
end

function Body:GetAngularVelocity()
	return self.Collider and Vector3.Create(self._Collider:getLinearVelocity()) or Vector3.Zero
end

function Body:SetAngularVelocity(velocity)
	if self.Collider and velocity ~= self._Collider:getAngularVelocity() then
		self._Collider:setAngularVelocity(velocity:Unpack())

		return true, velocity
	end
end

function Body:GetLinearDamping()
	return self._LinearDamping
end

function Body:SetLinearDamping(damping)
	if damping ~= self._LinearDamping then
		if self.Collider then
			self._Collider:setLinearDamping(damping)
		end
		
		self._LinearDamping = damping

		return true, damping
	end
end

function Body:GetAngularDamping()
	return self._AngularDamping
end

function Body:SetAngularDamping(damping)
	if damping ~= self._AngularDamping then
		if self.Collider then
			self._Collider:setAngularDamping(damping)
		end

		self._AngularDamping = damping

		return true, damping
	end
end

function Body:GetFriction()
	return self._Friction
end

function Body:SetFriction(friction)
	if friction ~= self._Friction then
		if self.Collider then
			self._Collider:setFriction(friction)
		end

		self._Friction = friction

		return true, friction
	end
end

function Body:GetRestitution()
	return self._Restitution
end

function Body:SetRestitution(restitution)
	if restitution ~= self._Restitution then
		if self.Collider then
			self._Collider:setRestitution(restitution)
		end

		self._Restitution = restitution

		return true, restitution
	end
end

function Body:GetDensity()
	return self._Density
end

function Body:SetDensity(density)
	if density ~= self._Density then
		for _, shape in ipairs(self._ColliderShapes) do
			shape:setDensity(density)
		end

		self._Density = density

		return true, density
	end
end

function Body:IsKinematic()
	return self._Kinematic
end

function Body:SetKinematic(kinematic)
	if kinematic ~= self._Kinematic then
		if self.Collider then
			self._Collider:setKinematic(kinematic)
		end

		self._Kinematic = kinematic

		return true, kinematic
	end
end

function Body:IsContinuousCollisionDetection()
	return self._ContinuousCollisionDetection
end

function Body:SetContinuousCollisionDetection(detection)
	if detection ~= self._ContinuousCollisionDetection then
		if self._Collider then
			self._Collider:setContinuous(detection)
		end

		self._ContinuousCollisionDetection = detection

		return true, detection
	end
end

function Body:GetGravityScale()
	return self._GravityScale
end

function Body:SetGravityScale(scale)
	if scale ~= self._GravityScale then
		if self.Collider then
			self._Collider:setGravityScale(scale)
		end

		self._GravityScale = scale

		return true, scale
	end
end

function Body:GetCanSleep()
	return self._CanSleep
end

function Body:SetCanSleep(sleep)
	if sleep ~= self._CanSleep then
		if self.Collider then
			self._Collider:setSleepingAllowed(sleep)
		end

		self._CanSleep = sleep

		return true, sleep
	end
end

function Body:IsSensor()
	return self._Sensor
end

function Body:SetSensor(sensor)
	if sensor ~= self._Sensor then
		if self.Collider then
			self._Collider:setSensor(sensor)
		end

		self._Sensor = sensor

		return true, sensor
	end
end

function Body:GetCollisionTags()
	return self._CollisionTag
end

function Body:SetCollisionTag(tag)
	if tag ~= self._CollisionTag then
		if self.Collider then
			self._Collider:setTag(tag)
		end
		
		self._CollisionTag = tag

		return true, tag
	end
end

function Body:GetMass()
	return self.Collider and self._Collider:getMass() or 0
end

function Body:GetCenterOfMass()
	return self.Collider and Vector3.Create(self._Collider:getCenterOfMass()) or nil
end

function Body:IsColliderEnabled()
	return self._ColliderEnabled
end

function Body:SetColliderEnabled(enabled)
	enabled = enabled and #self._ColliderShapes > 0

	if enabled ~= self._ColliderEnabled then
		if self.Collider then
			self._Collider:setEnabled(enabled)
		end

		self._ColliderEnabled = enabled

		return true, enabled
	end
end

function Body:GetAABB()
	if self.Collider then
		local minX, maxX, minY, maxY, minZ, maxZ = self._Collider:getAABB()

		return Vector3.Create(minX, minY, minZ), Vector3.Create(maxX, maxY, maxZ)
	end
end

function Body:IsAwake()
	return self.Collider and self._Collider:isAwake()
end

function Body:SetAwake(awake)
	if self.Collider and awake ~= self._Collider:isAwake() then
		self._Collider:setAwake(awake)

		return true, awake
	end
end

function Body:ApplyForce(force, position)
	if self.Collider then
		if position then
			self._Collider:applyForce(
				force.X, force.Y, force.Z,
				position.X, position.Y, position.Z
			)
		else
			self._Collider:applyForce(force:Unpack())
		end
	end
end

function Body:ApplyTorque(torque)
	if self.Collider then
		self._Collider:applyTorque(torque:Unpack())
	end
end

function Body:ApplyLinearImpulse(impulse, position)
	if self.Collider then
		if position then
			self._Collider:applyLinearImpulse(
				impulse.X, impulse.Y, impulse.Z,
				position.X, position.Y, position.Z
			)
		else
			self._Collider:applyLinearImpulse(impulse:Unpack())
		end
	end
end

function Body:ApplyAngularImpulse(impulse)
	if self.Collider then
		self._Collider:applyAngularImpulse(impulse:Unpack())
	end
end

function Body:Destroy()
    if not self._Destroyed then
		self._Mesh = nil
		self._MeshParts = nil

		self._Material = nil

		while #self._ColliderShapes > 0 do
			local shape = table.remove(self._ColliderShapes)

			if not shape:isDestroyed() then
				shape:destroy()
				shape:release()
			end
		end

		self.Collider = nil

		WorldObject.Destroy(self)
	end
end

return Class.CreateClass(Body, "Body", WorldObject, scriptpath())