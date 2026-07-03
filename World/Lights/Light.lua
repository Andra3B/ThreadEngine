local Light = {}

Enum.LightType = Enum.Create({
	Point = 0,
	Spot = 1,
	Directional = 2
})

function Light.Create()
	local self = Class.CreateInstance(WorldNode.Create(), Light)

	self._Colour = Vector3.One
	self._Intensity = 10

	self._Enabled = true

	self._LightIndex = 0
	self._WorldStateRefresh = Class.NIL

	return self
end

function Light:RefreshWorldLightState(remove)
	local world = self:GetAncestorWithType("World")

	if world then
		world:RefreshLight(self, remove)
	end
end

function Light:GetColour()
	return self._Colour
end

function Light:SetColour(colour)
	if colour ~= self._Colour then
		self._Colour = colour

		return true, colour
	end
end

function Light:GetIntensity()
	return self._Intensity
end

function Light:SetIntensity(intensity)
	if intensity ~= self._Intensity then
		self._Intensity = intensity

		return true, intensity
	end
end

function Light:IsEnabled()
	return self._Enabled
end

function Light:SetEnabled(enabled)
	if enabled ~= self._Enabled then
		self._Enabled = enabled

		return true, enabled
	end
end

--[[DependsOn: Parent, AbsolutePosition, Forward, Enabled, Colour, Intensity]]--
function Light:GetWorldStateRefresh()
	if self._WorldStateRefresh == Class.NIL then
		self._WorldStateRefresh = nil

		return true
	end

	return false
end

function Light:SetWorldStateRefresh(refresh)
	if refresh ~= self._WorldStateRefresh then
		self._WorldStateRefresh = refresh

		return true, refresh
	end
end

function Light:Destroy()
	if not self._Destroyed then
		self:RefreshWorldLightState(true)

		self._Colour = nil

		WorldNode.Destroy(self)
	end
end

return Class.CreateClass(Light, "Light", WorldNode, scriptpath())