local Hierarchy = {}

local function NewIndexMetamethod(self, name, value)
	local setter = self.Class["Set"..name]

	if setter then
		local oldValue = self["_"..name]
		local set, setValue = setter(self, value)
		
		if set or value == Class.NIL then
			local selfDependents = self.Class.DEPENDENCIES.Self[name] or table.empty

			for _, dependency in ipairs(selfDependents) do
				self[dependency] = Class.NIL
			end

			if self._Parent then
				local parentDependents = self._Parent.Class.DEPENDENCIES.Children[name] or table.empty

				for _, dependency in ipairs(parentDependents) do
					self._Parent[dependency] = Class.NIL
				end
			end

			for _, child in ipairs(self._Children) do
				local childDependents = child.Class.DEPENDENCIES.Parent[name] or table.empty

				for _, dependency in ipairs(childDependents) do
					child[dependency] = Class.NIL
				end
			end
		end
	else
		rawset(self, name, value)
	end
end

function Hierarchy.Create()
	local self = Class.CreateInstance(Object.Create(), Hierarchy)
	
	self._Parent = nil
	self._Children = {}

	return self
end

function Hierarchy:GetParent()
	return self._Parent
end

local function AncestorIterator(_, parent)
	return parent and parent._Parent
end

function Hierarchy:IterateAncestors()
	return AncestorIterator, nil, self
end

function Hierarchy:GetAncestorWithName(name)
	if type(name) == "string" then
		for ancestor in self:IterateAncestors() do
			if ancestor.Name == name then
				return ancestor
			end
		end
	end
end

function Hierarchy:GetAncestorWithType(ancestorType)
	if type(ancestorType) == "string" then
		for ancestor in self:IterateAncestors() do
			if Class.IsA(ancestor, ancestorType) then
				return ancestor
			end
		end
	end
end

function Hierarchy:SetParent(parent, where)
	local oldParent = self._Parent

	if parent ~= oldParent then
		if parent == self then
			return false
		else
			if oldParent then
				for index, currentChild in pairs(oldParent.Children) do
					if currentChild == self then
						table.remove(oldParent.Children, index)
						
						break
					end
				end

				self._Parent = nil
			end

			if parent then
				table.insert(parent.Children, math.clamp(where or (#parent.Children + 1), 1, #parent.Children + 1), self)

				self._Parent = parent
			end

			self._Events:TriggerAncestors("DescendantParentChanged", parent, oldParent)

			return true, parent
		end
	end
end

function Hierarchy:GetChildren()
	return self._Children
end

function Hierarchy:GetChildWithName(name)
	if type(name) == "string" then
		for _, child in ipairs(self.Children) do
			if child.Name == name then
				return child
			end
		end
	end
end

function Hierarchy:GetChildWithType(childType)
	if type(childType) == "string" then
		for _, child in ipairs(self.Children) do
			if Class.IsA(child, childType) then
				return child
			end
		end
	end
end

local function DescendantIterator(object)
	for _, child in ipairs(object.Children) do
		coroutine.yield(child)
	end

	for _, child in ipairs(object.Children) do
		DescendantIterator(child)
	end
end

function Hierarchy:IterateDescendants()
	return coroutine.wrap(DescendantIterator), self, nil
end

function Hierarchy:GetDescendantWithName(name)
	if type(name) == "string" then
		for descendant in self:IterateDescendants() do
			if descendant.Name == name then
				return descendant
			end
		end
	end
end

function Hierarchy:GetDescendantWithType(descendantType)
	if type(descendantType) == "string" then
		for descendant in self:IterateDescendants() do
			if Class.IsA(descendant, descendantType) then
				return descendant
			end
		end
	end
end

function Hierarchy:IsDescendantOf(ancestor)
	for _ancestor in self:IterateAncestors() do
		if _ancestor == ancestor then
			return true
		end
	end

	return false
end

function Hierarchy:DestroyChildren()
	while #self._Children > 0 do
		local child = table.remove(self._Children)

		child.Parent = nil
		child:Destroy()
	end
end

function Hierarchy:Destroy()
	if not self._Destroyed then
		self:DestroyChildren()

		self._Parent = nil
		
		Object.Destroy(self)
	end
end

return Class.CreateClass(Hierarchy, "Hierarchy", Object, nil, nil, NewIndexMetamethod)