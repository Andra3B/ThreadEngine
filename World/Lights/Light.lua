local Light = {}

Enum.FallOffType = Enum.Create({
	None = 0,
	Linear = 1,
	InverseLinear = 2,
	InverseSquare = 3
})

Enum.LightType = Enum.Create({
	Point = 0,
	Spot = 1,
	Directional = 2
})

function Light.Create()
	local self = Class.CreateInstance(WorldObject.Create(), Light)

	self._Colour = Vector3.One
	self._Intensity = 3

	self._Range = 20

	self._FallOffType = Enum.FallOffType.Linear
	self._FallOffCoefficient = 0.1

	self._Enabled = true
	
	self._LightIndex = 0
	self._Changed = Class.NIL

	return self
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

function Light:GetRange()
	return self._Range
end

function Light:SetRange(range)
	if range ~= self._Range then
		self._Range = range

		return true, range
	end
end

function Light:GetFallOffType()
	return self._FallOffType
end

function Light:SetFallOffType(fallOffType)
	if fallOffType ~= self._FallOffType then
		self._FallOffType = fallOffType

		return true, fallOffType
	end
end

function Light:GetFallOffCoefficient()
	return self._FallOffCoefficient
end

function Light:SetFallOffCoefficient(coefficient)
	if coefficient ~= self._FallOffCoefficient then
		self._FallOffCoefficient = coefficient

		return true, coefficient
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

function Light:Upload(forceUpload)
	if self._LightIndex ~= 0 and (self.Changed or forceUpload) then
		local world = self:GetAncestorWithType("World")

		if world then
			world._LightBuffer:setData({{{
				self._Enabled and 1 or 0,
				self.LightType,
				self._FallOffType,
				self._FallOffCoefficient,
				self._Radius or 0,
				self._Range,
				{(self._Colour * self._Intensity):Unpack()},
				{self.Transform.Position:Unpack()},
				{self.Forward:Unpack()}
			}}}, self._LightIndex)
		end

		self.Changed = false
	end
end

--[[DependsOn: Enabled, FallOffType, FallOffCoefficient, Radius, Range, Colour, Intensity, Transform, Forward]]--
function Light:GetChanged()
	return self._Changed == Class.NIL
end

function Light:SetChanged(changed)
	if changed ~= self._Changed then
		self._Changed = changed

		return true, changed
	end
end
function Light:Destroy()
	if not self._Destroyed then
		self._Colour = nil

		WorldObject.Destroy(self)
	end
end

return Class.CreateClass(Light, "Light", WorldObject, scriptpath())