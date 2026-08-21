local AnimationChannel = {}

Enum.AnimationSmoothing = Enum.Create({
	Step = "step",
	Linear = "linear",
	Cubic = "cubic"
})

Enum.AnimationPropertyType = Enum.Create({
	Number = 1,
	Vector = 2,
	Quaternion = 3
})

AnimationChannel.InterpolationCallbacks = {
	[Enum.AnimationPropertyType.Number] = function(from, to, alpha)
		return from + (to - from) * alpha
	end,

	[Enum.AnimationPropertyType.Vector] = function(from, to, alpha)
		return from:Lerp(to, alpha)
	end,

	[Enum.AnimationPropertyType.Quaternion] = Quaternion.Slerp
}

function AnimationChannel.Create(target, property, propertyType, smoothing)
	local self = Class.CreateInstance(Object.Create(), AnimationChannel)

	self._Target = target
	self._Property = property
	self._PropertyType = propertyType
	self._Smoothing = smoothing

	self._Keyframes = {}

	self._InterpolationCallback = interpolationCallback

	return self
end

function AnimationChannel:Evaluate(time)
	if #self._Keyframes > 0 then
		if time <= self._Keyframes[1].Time then
			return self._Keyframes[1].Value
		elseif time >= self._Keyframes[#self._Keyframes].Time then
			return self._Keyframes[#self._Keyframes].Value
		else
			local previousKeyframe, nextKeyframe

			for index, keyframe in ipairs(self._Keyframes) do
				if keyframe.Time >= time then
					previousKeyframe = self._Keyframes[index - 1]
					nextKeyframe = keyframe

					break
				end
			end

			if self._Smoothing == Enum.AnimationSmoothing.Step then
				return previousKeyframe.Value
			else
				local alpha = (time - previousKeyframe.Time) / (nextKeyframe.Time - previousKeyframe.Time)
				alpha =
					(self._Smoothing == Enum.AnimationSmoothing.Cubic and (1 - (1 - alpha)^3)) or
					alpha

				return AnimationChannel.InterpolationCallbacks[self._PropertyType](
					previousKeyframe.Value,
					nextKeyframe.Value,
					alpha
				)
			end
		end
	end
end

function AnimationChannel:GetTarget()
	return self._Target
end

function AnimationChannel:GetProperty()
	return self._Property
end

function AnimationChannel:GetPropertyType()
	return self._PropertyType
end

function AnimationChannel:GetSmoothing()
	return self._Smoothing
end

function AnimationChannel:GetKeyframes()
	return self._Keyframes
end

function AnimationChannel:AddKeyframe(time, value, userData)
	local index = 1

	while index <= #self._Keyframes and self._Keyframes[index].Time < time do
		index = index + 1
	end

	local keyframe = self._Keyframes[index]

	if keyframe and time == keyframe.Time then
		keyframe.Value = value
		keyframe.UserData = userData
	else
		table.insert(self._Keyframes, index, {
			Time = time,
			Value = value,
			UserData = userData
		})
	end
end

function AnimationChannel:RemoveKeyframe(index)
	local keyframe = self._Keyframes[index]

	if keyframe then
		table.remove(self._Keyframes, index)

		keyframe.Value = nil
		keyframe.UserData = nil
	end
end

function AnimationChannel:GetInterpolationCallback()
	return self._InterpolationCallback
end

function AnimationChannel:GetDuration()
	local lastKeyframe = self._Keyframes[#self._Keyframes]
	return lastKeyframe and lastKeyframe.Time or 0
end

function AnimationChannel:Destroy()
	if not self._Destroyed then
		while #self._Keyframes > 0 do
			self:RemoveKeyframe(#self._Keyframes)
		end
		
		self._Keyframes = nil

		self._InterpolationCallback = nil

		Object.Destroy(self)
	end
end

return Class.CreateClass(AnimationChannel, "AnimationChannel", Object)