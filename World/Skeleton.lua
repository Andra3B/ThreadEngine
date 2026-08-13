local Skeleton = {}

local function OnDescendantParentChanged(skeleton, descendant)
	if descendant:IsA("Bone") and descendant:GetAncestorWithType("Skeleton") == skeleton then
		descendant.InverseBindMatrix = descendant.InverseSkeletonTransform

		for _descendant in descendant:IterateDescendants() do
			OnDescendantParentChanged(skeleton, _descendant)
		end
	end
end

local function OnDescendantSkeletonTransformChanged(skeleton, descendant)
	skeleton._Dirty = true
end

function Skeleton.Create()
	local self = Class.CreateInstance(WorldObject.Create(), Skeleton)

	self._Dirty = true

	self._BoneTransformBuffer = lovr.graphics.newBuffer("mat4", 256)
	self._BoneTransformCount = 0

	self._DescendantParentChangedListener = self._Events:Listen("DescendantParentChanged", OnDescendantParentChanged)
	self._DescendantSkeletonTransformChanged = self._Events:Listen("DescendantSkeletonTransformChanged", OnDescendantSkeletonTransformChanged)

	return self
end

function Skeleton:GetBoneTransformBuffer()
	return self._BoneTransformBuffer
end

function Skeleton:GetBoneTransformCount()
	return self._BoneTransformCount
end

function Skeleton:Upload()
	if self._Dirty then
		local boneTransforms = {}
		
		for descendant in self:IterateDescendants() do
			if descendant:IsA("Bone") then
				boneTransforms[descendant.BoneID] = (descendant.SkeletonTransform * descendant.InverseBindMatrix).Components
			end
		end

		self._BoneTransformBuffer:setData(boneTransforms)
		self._BoneTransformCount = #boneTransforms

		self._Dirty = false
	end
end

function Skeleton:SendToPass(pass)
	self:Upload()

	pass:send("BoneTransformCount", self._BoneTransformCount)
	pass:send("BoneTransformBuffer", self._BoneTransformBuffer)
end

function Skeleton:Destroy()
	if not self._Destroyed then
		self._BoneTransformBuffer:release()
		self._BoneTransformBuffer = nil

		self._DescendantParentChangedListener:Destroy()
		self._DescendantParentChangedListener = nil

		self._DescendantSkeletonTransformChanged:Destroy()
		self._DescendantSkeletonTransformChanged = nil

		WorldObject.Destroy(self)
	end
end

return Class.CreateClass(Skeleton, "Skeleton", WorldObject)