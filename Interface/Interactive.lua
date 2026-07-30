local BASE_CLASS = ...

local Interactive = {}

function Interactive.Create()
	local self = Class.CreateInstance(BASE_CLASS.Create(), Interactive)
	
	self._Pressed = false
	self._Focused = false
	self._Hovering = false

	self._Active = true
	self._AbsoluteActive = Class.NIL

	self._CanFocus = true

	self._FocusedBackgroundColour = nil
	self._PressedBackgroundColour = Vector4.Create(1, 1, 1, 0.2)
	self._HoveringBackgroundColour = Vector4.Create(1, 1, 1, 0.15)
	self._InactiveOverlayColour = Vector4.Create(1, 1, 1, 0.7)

	return self
end

function Interactive:GetBackgroundColour()
	local backgroundColour = BASE_CLASS.GetBackgroundColour(self)

	if self.AbsoluteActive then
		if self._Pressed then
			return self.PressedBackgroundColour or backgroundColour
		elseif self._Hovering then
			return self.HoveringBackgroundColour or backgroundColour
		elseif self._Focused then
			return self.FocusedBackgroundColour or backgroundColour
		end
	end
	
	return backgroundColour
end

function Interactive:GetPressed()
	return self._Pressed
end

function Interactive:SetPressed(pressed)
	if pressed ~= self._Pressed then		
		self._Pressed = pressed

		return true, pressed
	end
end

function Interactive:GetFocused()
	return self._Focused
end

function Interactive:SetFocused(focused)
	if focused ~= self._Focused then
		self._Focused = focused

		return true, focused
	end
end

function Interactive:GetHovering()
	return self._Hovering
end

function Interactive:SetHovering(hovering)
	if hovering ~= self._Hovering then
		self._Hovering = hovering
		
		return true, hovering
	end
end

function Interactive:IsActive()
	return self._Active
end

function Interactive:SetActive(active)
	if active ~= self._Active then
		self._Active = active

		return true, active
	end
end

function Interactive:GetCanFocus()
	return self._CanFocus
end

function Interactive:SetCanFocus(canFocus)
	if canFocus ~= self._CanFocus then
		self._CanFocus = canFocus

		return true, canFocus
	end
end

function Interactive:GetFocusedBackgroundColour()
	return self._FocusedBackgroundColour
end

function Interactive:SetFocusedBackgroundColour(colour)
	if colour ~= self._FocusedBackgroundColour then
		self._FocusedBackgroundColour = colour

		return true, colour
	end
end

function Interactive:GetHoveringBackgroundColour()
	return self._HoveringBackgroundColour
end

function Interactive:SetHoveringBackgroundColour(colour)
	if colour ~= self._HoveringBackgroundColour then
		self._HoveringBackgroundColour = colour

		return true, colour
	end
end

function Interactive:GetPressedBackgroundColour()
	return self._PressedBackgroundColour
end

function Interactive:SetPressedBackgroundColour(colour)
	if colour ~= self._PressedBackgroundColour then
		self._PressedBackgroundColour = colour

		return true, colour
	end
end

function Interactive:GetInactiveOverlayColour()
	return self._InactiveOverlayColour
end

function Interactive:SetInactiveOverlayColour(colour)
	if colour ~= self._InactiveOverlayColour then
		self._InactiveOverlayColour = colour

		return true, colour
	end
end

--[[DependsOn: Parent, ParentAbsoluteActive, Active]]--
function Interactive:GetAbsoluteActive()
	if self._AbsoluteActive == Class.NOT_SET then
		if Class.IsA(self._Parent, "Interactive") then 
			self._AbsoluteActive = self._Active and self._Parent.AbsoluteActive
		else
			self._AbsoluteActive = self._Active
		end
	end

	return self._AbsoluteActive
end

function Interactive:SetAbsoluteActive(active)
	if active ~= self._AbsoluteActive then
		self._AbsoluteActive = active
		
		return true, active
	end
end

function Interactive:Destroy()
	if not self._Destroyed then
		self._FocusedBackgroundColour = nil
		self._PressedBackgroundColour = nil
		self._HoveringBackgroundColour = nil
		self._InactiveOverlayColour = nil
		
		BASE_CLASS.Destroy(self)
	end
end

return Class.CreateClass(Interactive, "Interactive", BASE_CLASS, scriptpath())