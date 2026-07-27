local Body = {}

function Body.Create()
    local self = Class.CreateInstance(WorldNode.Create(), Body)

	self._Mesh = nil
	self._MeshParts = {}

	self._Material = nil

	self._Collider = nil

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

    return self
end

function Body:Update(deltaTime)
	WorldNode.Update(self, deltaTime)

	if self._Collider then
		local collider = self._Collider.Collider

		self.Position = Vector3.Create(collider:getPosition())
		self.Orientation = Quaternion.CreateAxisRotation(collider:getOrientation())
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
					material = material or self._Material or Thread.DefaultMaterial

					material:SendToPass(pass)
					pass:draw(mesh, self.LovrTransform, 1)
				end
			end
		else
			if #self._Mesh.Parts > 0 then
				for partIndex = 1, #self._Mesh.Parts, 1 do
					local mesh, material = self._Mesh:GetMesh(partIndex)
					material = material or self._Material or Thread.DefaultMaterial

					material:SendToPass(pass)
					pass:draw(mesh, self.LovrTransform, 1)
				end
			else
				local material = self._Material or Thread.DefaultMaterial

				material:SendToPass(pass)
				pass:draw(self._Mesh.Mesh, self.LovrTransform, 1)
			end
		end
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
	return self._Collider
end

function Body:SetCollider(collider)
	if collider ~= self._Collider then
		collider.Body = self
		collider:Refresh()

		self._Collider = collider
		
		return true, collider
	end
end

function Body:GetLinearVelocity(position, localPosition) 
	local collider = self._Collider and self._Collider.Collider or nil

	if collider then
		if position then
			return
				localPosition and 
				Vector3.Create(collider:getLinearVelocityFromLocalPoint(position:Unpack())) or
				Vector3.Create(collider:getLinearVelocityFromWorldPoint(position:Unpack()))
		else
			return Vector3.Create(collider:getLinearVelocity())
		end
	end

	return Vector3.Zero
end

function Body:SetLinearVelocity(velocity)
	local collider = self._Collider and self._Collider.Collider or nil

	if collider then
		collider:setLinearVelocity(velocity:Unpack())

		return true, velocity
	end
end

function Body:GetAngularVelocity()
	local collider = self._Collider and self._Collider.Collider or nil

	return collider and Vector3.Create(collider:getLinearVelocity()) or Vector3.Zero
end

function Body:SetAngularVelocity(velocity)
	local collider = self._Collider and self._Collider.Collider or nil

	if collider then
		collider:setAngularVelocity(velocity:Unpack())

		return true, velocity
	end

end

function Body:GetLinearDamping()
	return self._LinearDamping
end

function Body:SetLinearDamping(damping)
	if damping ~= self._LinearDamping then
		local collider = self._Collider and self._Collider.Collider or nil

		if collider then
			collider:setLinearDamping(damping)
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
		local collider = self._Collider and self._Collider.Collider or nil

		if collider then
			collider:setAngularDamping(damping)
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
		local collider = self._Collider and self._Collider.Collider or nil

		if collider then
			collider:setFriction(friction)
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
		local collider = self._Collider and self._Collider.Collider or nil

		if collider then
			collider:setRestitution(restitution)
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
		local collider = self._Collider and self._Collider.Collider or nil

		if collider then
			collider:setDensity(density)
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
		local collider = self._Collider and self._Collider.Collider or nil

		if collider then
			collider:setKinematic(kinematic)
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
		local collider = self._Collider and self._Collider.Collider or nil

		if collider then
			collider:setContinuous(detection)
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
		local collider = self._Collider and self._Collider.Collider or nil

		if collider then
			collider:setGravityScale(scale)
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
		local collider = self._Collider and self._Collider.Collider or nil

		if collider then
			collider:setSleepingAllowed(sleep)
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
		local collider = self._Collider and self._Collider.Collider or nil

		if collider then
			collider:setSensor(sensor)
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
		local collider = self._Collider and self._Collider.Collider or nil

		if collider then
			collider:setTag(tag)
		end
		
		self._CollisionTag = tag

		return true, tag
	end
end

function Body:GetMass()
	local collider = self._Collider and self._Collider.Collider or nil

	return collider and collider:getMass() or 0
end

function Body:GetCenterOfMass()
	local collider = self._Collider and self._Collider.Collider or nil

	return collider and Vector3.Create(collider:getCenterOfMass()) or 0
end

function Body:IsAwake()
	local collider = self._Collider and self._Collider.Collider or nil

	return collider and collider:isAwake()
end

function Body:SetAwake(awake)
	local collider = self._Collider and self._Collider.Collider or nil

	if collider then
		collider:setAwake(awake)

		return true, awake
	end
end

function Body:Destroy()
    if not self._Destroyed then
		self._Mesh = nil
		self._MeshParts = nil

		self._Material = nil

		self._Collider:Destroy()
		self._Collider = nil

		WorldNode.Destroy(self)
	end
end

return Class.CreateClass(Body, "Body", WorldNode, scriptpath())