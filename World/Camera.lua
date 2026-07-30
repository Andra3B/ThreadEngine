local Camera = {}

function Camera.Create()
	local self = Class.CreateInstance(WorldObject.Create(), Camera)

	self._FieldOfView = math.rad(90)

	self._Near = 0.1
	self._Far = 100

	self._Projection = Class.NIL

	return self
end

function Camera:GetFieldOfView()
	return self._FieldOfView
end

function Camera:SetFieldOfView(fov)
	if fov ~= self._FieldOfView then
		self._FieldOfView = fov

		return true, fov
	end
end

function Camera:GetNear()
	return self._Near
end

function Camera:SetNear(near)
	if near ~= self._Near then
		self._Near = near

		return true, near
	end
end

function Camera:GetFar()
	return self._Far
end

function Camera:SetFar(far)
	if far ~= self._Far then
		self._Far = far

		return true, far
	end
end

--[[DependsOn: FieldOfView, Near, Far]]--
function Camera:GetProjection()
	if self._Projection == Class.NIL then
		self._Projection = Matrix4.CreatePerspectiveProjection(
			lovr.system.getWindowWidth() / lovr.system.getWindowHeight(),
			self._FieldOfView,
			self._Near, self._Far
		)
	end

	return self._Projection
end

function Camera:SetProjection(projection)
	if projection ~= self._Projection then
		self._Projection = projection

		return true, projection
	end
end

function Camera:Destroy()
	if not self._Destroyed then
		self._Projection = nil

		WorldObject.Destroy(self)
	end
end

return Class.CreateClass(Camera, "Camera", WorldObject, scriptpath())