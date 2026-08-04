local Interface = {}

local function OnInterfaceInteract(interface, input)
	local object = interface:GetObjectContainingPoint(
		Vector2.Create(lovr.system.getMousePosition()),
		"Interactive"
	)

	interface.Hovering = object

	if input.Direction.Z < 0 then
		if not interface._Pressed then
			interface.Pressed = object
			interface.Focused = (object and object.CanFocus) and object or nil
		end
	else
		interface.Pressed = nil
	end
end

local function OnInterfaceScroll(interface, input)
	if interface._Hovering then
		local scrollFrame = Class.IsA(interface._Hovering, "ScrollFrame") and interface._Hovering or interface._Hovering:GetAncestorWithType("ScrollFrame")

		if scrollFrame then
			if input.Direction.Z < 0 then
				scrollFrame:Scroll(Vector2.Create(
					input.Direction.Y * 15,
					0
				))
			else
				scrollFrame:Scroll(Vector2.Create(
					0,
					input.Direction.Y * 15
				))
			end
		end
	end
end

function Interface.Create()
	local self = Class.CreateInstance(InterfaceObject.Create(), Interface)
	
	self._Pressed = nil
	self._Focused = nil
	self._Hovering = nil

	self._Projection = Matrix4.Zero

	self._InterfaceSelectListener = Thread.Keybinds.Interface.Select.Events:Listen("InputChanged", OnInterfaceInteract, self)
	self._InterfaceScrollListener = Thread.Keybinds.Interface.Scroll.Events:Listen("InputChanged", OnInterfaceScroll, self)

	return self
end

function Interface:GetObjectContainingPoint(point, objectType)
	local drawOrder = self:GetDrawOrder()

	for index = #drawOrder, 1, -1 do
		local object = drawOrder[index]

		if not objectType or Class.IsA(object, objectType) then
			local localPoint = object.InverseTransform * point

			if
				localPoint.X >= 0 and localPoint.Y >= 0 and
				localPoint.X <= object.AbsoluteSize.X and localPoint.Y <= object.AbsoluteSize.Y
			then
				return object
			end
		end
	end
end

function Interface:Update(deltaTime)
	InterfaceObject.Update(self, deltaTime)

	for descendant in self:IterateDescendants() do
		descendant:Update(deltaTime)
	end
end

local function Draw(pass, object, clipDepth)
	if Class.IsA(object, "Frame") then
		if not object.ChildOverflow then
			pass:push("state")
			
			pass:setStencilTest("equal", clipDepth)
			pass:setStencilWrite("increment")
			pass:setColorWrite(false)
			
			object:Draw(pass, true)
			
			pass:pop("state")
			
			clipDepth = clipDepth + 1
		end
		
		pass:push("state")
		
		pass:setStencilTest("equal", clipDepth)
		pass:setStencilWrite()

		object:Draw(pass, false)

		pass:pop("state")

		for _, child in ipairs(object:GetChildrenDrawOrder()) do
			Draw(pass, child, clipDepth)
		end

		if not object.ChildOverflow then
			pass:push("state")
			
			pass:setStencilTest("equal", clipDepth)
			pass:setStencilWrite("decrement")
			pass:setColorWrite(false)

			object:Draw(pass, true)

			pass:pop("state")
		end
	end
end

function Interface:Draw(pass)
	pass:setShader(Thread.Shaders.Interface)
	pass:setProjection("matrix", self._Projection:Unpack())
	pass:setViewPose(1, Thread.LovrMatrixIdentity, true)

	pass:setFaceCull("none")

	pass:setDepthTest("none")
	pass:setDepthWrite(false)
	
	for _, child in ipairs(self:GetChildrenDrawOrder()) do
		Draw(pass, child, 0)
	end
end

function Interface:GetPressed()
	return self._Pressed
end

function Interface:SetPressed(pressed)
	if pressed ~= self._Pressed then
		if self._Pressed then
			self._Pressed.Pressed = false
		end
		
		self._Pressed = pressed

		if pressed then
			pressed.Pressed = true
		end

		return true, pressed
	end
end

function Interface:GetFocused()
	return self._Focused
end

function Interface:SetFocused(focused)
	if focused ~= self._Focused then
		if self._Focused then
			self._Focused.Focused = false
		end

		self._Focused = focused

		if focused then
			focused.Focused = true
		end

		return true, focused
	end
end

function Interface:GetHovering()
	return self._Hovering
end

function Interface:SetHovering(hovering)
	if hovering ~= self._Hovering then
		if self._Hovering then
			self._Hovering.Hovering = false
		end

		self._Hovering = hovering

		if hovering then
			hovering.Hovering = true
		end

		return true, hovering
	end
end

function Interface:GetProjection()
	return self._Projection
end

function Interface:SetProjection(projection)
	if projection ~= self._Projection then
		self._Projection = projection

		return true, projection
	end
end

function Interface:Destroy()
	if not self._Destroyed then
		self._Pressed = nil
		self._Focused = nil
		self._Hovering = nil

		self._Projection = nil

		self._InterfaceSelectListener:Destroy()
		self._InterfaceSelectListener = nil

		self._InterfaceScrollListener:Destroy()
		self._InterfaceScrollListener = nil

		InterfaceObject.Destroy(self)
	end
end

return Class.CreateClass(Interface, "Interface", InterfaceObject)