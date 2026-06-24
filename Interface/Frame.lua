local Frame = {}

function Frame.Create()
    local self = Class.CreateInstance(InterfaceObject.Create(), Frame)

    self._Origin = ScaleOffset2.Zero
    self._AbsoluteOrigin = Class.NIL

    -- CornerRadius Format: (top-left, top-right, bottom-right, bottom-left)
    self._CornerRadius = ScaleOffset4.Zero
    self._AbsoluteCornerRadius = Class.NIL

    self._BorderSize = 0
    self._BorderColour = Vector4.Black

    self._BackgroundColour = Vector4.White

    return self
end

function Frame:Draw(pass)
    pass:send("InverseTransform", self.InverseTransform.Components)

    pass:send("Size", {self.AbsoluteSize:Unpack()})

    pass:send("CornerRadius", {self.AbsoluteCornerRadius:Unpack()})
    pass:send("BorderSize", self._BorderSize)
    pass:send("BorderColour", {self._BorderColour:Unpack()})

	pass:setColor(self._BackgroundColour:Unpack())

    pass:draw(Thread.Meshes.Square, self.LovrTransform, 1)
end

--[[DependsOn: Position, Parent, ParentAbsoluteSize, ParentAbsolutePosition, ParentAbsoluteAngle, AbsoluteOrigin, Angle]]--
function Frame:GetAbsolutePosition()
    if self._AbsolutePosition == Class.NIL then
        if Class.IsA(self._Parent, "InterfaceObject") then
            self._AbsolutePosition = self._Parent.AbsolutePosition + (
				self._Position.Offset + self._Parent.AbsoluteSize * self._Position.Scale -
				self.AbsoluteOrigin:Rotate(self._Angle)
			):Rotate(self._Parent.AbsoluteAngle)
        else
            self._AbsolutePosition = self._Position.Offset
        end
    end

    return self._AbsolutePosition
end

--[[DependsOn: Size, Parent, ParentAbsoluteSize]]--
function Frame:GetAbsoluteSize()
    if self._AbsoluteSize == Class.NIL then
        if Class.IsA(self._Parent, "InterfaceObject") then
            self._AbsoluteSize = self._Size.Offset + self._Parent.AbsoluteSize * self._Size.Scale
        else
            self._AbsoluteSize = self._Size.Offset
        end
    end

    return self._AbsoluteSize
end

--[[DependsOn: Angle, Parent, ParentAbsoluteAngle]]--
function Frame:GetAbsoluteAngle()
    if self._AbsoluteAngle == Class.NIL then
        if Class.IsA(self._Parent, "InterfaceObject") then
            self._AbsoluteAngle = self._Angle + self._Parent.AbsoluteAngle
        else
            self._AbsoluteAngle = self._Angle
        end
    end

    return self._AbsoluteAngle
end

function Frame:GetOrigin()
    return self._Origin
end

function Frame:SetOrigin(origin)
    if origin ~= self._Origin then
        self._Origin = origin

        return true, origin
    end
end

--[[DependsOn: Origin, AbsoluteSize]]--
function Frame:GetAbsoluteOrigin()
    if self._AbsoluteOrigin == Class.NIL then
        self._AbsoluteOrigin = self._Origin.Offset + self.AbsoluteSize * self._Origin.Scale
    end

    return self._AbsoluteOrigin
end

function Frame:SetAbsoluteOrigin(origin)
    if origin ~= self._AbsoluteOrigin then
        self._AbsoluteOrigin = origin

        return true, origin
    end
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

function Frame:Destroy()
    if not self._Destroyed then
        self._Origin = nil
        self._AbsoluteOrigin = nil

        self._CornerRadius = nil
        self._AbsoluteCornerRadius = nil

        self._BorderColour = nil

        self._BackgroundColour = nil

        InterfaceObject.Destroy(self)
    end
end

return Class.CreateClass(Frame, "Frame", InterfaceObject, scriptpath())