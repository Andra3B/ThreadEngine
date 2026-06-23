local World = {}

function World.Create()
	local self = Class.CreateInstance(WorldObject.Create(), World)

	self._Camera = Camera.Create()

	self._Camera.Parent = self

	return self
end

function World:Draw(pass)
	if self._Camera then
		pass:setShader(Thread.Shaders.World)
		pass:setProjection("matrix", self._Camera.Projection:Unpack())
		pass:setViewPose(1, self._Camera.LovrInverseTransform, true)
		
		pass:setDepthTest("gequal")
		pass:setDepthWrite(true)

		pass:setFaceCull("back")

		pass:setColor(1, 1, 1, 1)

		for _, descendant in self:IterateDescendants() do
			if Class.IsA(descendant, "Body") then
				if descendant.Mesh then
					descendant:Draw()
				end
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

function World:Destroy()
	if not self._Destroyed then
		self._Camera = nil
		
		WorldObject.Destroy(self)
	end
end

return Class.CreateClass(World, "World", WorldObject)