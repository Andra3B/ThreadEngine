local Collider = {}

function Collider.Create()
	local self = Class.CreateInstance(Object.Create(), Collider)

	self._Collider = nil
	self._Shape = nil

	self._Position = Vector3.Zero
	self._Orientation = Quaternion.One

	self._Body = nil

	self._Enabled = true

	return self
end

function Collider:Refresh()
	if self._Body then
		local world = self._Body:GetAncestorWithType("World")

		if self._Collider then
			if not world then
				self.Collider = nil
			end
		elseif world then
			self.Collider = world.PhysicsWorld:newCollider(0, 0, 0)

			self._Collider:setEnabled(self._Enabled)

			self._Collider:setPose(
				self._Body.AbsolutePosition.X, self._Body.AbsolutePosition.Y, self._Body.AbsolutePosition.Z,
				self._Body.AbsoluteOrientation:GetAngleAxis(true)
			)

			self._Collider:setLinearDamping(self._Body.LinearDamping)
			self._Collider:setAngularDamping(self._Body.AngularDamping)

			self._Collider:setFriction(self._Body._Friction)
			self._Collider:setRestitution(self._Body._Restitution)

			if type(self._Shape) == "userdata" then
				self._Shape:setDensity(self._Body._Density)
			end

			self._Collider:setKinematic(self._Body._Kinematic)

			self._Collider:setContinuous(self._Body._ContinuousCollisionDetection)

			self._Collider:setGravityScale(self._Body._GravityScale)

			self._Collider:setSleepingAllowed(self._Body._CanSleep)

			self._Collider:setSensor(self._Body._Sensor)

			self._Collider:setTag(self._Body._CollisionTag)
		end

		return world
	end
end

function Collider:GetPosition()
	return self._Position
end

function Collider:SetPosition(position)
	if position ~= self._Position then
		self._Position = position

		if type(self._Shape) == "userdata" then
			self._Shape:setOffset(
				self._Position.X, self._Position.Y, self._Position.Z,
				self._Orientation:GetAngleAxis(true)
			)
		end

		return true, position
	end
end

function Collider:GetOrientation()
	return self._Orientation
end

function Collider:SetOrientation(orientation)
	if orientation ~= self._Orientation then
		self._Orientation = orientation

		return true, orientation
	end
end

function Collider:GetCollider()
	return self._Collider
end

function Collider:SetCollider(collider)
	if collider ~= self._Collider then
		self.Shape = nil

		if self._Collider then
			self._Collider:setUserData(nil)
			self._Collider:destroy()
			self._Collider:release()
		end

		self._Collider = collider

		return true, collider
	end
end

function Collider:GetShape()
	return self._Shape
end

function Collider:SetShape(shape)
	if shape ~= self._Shape then
		if type(self._Shape) == "userdata" then
			self._Shape:destroy()
			self._Shape:release()
		end
		
		if type(shape) == "userdata" then
			shape:setOffset(
				self._Position.X, self._Position.Y, self._Position.Z,
				self._Orientation:GetAngleAxis(true)
			)
		end

		self._Shape = shape

		return true, shape
	end
end

function Collider:GetBody()
	return self._Body
end

function Collider:SetBody(body)
	if body ~= self._Body then
		self._Body = body
		
		return true, body
	end
end

function Collider:IsEnabled()
	return self._Enabled
end

function Collider:SetEnabled(enabled)
	if enabled ~= self._Enabled then
		self._Enabled = enabled

		if self._Collider then
			self._Collider:setEnabled(enabled)
		end

		return true, enabled
	end
end

function Collider:GetAABB()
	if self._Collider then
		local minX, maxX, minY, maxY, minZ, maxZ = self._Collider:getAABB()

		return Vector3.Create(minX, minY, minZ), Vector3.Create(maxX, maxY, maxZ)
	end
end

function Collider:Destroy()
	if not self._Destroyed then
		self.Collider = nil

		self._Position = nil
		self._Orientation = nil

		self._Body = nil

		Object.Destroy(self)
	end
end

return Class.CreateClass(Collider, "Collider", Object, scriptpath())