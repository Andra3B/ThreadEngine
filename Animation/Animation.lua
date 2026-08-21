local Animation = {}

function Animation.Create()
	local self = Class.CreateInstance(Hierarchy.Create(), Animation)

	self._Channels = {}

	self._Duration = 0

	return self
end

function Animation:GetChannels()
	return self._Channels
end

function Animation:AddChannel(channel)
	if channel then
		local targetChannels = self._Channels[channel.Target]
		if not targetChannels then
			targetChannels = {}
			self._Channels[channel.Target] = targetChannels
		end

		if not targetChannels[channel.Property] then
			targetChannels[channel.Property] = channel
			self._Duration = math.max(self._Duration, channel.Duration)

			return true
		end
	end

	return false
end

function Animation:RemoveChannel(channel, property)
	if type(channel) == "table" then
		property = channel.Property
		channel = channel.Target
	end

	local targetChannels = self._Channels[channel]
	local channel = nil

	if targetChannels then
		channel = targetChannels[property]

		if channel then
			targetChannels[property] = nil

			if channel.Duration == self._Duration then
				self._Duration = 0
				
				for _, currentTargetChannels in pairs(self._Channels) do
					for _, currentChannel in pairs(currentTargetChannels) do
						self._Duration = math.max(self._Duration, currentChannel.Duration)
					end
				end
			end
		end
	end

	return channel
end

function Animation:GetDuration()
	return self._Duration
end

function Animation:Destroy()
	if not self._Destroyed then
		table.erase(self._Channels, AnimationChannel.Destroy, true)
		self._Channels = nil

		Hierarchy.Destroy(self)
	end
end

return Class.CreateClass(Animation, "Animation", Hierarchy)