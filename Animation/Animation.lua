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
	if channel and not self._Channels[channel.Property] then
		self._Channels[channel.Property] = channel
		self._Duration = math.max(self._Duration, channel.Duration)

		return true
	end

	return false
end

function Animation:RemoveChannel(channel)
	channel = self._Channels[type(channel) == "table" and channel.Property or channel]

	if channel then
		self._Channels[channel.Property] = nil

		if channel.Duration == self._Duration then
			self._Duration = 0

			for _, currentChannel in ipairs(self._Channels) do
				self._Duration = math.max(self._Duration, channel.Duration)
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
		table.erase(self._Channels, AnimationChannel.Destroy)
		self._Channels = nil

		Hierarchy.Destroy(self)
	end
end

return Class.CreateClass(Animation, "Animation", Hierarchy)