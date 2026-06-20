local Interface = {}

function Interface.Create()
	local self = Class.CreateInstance(InterfaceObject.Create(), Interface)
	
	self._Projection = Matrix4.Zero

	return self
end

function Interface:Draw(pass)
	if self._Visible then
		pass:setShader(Thread.Shaders.Interface)
		pass:setProjection("orthographic")

		pass:send("InterfaceProjection", self._Projection.Components)

		for _, child in ipairs(self:GetDrawOrder()) do
			if child.Visible then
				child:Draw(pass)
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