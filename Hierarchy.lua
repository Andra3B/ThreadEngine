local Hierarchy = {}

local function NewIndexMetamethod(self, name, value)
	local setter = self.Class["Set"..name]

	if setter then
		local oldValue = self["_"..name]
		local set, setValue = setter(self, value)
		
		if set or value == Class.NOT_SET then
			local dependents = self.Class.PROPERTY_DEPENDENCIES[name]
			
			if dependents then
				for _, dependency in pairs(dependents) do
					self[dependency] = Class.NOT_SET
				end
			end

			if not self.Destroyed then
				self.Events:Trigger(name.."Changed", setValue, oldValue) 

				if self.Parent then
					self.Parent.Events:Trigger("Child"..name.."Changed", setValue, oldValue)
				end

				self.Events:TriggerChildren("Parent"..name.."Changed", self, setValue, oldValue)
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

function Hierarchy:Clone(clone)
	clone = Object.Clone(self, clone or Hierarchy.Create())

	for _, child in ipairs(self.Children) do
		if child.Clone then
			child:Clone().Parent = clone
		end
	end

	return clone
end

function Hierarchy:GetParent()
	return self._Parent
end

local function AncestorIterator(parent)
	while parent do
		coroutine.yield(parent)

		parent = parent.Parent
	end
end

function Hierarchy:IterateAncestors()
	return coroutine.wrap(AncestorIterator), self.Parent, nil
end

function Hierarchy:GetAncestorWithName(name)
	for ancestor in self:IterateAncestors() do
		if ancestor.Name == name then
			return ancestor
		end
	end
end

function Hierarchy:GetAncestorWithType(ancestorType)
	for ancestor in self:IterateAncestors() do
		if Class.IsA(ancestor, ancestorType) then
			return ancestor
		end
	end
end

function Hierarchy:SetParent(parent, where)
	local oldParent = self._Parent

	if parent ~= oldParent then
		if oldParent then
			for index, currentChild in pairs(oldParent.Children) do
				if currentChild == self then
					table.remove(oldParent.Children, index)
					
					break
				end
			end

			self._Parent = nil
			oldParent.Events:Trigger("ChildRemoved", self)
		end

		if parent then
			table.insert(parent.Children, math.clamp(where or (#parent.Children + 1), 1, #parent.Children + 1), self)

			self._Parent = parent
			parent.Events:Trigger("ChildAdded", self)
		end

		self.Events:Trigger("AncestorChanged", parent, oldParent)

		for descendant in self:IterateDescendants() do
			descendant.Events:Trigger("AncestorChanged", parent, oldParent)
		end

		return true, parent
	end
end

function Hierarchy:GetChildren()
	return self._Children
end

function Hierarchy:GetChildWithName(name)
	for _, child in ipairs(self.Children) do
		if child.Name == name then
			return child
		end
	end
end

function Hierarchy:GetChildWithType(childType)
	for _, child in ipairs(self.Children) do
		if Class.IsA(child, childType) then
			return child
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
	for descendant in self:IterateDescendants() do
		if descendant.Name == name then
			return descendant
		end
	end
end

function Hierarchy:GetDescendantWithType(descendantType)
	for descendant in self:IterateDescendants() do
		if Class.IsA(descendant, descendantType) then
			return descendant
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
	while #self.Children > 0 do
		local child = self.Children[1]

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

return Class.CreateClass(Hierarchy, "Hierarchy", Object, nil, NewIndexMetamethod)