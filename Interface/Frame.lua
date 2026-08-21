local Frame = {}

function Frame.Create()
    local self = Class.CreateInstance(InterfaceObject.Create(), Frame)

    -- CornerRadius Format: (top-left, top-right, bottom-right, bottom-left)
    self._CornerRadius = ScaleOffset4.Zero
    self._AbsoluteCornerRadius = Class.NIL

    self._BorderSize = 0
    self._BorderColour = Vector4.Black

    self._BackgroundColour = Vector4.White

	self._ChildOverflow = true

	self._Visible = true

    return self
end

function Frame:Draw(pass, stencil)
    pass:send("InverseTransform", self.InverseTransform.Components)
    pass:send("Size", {self.AbsoluteSize:Unpack()})
    pass:send("CornerRadius", {self.AbsoluteCornerRadius:Unpack()})

	if stencil then
		pass:send("BorderSize", 0)
	else
		pass:send("BorderSize", self._BorderSize)
		pass:send("BorderColour", {self.BorderColour:Unpack()})

		pass:setColor(self.BackgroundColour:Unpack())
	end

    pass:draw(Thread.Meshes.Square.Mesh, self.LovrTransform, 1)
end

function Frame:GetCornerRadius()
    return self._CornerRadius
end

function Frame:SetCornerRadius(radius)
    if radius ~= self._CornerRadius then
        self._CornerRadius = radius

        return true, radius
    end
end

--[[DependsOn: CornerRadius, AbsoluteSize]]--
function Frame:GetAbsoluteCornerRadius()
    if self._AbsoluteCornerRadius == Class.NIL then
        self._AbsoluteCornerRadius = self._CornerRadius.Offset + self._CornerRadius.Scale * (math.min(self.AbsoluteSize:Unpack()) * 0.5)
    end

    return self._AbsoluteCornerRadius
end

function Frame:SetAbsoluteCornerRadius(radius)
    if radius ~= self._AbsoluteCornerRadius then
        self._AbsoluteCornerRadius = radius

		if radius ~= Class.NIL then
			self.CornerRadius = ScaleOffset4.Create(
				self._CornerRadius.Scale,
				radius - self._CornerRadius.Scale * (math.min(self.AbsoluteSize:Unpack()) * 0.5)
			)
		end

        return true, radius
    end
end

function Frame:GetBorderSize()
    return self._BorderSize
end

function Frame:SetBorderSize(size)
    if size ~= self._BorderSize then
        self._BorderSize = size

        return true, size
    end
end

function Frame:GetBorderColour()
    return self._BorderColour
end

function Frame:SetBorderColour(colour)
    if colour ~= self._BorderColour then
        self._BorderColour = colour

        return true, colour
    end
end

function Frame:GetBackgroundColour()
    return self._BackgroundColour
end

function Frame:SetBackgroundColour(colour)
    if colour ~= self._BackgroundColour then
        self._BackgroundColour = colour

        return true, colour
    end
end

function Frame:GetChildOverflow()
	return self._ChildOverflow
end

function Frame:SetChildOverflow(overflow)
	if overflow ~= self._ChildOverflow then
		self._ChildOverflow = overflow

		return true, overflow
	end
end

function Frame:IsVisible()
	return self._Visible
end

function Frame:SetVisible(visible)
	if visible ~= self._Visible then
		self._Visible = visible
		
		return true, visible
	end
end

function Frame:Destroy()
    if not self._Destroyed then
        self._CornerRadius = nil
        self._AbsoluteCornerRadius = nil

        self._BorderColour = nil

        self._BackgroundColour = nil

        InterfaceObject.Destroy(self)
    end
end

return Class.CreateClass(Frame, "Frame", InterfaceObject, scriptpath())