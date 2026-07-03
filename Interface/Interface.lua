local Interface = {}

function Interface.Create()
	local self = Class.CreateInstance(InterfaceObject.Create(), Interface)
	
	self._Projection = Matrix4.Zero

	return self
end

function Interface:Draw(pass)
	if self._Visible then
		pass:setShader(Thread.Shaders.Interface)
		pass:setProjection("matrix", self._Projection:Unpack())
		pass:setViewPose(1, Thread.LovrMatrixIdentity, true)

		pass:setFaceCull("none")

		pass:setDepthTest("none")
		pass:setDepthWrite(false)

		for _, child in ipairs(self:GetDrawOrder()) do
			if child.Visible then
				pass:push("state")
				child:Draw(pass)
				pass:pop("state")
			end
		end
	end
end

function Interface:GetProjection()
	return self._Projection
end

function Interface:SetProjection(projection)
	if projection ~= self._Projection then
		self._Projection = projection

		return true, projection
	end
end

function Interface:Destroy()
	if not self._Destroyed then
		self._Projection = nil

		InterfaceObject.Destroy(self)
	end
end

return Class.CreateClass(Interface, "Interface", InterfaceObject)