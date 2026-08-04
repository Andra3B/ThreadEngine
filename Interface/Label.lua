local Label = {}

Enum.HorizontalAlignment = Enum.Create({
    Left = "left",
    Middle = "center",
    Right = "right"
})

Enum.VerticalAlignment = Enum.Create({
    Top = "top",
    Middle = "middle",
    Bottom = "bottom"
})

function Label.Create()
    local self = Class.CreateInstance(Frame.Create(), Label)

    self._Text = ""
	self._DisplayedText = Class.NIL

    self._Font = lovr.graphics.getDefaultFont()

	self._AbsoluteTextPosition = Class.NIL

	self._TextSize = ScaleOffset.Create(0, 32)
	self._AbsoluteTextSize = Class.NIL
	
	-- TextPadding Format: (left, top, right, bottom)
    self._TextPadding = ScaleOffset4.Create(0, 0, 0, 0, 5, 5, 5, 5)
    self._AbsoluteTextPadding = Class.NIL

    self._HorizontalTextAlignment = Enum.HorizontalAlignment.Left
    self._VerticalTextAlignment = Enum.VerticalAlignment.Top

    self._TextColour = Vector4.Black

    return self
end

function Label:Draw(pass, stencil)
    Frame.Draw(self, pass, stencil)

	if not stencil and #self.DisplayedText > 0 then
		pass:setShader()

		self._Font:setPixelDensity(1)
		pass:setFont(self._Font)
		pass:setColor(self._TextColour:Unpack())	

		pass:text(
			self.DisplayedText,
			self.AbsoluteTextPosition.X, self.AbsoluteTextPosition.Y, 0,
			self.AbsoluteTextSize / self._Font:getHeight(),
			self.AbsoluteAngle,
			0, 0, 1,
			0,
			self._HorizontalTextAlignment,
			self._VerticalTextAlignment
		)
	end
end

function Label:GetText()
    return self._Text
end

function Label:SetText(text)
    if text ~= self._Text then
        self._Text = text

        return true, text
    end
end

