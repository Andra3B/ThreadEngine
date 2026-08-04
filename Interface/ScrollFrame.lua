local Interactive = lovr.filesystem.load("Interface/Interactive.lua")(Frame)

local ScrollFrame = {}

local function OnHorizontalScrollBarPressed(scrollFrame, scrollBar, pressed)
	if pressed then
		local x = lovr.system.getMousePosition()

		scrollFrame._ScrollOffset = x - scrollBar.AbsolutePosition.X
	else
		scrollFrame._ScrollOffset = nil
	end
end

local function OnVerticalScrollBarPressed(scrollFrame, scrollBar, pressed)
	if pressed then
		local _, y = lovr.system.getMousePosition()

		scrollFrame._ScrollOffset = y - scrollBar.AbsolutePosition.Y
	else
		scrollFrame._ScrollOffset = nil
	end
end

function ScrollFrame.Create()
	local self = Class.CreateInstance(Interactive.Create(), ScrollFrame)

	self._FocusedBackgroundColour = nil
	self._PressedBackgroundColour = nil
	self._HoveringBackgroundColour = nil

	self._ScrollOffset = nil

	self._Overlay = Frame.Create()
	self._Overlay.Name = "Overlay"
	self._Overlay.Size = ScaleOffset2.Create(1, 1, 0, 0)
	self._Overlay.BackgroundColour = Vector4.Zero
	self._Overlay.Depth = -1
	
	self._Container = Frame.Create()
	self._Container.Name = "Container"
	self._Container.Size = ScaleOffset2.Create(1, 1, 0, 0)
	self._Container.BackgroundColour = Vector4.Zero
	self._Container.ChildOverflow = false

	self._HorizontalScrollBar = Button.Create()
	self._HorizontalScrollBar.Name = "HorizontalScrollBar"
	self._HorizontalScrollBar.Size = ScaleOffset2.Create(0, 0, 0, 16)
	self._HorizontalScrollBar.Origin = ScaleOffset2.Create(0, 1, 0, 0)
	self._HorizontalScrollBar.BackgroundColour = Vector4.Create(0, 0, 0, 0.3)
	self._HorizontalScrollBar.Visible = false
	self._HorizontalScrollBar.Events:Listen("PressedChanged", OnHorizontalScrollBarPressed, self)
	
	self._VerticalScrollBar = Button.Create()
	self._VerticalScrollBar.Name = "VerticalScrollBar"
	self._VerticalScrollBar.Size = ScaleOffset2.Create(0, 0, 16, 0)
	self._VerticalScrollBar.Origin = ScaleOffset2.Create(1, 0, 0, 0)
	self._VerticalScrollBar.BackgroundColour = Vector4.Create(0, 0, 0, 0.3)
	self._VerticalScrollBar.Visible = false
	self._VerticalScrollBar.Events:Listen("PressedChanged", OnVerticalScrollBarPressed, self)

	self._VerticalScrollBar.Parent = self._Overlay
	self._HorizontalScrollBar.Parent = self._Overlay

	self._Overlay.Parent = self
	self._Container.Parent = self

	return self
end

function ScrollFrame:Update(deltaTime)
	Interactive.Update(self, deltaTime)

	if self._ScrollOffset then
		local x, y = lovr.system.getMousePosition()
		local scrollBarWidth = self._HorizontalScrollBar.Size.Offset.Y
		
		if self._HorizontalScrollBar.Pressed then
			local denominator = self.AbsoluteSize.X - self._HorizontalScrollBar.AbsoluteSize.X - scrollBarWidth
			local scrollFactor =
				denominator ~= 0 and
				math.clamp((x - self._ScrollOffset - self.AbsolutePosition.X) / denominator, 0, 1) or
				0

			self._Container.AbsoluteChildShift = -Vector2.Create(
				self._Container.ChildExtents.Min.X + math.max(
					self._Container.ChildExtents.Max.X - self._Container.ChildExtents.Min.X - self.AbsoluteSize.X, 0
				) * scrollFactor,
				-self._Container.AbsoluteChildShift.Y
			)
		else
			local denominator = self.AbsoluteSize.Y - self._VerticalScrollBar.AbsoluteSize.Y - scrollBarWidth
			local scrollFactor =
				denominator ~= 0 and
				math.clamp((y - self._ScrollOffset - self.AbsolutePosition.Y) / denominator, 0, 1) or
				0

			self._Container.AbsoluteChildShift = -Vector2.Create(
				-self._Container.AbsoluteChildShift.X,
				self._Container.ChildExtents.Min.Y + math.max(
					self._Container.ChildExtents.Max.Y - self._Container.ChildExtents.Min.Y - self.AbsoluteSize.Y, 0
				) * scrollFactor
			)
		end
	end
