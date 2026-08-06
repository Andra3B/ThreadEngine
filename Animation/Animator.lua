local Animator = {}

function Animator.Create()
	local self = Class.CreateInstance(Hierarchy.Create(), Animator)
	
	self._Timeline = {}
	self._TimelineDuration = 0

	self._TargetInformation = {}

	self._Time = 0

	return self
end

function Animator:Update(deltaTime)
	if self._TimelineDuration > 0 and Class.IsA(self.Parent, "WorldObject") then
		self._Time = self._Time + deltaTime

		for index = 1, #self._Timeline, 1 do
			local animation = self._Timeline[index]

			local endTime = animation.Time + animation.Animation.Duration

			-- Second condition allows end animations in the timeline to fully finish
			if animation.Animation.Destroyed or (self._Time > endTime and endTime ~= self._TimelineDuration) then
				table.remove(self._Timeline, index).Animation = nil
				index = index - 1
			elseif self._Time >= animation.Time then
				for property, channel in pairs(animation.Animation.Channels) do
					local targetInformation = self._TargetInformation[channel.Target]
					if not targetInformation then
						local targetObject = self.Parent:GetDescendantWithName(channel.Target)

						targetInformation = targetObject and {targetObject} or table.empty
						self._TargetInformation[channel.Target] = targetInformation
					end

					if targetInformation[1] and targetInformation[1][property] then
						local targetPropertyInformation = targetInformation[property]

						local value = channel:Evaluate(self._Time - animation.Time)

						if targetPropertyInformation then
							if
								channel.PropertyType == Enum.AnimationPropertyType.Quaternion and
								value:Dot(targetPropertyInformation.QuaternionReference) < 0
							then
								value = -value
							end

							targetPropertyInformation.ValueSum = targetPropertyInformation.ValueSum + value * animation.Weight
							targetPropertyInformation.WeightSum = targetPropertyInformation.WeightSum + animation.Weight
						else
							targetInformation[property] = {
								ValueSum = value * animation.Weight,
								QuaternionReference = channel.PropertyType == Enum.AnimationPropertyType.Quaternion and value or nil,
								WeightSum = animation.Weight
							}
						end
					end
				end
			end
		end

		for _, targetInformation in pairs(self._TargetInformation) do
			local target = table.remove(targetInformation)

			for property, propertyInformation in pairs(targetInformation) do
				local value = propertyInformation.ValueSum / propertyInformation.WeightSum

				if Class.IsA(value, "Quaternion") then
					value = value:Normalise()
				end

				target[property] = value
			end
		end

		table.clear(self._TargetInformation)

		if self._Time >= self._TimelineDuration then
			self:Stop()
		end
	end
end

function Animator:GetTimeline()
	return self._Timeline
end

function Animator:GetTimelineDuration()
	return self._TimelineDuration
end

function Animator:Play(animation, when, weight)
	when = when or 0
	weight = weight or 1

	local index = 1

	while index <= #self._Timeline and self._Timeline[index].Time < time do
		index = index + 1
	end

	self._TimelineDuration = math.max(self._TimelineDuration, when + animation.Duration)
	
	table.insert(self._Timeline, index, {
		Time = when,
		Animation = animation,
		Weight = weight
	})
end

function Animator:Stop()
	self._TimelineDuration = 0
	self._Time = 0

	while #self._Timeline > 0 do
		table.remove(self._Timeline).Animation = nil
	end
end

function Animator:GetTime()
	return self._Time
end

function Animator:Destroy()
	if not self._Destroyed then
		self:Stop()

		self._Timeline = nil
		self._TargetInformation = nil

		Hierarchy.Destroy(self)
	end
end

return Class.CreateClass(Animator, "Animator", Hierarchy)