--[[DependsOn: Font, AbsoluteSize, AbsoluteTextSize, AbsoluteTextPadding, Text]]--
function Label:GetDisplayedText()
	if self._DisplayedText == Class.NIL then
		self._Font:setPixelDensity(1)

		local maximumWidth = self.AbsoluteSize.X - self.AbsoluteTextPadding.X - self.AbsoluteTextPadding.Z
		local maximumLines = math.floor(
			(self.AbsoluteSize.Y - self.AbsoluteTextPadding.Y - self.AbsoluteTextPadding.W) / self.AbsoluteTextSize
		)

		local lines = self._Font:getLines(self._Text, maximumWidth * (self._Font:getHeight() / self.AbsoluteTextSize))

		self._DisplayedText = ""

		for lineIndex = 1, math.min(#lines, maximumLines), 1 do
			self._DisplayedText = self._DisplayedText..lines[lineIndex].."\n"
		end

		self._DisplayedText = string.sub(self._DisplayedText, 1, -2)
	end

	return self._DisplayedText
end

function Label:SetDisplayedText(text)
	if text ~= self._DisplayedText then
		self._DisplayedText = text

		return true, text
	end
end

function Label:GetFont()
    return self._Font
end

function Label:SetFont(font)
	font = font or lovr.graphics.getDefaultFont()

    if font ~= self._Font then
        self._Font = font

        return true, font
    end
end

--[[DependsOn: HorizontalTextAlignment, VerticalTextAlignment, AbsoluteTextPadding, AbsoluteSize, AbsolutePosition, AbsoluteAngle]]--
function Label:GetAbsoluteTextPosition()
	if self._AbsoluteTextPosition == Class.NIL then
		local offsetX, offsetY = 0, 0

		if self._HorizontalTextAlignment == Enum.HorizontalAlignment.Left then
			offsetX = self.AbsoluteTextPadding.X
		elseif self._HorizontalTextAlignment == Enum.HorizontalAlignment.Middle then
			offsetX = (self.AbsoluteTextPadding.X + self.AbsoluteSize.X - self.AbsoluteTextPadding.Z) * 0.5
		else
			offsetX = self.AbsoluteSize.X - self.AbsoluteTextPadding.Z
		end

		if self._VerticalTextAlignment == Enum.VerticalAlignment.Top then
			offsetY = self.AbsoluteTextPadding.Y
		elseif self._VerticalTextAlignment == Enum.VerticalAlignment.Middle then
			offsetY = (self.AbsoluteTextPadding.Y + self.AbsoluteSize.Y - self.AbsoluteTextPadding.W) * 0.5
		else
			offsetY = self.AbsoluteSize.Y - self.AbsoluteTextPadding.W
		end

		self._AbsoluteTextPosition = self.AbsolutePosition + Vector2.Create(offsetX, offsetY):Rotate(self.AbsoluteAngle)
	end

	return self._AbsoluteTextPosition
end

function Label:SetAbsoluteTextPosition(position)
	if position ~= self._AbsoluteTextPosition then
		self._AbsoluteTextPosition = position

		return true, position
	end
end

function Label:GetTextSize()
	return self._TextSize
end

function Label:SetTextSize(size)
	if size ~= self._TextSize then
		self._TextSize = size

		return true, size
	end
end

--[[DependsOn: TextSize, AbsoluteSize]]--
function Label:GetAbsoluteTextSize()
	if self._AbsoluteTextSize == Class.NIL then
		self._AbsoluteTextSize = self._TextSize.Offset + self.AbsoluteSize.Y * self._TextSize.Scale
	end

	return self._AbsoluteTextSize
end

function Label:SetAbsoluteTextSize(size)
	if size ~= self._AbsoluteTextSize then
		self._AbsoluteTextSize = size

		return true, size
	end
end

function Label:GetTextPadding()
    return self._TextPadding
end

function Label:SetTextPadding(padding)
    if padding ~= self._TextPadding then
        self._TextPadding = padding

        return true, padding
    end
end

--[[DependsOn: TextPadding, AbsoluteSize]]--
function Label:GetAbsoluteTextPadding()
    if self._AbsoluteTextPadding == Class.NIL then
        self._AbsoluteTextPadding =
			self._TextPadding.Offset +
			Vector4.Create(self.AbsoluteSize.X, self.AbsoluteSize.Y, self.AbsoluteSize.X, self.AbsoluteSize.Y) * self._TextPadding.Scale
    end

	return self._AbsoluteTextPadding
end

function Label:SetAbsoluteTextPadding(padding)
    if padding ~= self._AbsoluteTextPadding then
        self._AbsoluteTextPadding = padding

        return true, padding
    end
end

function Label:GetHorizontalTextAlignment()
    return self._HorizontalTextAlignment
end

function Label:SetHorizontalTextAlignment(alignment)
    if alignment ~= self._HorizontalTextAlignment then
        self._HorizontalTextAlignment = alignment

		return true, alignment
	end
end

function Label:GetVerticalTextAlignment()
    return self._VerticalTextAlignment
end

function Label:SetVerticalTextAlignment(alignment)
    if alignment ~= self._VerticalTextAlignment then
        self._VerticalTextAlignment = alignment

		return true, alignment
    end
end

function Label:GetTextColour()
	return self._TextColour
end

function Label:SetTextColour(colour)
	if colour ~= self._TextColour then
		self._TextColour = colour

		return true, colour
	end
end

function Label:Destroy()
    if not self._Destroyed then
    	self._Font = nil

		self._AbsoluteTextPosition = nil

		self._TextSize = nil
	
    	self._TextPadding = nil
    	self._AbsoluteTextPadding = nil

    	self._TextColour = nil

        Frame.Destroy(self)
    end
end

return Class.CreateClass(Label, "Label", Frame, scriptpath())