end

function ScrollFrame:Draw(pass, stencil)
	if not stencil then
		local containerMin = self._Container.ChildExtents.Min
		local containerMax = self._Container.ChildExtents.Max
		local containerSize = containerMax - containerMin

		local size = self.AbsoluteSize
		local scrollBarWidth = self._HorizontalScrollBar.Size.Offset.Y
		
		local viewPosition = -self._Container.AbsoluteChildShift

		if containerSize.X > size.X then
			self._HorizontalScrollBar.Size = ScaleOffset2.Create(
				0, 0, (size.X / containerSize.X) * (size.X - scrollBarWidth), scrollBarWidth
			)

			self._HorizontalScrollBar.Position = ScaleOffset2.Create(
				0, 1, (math.clamp(viewPosition.X - containerMin.X, 0, containerSize.X - size.X) / containerSize.X) * (size.X - scrollBarWidth), 0
			)

			self._HorizontalScrollBar.Visible = true
		else
			self._HorizontalScrollBar.Visible = false
		end

		if containerSize.Y > size.Y then
			self._VerticalScrollBar.Size = ScaleOffset2.Create(
				0, 0, self._VerticalScrollBar.Size.Offset.X, (size.Y / containerSize.Y) * (size.Y - scrollBarWidth)
			)

			self._VerticalScrollBar.Position = ScaleOffset2.Create(
				1, 0, 0, (math.clamp(viewPosition.Y - containerMin.Y, 0, containerSize.Y - size.Y) / containerSize.Y) * (size.Y - scrollBarWidth)
			)

			self._VerticalScrollBar.Visible = true
		else
			self._VerticalScrollBar.Visible = false
		end
	end

	Interactive.Draw(self, pass, stencil)
end

function ScrollFrame:Scroll(delta)
	local containerExtents = self._Container.ChildExtents

	self._Container.AbsoluteChildShift = Vector2.Create(
		-math.clamp(-self._Container.AbsoluteChildShift.X - delta.X, containerExtents.Min.X, math.max(containerExtents.Min.X, containerExtents.Max.X - self.AbsoluteSize.X)),
		-math.clamp(-self._Container.AbsoluteChildShift.Y - delta.Y, containerExtents.Min.Y, math.max(containerExtents.Min.Y, containerExtents.Max.Y - self.AbsoluteSize.Y))
	)
end

function ScrollFrame:IsScrolling()
	return self._ScrollOffset ~= nil
end

function ScrollFrame:GetOverlay()
	return self._Overlay
end

function ScrollFrame:GetContainer()
	return self._Container
end

function ScrollFrame:GetHorizontalScrollBar()
	return self._HorizontalScrollBar
end

function ScrollFrame:GetVerticalScrollBar()
	return self._VerticalScrollBar
end

function ScrollFrame:Destroy()
	if not self._Destroyed then
		self._Overlay = nil
		self._Container = nil

		self._HorizontalScrollBar = nil
		self._VerticalScrollBar = nil

		Interactive.Destroy(self)
	end
end

return Class.CreateClass(ScrollFrame, "ScrollFrame", Interactive)