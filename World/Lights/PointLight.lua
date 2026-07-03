local PointLight = {}

Enum.FallOffType = Enum.Create({
	None = 0,
	Linear = 1,
	InverseLinear = 2,
	InverseSquare = 3
})

function PointLight.Create()
	local self = Class.CreateInstance(Light.Create(), PointLight)

	self._Range = 20

	self._FallOffType = Enum.FallOffType.Linear
	self._FallOffCoefficient = 0.1

	return self
end

function PointLight:GetLightType()
	return Enum.LightType.Point
end

function PointLight:GetRange()
	return self._Range
end

function PointLight:SetRange(range)
	if range ~= self._Range then
		self._Range = range

		return true, range
	end
end

function PointLight:GetFallOffType()
	return self._FallOffType
end

function PointLight:SetFallOffType(fallOffType)
	if fallOffType ~= self._FallOffType then
		self._FallOffType = fallOffType

		return true, fallOffType
	end
end

function PointLight:GetFallOffCoefficient()
	return self._FallOffCoefficient
end

function PointLight:SetFallOffCoefficient(coefficient)
	if coefficient ~= self._FallOffCoefficient then
		self._FallOffCoefficient = coefficient

		return true, coefficient
	end
end

--[[DependsOn: Range, FallOffType, FallOffCoefficient]]--
function PointLight:GetWorldStateRefresh()
	return Light.GetWorldStateRefresh(self)
end

return Class.CreateClass(PointLight, "PointLight", Light, scriptpath())