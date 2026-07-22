local PointLight = {}

function PointLight.Create()
	local self = Class.CreateInstance(Light.Create(), PointLight)

	self.LightType = Enum.LightType.Point

	return self
end

return Class.CreateClass(PointLight, "PointLight", Light, scriptpath())