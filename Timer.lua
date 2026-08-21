local Timer = {}

Timer.Timers = {}

function Timer.Update(deltaTime)
	for index, timer in pairs(Timer.Timers) do
		if timer._Running then
			timer.Time = timer._Time + deltaTime

			if timer._Time >= timer._Duration then
				timer.Running = false

				timer._Events:Trigger("TimerElapsed")

				if timer._DestroyOnFinish then
					timer:Destroy()
				end
			end
		end
	end
end

function Timer.Create(duration, destroyOnFinish)
	local self = Class.CreateInstance(Object.Create(), Timer)

	self._Duration = duration
	self._Time = 0

	self._Running = false

	if destroyOnFinish == nil then
		self._DestroyOnFinish = true
	else
		self._DestroyOnFinish = destroyOnFinish
	end

	table.insert(Timer.Timers, self)
	return self
end

function Timer:GetDuration()
	return self._Duration
end

function Timer:SetDuration(duration)
	if duration ~= self._Duration then
		self._Duration = duration

		self.Time = self.Time

		return true, duration
	end
end

function Timer:GetTime()
	return self._Time
end

function Timer:SetTime(time)
	time = math.clamp(time, 0, self.Duration)

	if time ~= self._Time then
		self._Time = time

		return true, time
	end
end

function Timer:IsRunning()
	return self._Running
end

function Timer:SetRunning(running)
	if running ~= self._Running then
		self._Running = running

		return true, running
	end
end

function Timer:GetEvents()
	return self._Events
end

function Timer:Reset()
	self.Running = false
	self.Time = 0
end

function Timer:GetDestroyOnFinish()
	return self._DestroyOnFinish
end

function Timer:Destroy()
	if not self._Destroyed then
		for index, timer in pairs(Timer.Timers) do
			if timer == self then
				table.remove(Timer.Timers, index)

				break
			end
		end

		self.Running = false

		Object.Destroy(self)
	end
end

function Timer.DestroyTimers()
	table.erase(Timer.Timers, Timer.Destroy)
end

return Class.CreateClass(Timer, "Timer", Object)