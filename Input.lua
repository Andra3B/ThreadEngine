local Input = {}

Enum.InputType = Enum.Create({
	Unknown = 0,
	Keyboard = 1,
	Mouse = 2
})

Enum.InputPriority = Enum.Create({
	Lowest = 1,
	Low = 2,
	Medium = 3,
	High = 4,
	Highest = 5
})

Enum.Input = Enum.Create({
	-- Keyboard
	A = "k_a",
	B = "k_b",
	C = "k_c",
	D = "k_d",
	E = "k_e",
	F = "k_f",
	G = "k_g",
	H = "k_h",
	I = "k_i",
	J = "k_j",
	K = "k_k",
	L = "k_l",
	M = "k_m",
	N = "k_n",
	O = "k_o",
	P = "k_p",
	Q = "k_q",
	R = "k_r",
	S = "k_s",
	T = "k_t",
	U = "k_u",
	V = "k_v",
	W = "k_w",
	X = "k_x",
	Y = "k_y",
	Z = "k_z",
	Zero = "k_0",
	One = "k_1",
	Two = "k_2",
	Three = "k_3",
	Four = "k_4",
	Five = "k_5",
	Six = "k_6",
	Seven = "k_7",
	Eight = "k_8",
	Nine = "k_9",
	Enter = "k_return",
	Escapse = "k_escape",
	Backspace = "k_backspace",
	Tab = "k_tab",
	Space = "k_space",
	Minus = "k_-",
	Equal = "k_=",
	LeftSquareBracket = "k_[",
	RightSquareBracket = "k_]",
	BackSlash = "k_\\",
	Semicolon = "k_;",
	Apostrophe = "k_'",
	Backtick = "k_`",
	Comma = "k_,",
	Period = "k_.",
	ForwardSlash = "k_/",
	CapsLock = "k_capslock",
	F1 = "k_f1",
	F2 = "k_f2",
	F3 = "k_f3",
	F4 = "k_f4",
	F5 = "k_f5",
	F6 = "k_f6",
	F7 = "k_f7",
	F8 = "k_f8",
	F9 = "k_f9",
	F10 = "k_f10",
	F11 = "k_f11",
	F12 = "k_f12",
	F13 = "k_f13",
	F14 = "k_f14",
	F15 = "k_f15",
	F16 = "k_f16",
	F17 = "k_f17",
	F18 = "k_f18",
	F19 = "k_f19",
	F20 = "k_f20",
	F21 = "k_f21",
	F22 = "k_f22",
	F23 = "k_f23",
	F24 = "k_f24",
	LeftControl = "k_lctrl",
	LeftShift = "k_lshift",
	LeftAlt = "k_lalt",
	LeftGui = "k_lgui",
	RightControl = "k_rctrl",
	RightShift = "k_rshift",
	RightAlt = "k_ralt",
	RightGui = "k_rgui",
	PrintScreen = "k_printscreen",
	ScrollLock = "k_scrolllock",
	Pause = "k_pause",
	Insert = "k_insert",
	Home = "k_home",
	NumLock = "k_numlock",
	PageUp = "k_pageup",
	Delete = "k_delete",
	PageDown = "k_pagedown",
	End = "k_end",
	UpArrow = "k_up",
	DownArrow = "k_down",
	LeftArrow = "k_left",
	RightArrow = "k_right",
	Application = "k_application",
	KeypadForwardSlash = "k_kp/",
	KeypadStar = "k_kp*",
	KeypadMinus = "k_kp-",
	KeypadPlus = "k_kp+",
	KeypadEnter = "k_kpenter",
	KeypadZero = "k_kp0",
	KeypadOne = "k_kp1",
	KeypadTwo = "k_kp2",
	KeypadThree = "k_kp3",
	KeypadFour = "k_kp4",
	KeypadFive = "k_kp5",
	KeypadSix = "k_kp6",
	KeypadSeven = "k_kp7",
	KeypadEight = "k_kp8",
	KeypadNine = "k_kp9",
	KeypadPeriod = "k_kp.",

	-- Mouse
	MouseMovement = "m_movement",
	MouseWheelMovement = "m_wheelmovement",
	LeftMouseButton = "m_leftmousebutton",
	RightMouseButton = "m_rightmousebutton",
	MiddleMouseButton = "m_middlemousebutton",
	FirstMouseButton = "m_firstmousebutton",
	SecondMouseButton = "m_secondmousebutton"
})

Input.Inputs = {}

function Input.TriggerInput(input, direction, invert)
	for _, inputs in pairs(Input.Inputs) do
		for _, inputObject in ipairs(inputs) do
			if inputObject._Enabled then
				local setDirection = inputObject._Mappings[input]

				if setDirection then
					direction = setDirection == table.empty and direction or setDirection

					if invert == nil then
						inputObject.Direction = Vector3.Create(
							direction.X or inputObject._Direction.X,
							direction.Y or inputObject._Direction.Y,
							direction.Z or inputObject._Direction.Z
						)
					else
						inputObject.Direction = inputObject._Direction + (invert and -direction or direction)
					end
					
					inputObject._Events:Trigger("InputChanged", input)
					
					break
				end
			end
		end
	end
end

function Input.GetInputType(input)
	local prefix = string.sub(input, 1, 2)

	if prefix == "k_" then
		return Enum.InputType.Keyboard
	elseif prefix == "m_" then
		return Enum.InputType.Mouse
	else
		return Enum.InputType.Unknown
	end
end

function Input.Create(name, priority)
	name = name or "UnknownInput"
	priority = priority or Enum.InputPriority.Lowest

	local self = Class.CreateInstance(Object.Create(), Input)

	self._Name = name

	self._Priority = priority

	self._Direction = Vector3.Zero

	self._Mappings = {}

	self._Enabled = true

	local inputs = Input.Inputs[name]

	if inputs then
		for index, input in ipairs(inputs) do
			if priority >= input._Priority then
				table.insert(inputs, index, self)
			end
		end
	else
		Input.Inputs[name] = {self}
	end

	return self
end

function Input:SetName()
	return false
end

function Input:GetPriority()
	return self._Priority
end

function Input:SetPriority(priority)
	if priority ~= self.Priority then
		self._Priority = priority

		local inputs = Input.Inputs[self.Name]

		if #inputs > 1 then
			for index, input in ipairs(inputs) do
				if input == self then
					table.remove(inputs, index)

					break
				end
			end

			for index, input in ipairs(inputs) do
				if priority >= input.Priority then
					table.insert(inputs, index, self)
				end
			end
		end

		return true, priority
	end
end

function Input:GetDirection()
	return self._Direction
end

function Input:SetDirection(direction)
	if direction ~= self._Direction then
		self._Direction = direction

		return true, direction
	end
end

function Input:GetMappings()
	return self._Mappings
end

function Input:SetMapping(input, direction)
	direction = direction or table.empty

	if direction ~= self._Mappings[input] then
		self._Mappings[input] = direction

		return true, direction
	end
end

function Input:GetEnabled()
	return self._Enabled
end

function Input:SetEnabled(enabled)
	if enabled ~= self._Enabled then
		self._Enabled = enabled

		return true, enabled
	end
end

function Input:Destroy()
	if not self._Destroyed then
		local inputs = Input.Inputs[self._Name]

		for index, input in ipairs(inputs) do
			if input == self then
				table.remove(inputs, index)

				break
			end
		end

		self._Direction = nil

		Object.Destroy(self)
	end
end

function Input.DestroyInputs()
	for _, inputs in pairs(Input.Inputs) do
		table.erase(inputs, Input.Destroy)
	end
end

return Class.CreateClass(Input, "Input", Object)