local WorldNode = {}

function WorldNode.Create()
    local self = Class.CreateInstance(WorldObject.Create(), WorldNode)
	
    self._Origin = ScaleOffset3.Zero
    self._AbsoluteOrigin = Class.NIL

    return self
end

--[[DependsOn: Position, Parent, ParentAbsolutePosition]]--
function WorldNode:GetAbsolutePosition()
    if self._AbsolutePosition == Class.NIL then
        if Class.IsA(self._Parent, "WorldObject") then
            self._AbsolutePosition = self._Parent.AbsolutePosition + self._Position
        else
            self._AbsolutePosition = self._Position
        end
    end

    return self._AbsolutePosition
end

--[[DependsOn: Orientation, Parent, ParentAbsoluteOrientation]]--
function WorldNode:GetAbsoluteOrientation()
    if self._AbsoluteOrientation == Class.NIL then
        if Class.IsA(self._Parent, "WorldObject") then
            self._AbsoluteOrientation = self._Orientation * self._Parent.AbsoluteOrientation
        else
            self._AbsoluteOrientation = self._Orientation
        end
    end

    return self._AbsoluteOrientation
end

function WorldNode:GetOrigin()
    return self._Origin
end

function WorldNode:SetOrigin(origin)
    if origin ~= self._Origin then
        self._Origin = origin

        return true, origin
    end
end

--[[DependsOn: Origin, AbsoluteSize]]--
function WorldNode:GetAbsoluteOrigin()
    if self._AbsoluteOrigin == Class.NIL then
        self._AbsoluteOrigin = self._Origin.Offset + self.AbsoluteSize * self._Origin.Scale
    end

    return self._AbsoluteOrigin
end

function WorldNode:SetAbsoluteOrigin(origin)
    if origin ~= self._AbsoluteOrigin then
        self._AbsoluteOrigin = origin

        return true, origin
    end
end

--[[DependsOn: AbsolutePosition, AbsoluteSize, AbsoluteOrientation, AbsoluteOrigin]]--
function WorldNode:GetTransform()
	if self._Transform == Class.NIL then
		self._Transform = Matrix4.CreateTransform(
            self.AbsolutePosition,
            self.AbsoluteOrientation,
            self.AbsoluteSize,
            self.AbsoluteOrigin
        )
	end

	return self._Transform
end

function WorldNode:Destroy()
    if not self._Destroyed then
		self._AbsolutePosition = nil
		self._AbsoluteSize = nil
		self._AbsoluteOrientation = nil

		self._Origin = nil
		self._AbsoluteOrigin = nil

		WorldObject.Destroy(self)
	end
end

return Class.CreateClass(WorldNode, "WorldNode", WorldObject, scriptpath())