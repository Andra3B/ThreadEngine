local Interactive = lovr.filesystem.load("Interface/Interactive.lua")(Label)

local Button = {}

function Button.Create()
	local self = Class.CreateInstance(Interactive.Create(), Button)
	
	self.CanFocus = false

	return self
end

return Class.CreateClass(Button, "Button", Interactive, scriptpath())