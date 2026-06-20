local Frame = {}

function Frame.Create()
    local self = Class.CreateInstance(InterfaceObject.Create(), Frame)

    self._Position = ScaleOffset2.Zero
    self._AbsolutePosition = Class.NIL

    self._Size = ScaleOffset2.Zero
    self._AbsoluteSize = Class.NIL

    self._Origin = ScaleOffset2.Zero
    self._AbsoluteOrigin = Class.NIL

    self._Angle = 0
    self._AbsoluteAngle = Class.NIL

    self._Transform = Class.NIL
    self._InverseTransform = Class.NIL

    -- CornerRadius Format: (top-left, top-right, bottom-right, bottom-left)
    self._CornerRadius = ScaleOffset4.Zero
    self._AbsoluteCornerRadius = Class.NIL

    self._BorderSize = 0
    self._BorderColour = Vector4.Black

    self._BackgroundColour = Vector4.White

    return self
end

function Frame:Draw(pass)
    pass:send("InterfaceTransform", self.Transform.Components)
    pass:send("InverseInterfaceTransform", self.InverseTransform.Components)

    pass:send("Size", {self.AbsoluteSize:Unpack()})

    pass:send("CornerRadius", {self.AbsoluteCornerRadius:Unpack()})
    pass:send("BorderSize", self._BorderSize)
    pass:send("BorderColour", {self._BorderColour:Unpack()})

    pass:send("BackgroundColour", {self._BackgroundColour:Unpack()})

    pass:draw(Thread.Meshes.Square)
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

function Frame:GetPosition()
    return self._Position
end

function Frame:SetPosition(position)
    if position ~= self._Position then
        self._Position = position

        return true, position
    end
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

function Frame:GetSize()
    return self._Size
end

function Frame:SetSize(size)
    if size ~= self._Size then
        self._Size = size

        return true, size
    end
end

function Frame:GetAngle()
    return self._Angle
end

function Frame:SetAngle(angle)
    if angle ~= self._Angle then
        self._Angle = angle

        return true, angle
    end
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

--[[DependsOn: AbsolutePosition, AbsoluteAngle]]--
function Frame:GetTransform()
	if self._Transform == Class.NIL then
		self._Transform = Matrix4.CreateTransform(
            Vector3.Create(self.AbsolutePosition.X, self.AbsolutePosition.Y, 0),
            Vector3.Create(0, 0, self.AbsoluteAngle),
            Vector3.One,
            Vector3.Zero
        )
	end

	return self._Transform
end

function Frame:SetTransform(transform)
	if transform ~= self._Transform then
		self._Transform = transform

		return true, transform
	end
end

--[[DependsOn: Transform]]--
function Frame:GetInverseTransform()
    if self._InverseTransform == Class.NIL then
        self._InverseTransform = self.Transform:Inverse()
    end

    return self._InverseTransform
end

function Frame:SetInverseTransform(inverse)
    if inverse ~= self._InverseTransform then
        self._InverseTransform = inverse

        return true, inverse
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
        self._Position = nil
        self._Size = nil

        self._Origin = nil
        self._AbsoluteOrigin = nil

        self._Transform = nil
        self._InverseTransform = nil

        self._CornerRadius = nil
        self._AbsoluteCornerRadius = nil

        self._BorderColour = nil

        self._BackgroundColour = nil

        InterfaceObject.Destroy(self)
    end
end

return Class.CreateClass(Frame, "Frame", InterfaceObject, scriptpath())