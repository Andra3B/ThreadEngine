local Bone = {}

function Bone.Create(boneID)
	local self = Class.CreateInstance(WorldObject.Create(), Bone)

	self._BoneID = boneID
	self._InverseBindMatrix = nil

	self._SkeletonTransform = Class.NIL
	self._InverseSkeletonTransform = Class.NIL

	return self
end

function Bone:SetParent(parent)
	local set, setValue = WorldObject.SetParent(self, parent)

	if set then
		local skeleton = self:GetAncestorWithType("Skeleton")

		self.InverseBindMatrix = skeleton and (skeleton.InverseTransform * self.Transform) or nil
	end

	return set, setValue
end

function Bone:GetBoneID()
	return self._BoneID
end

function Bone:GetInverseBindMatrix()	
	return self._InverseBindMatrix
end

function Bone:SetInverseBindMatrix(matrix)
	if matrix ~= self._InverseBindMatrix then
		self._InverseBindMatrix = matrix

		return true, matrix
	end
end

--[[DependsOn: Transform]]--
function Bone:GetSkeletonTransform()
	if self._SkeletonTransform == Class.NIL then
		local skeleton = self:GetAncestorWithType("Skeleton")

		if skeleton then
			self._SkeletonTransform = skeleton.InverseTransform * self.Transform
		else
			self._SkeletonTransform = nil
		end
	end

	return self._SkeletonTransform
end

function Bone:SetSkeletonTransform(transform)
	if transform ~= self._SkeletonTransform then
		self._SkeletonTransform = transform

		return true, transform
	end
end

--[[DependsOn: SkeletonTransform]]--
function Bone:GetInverseSkeletonTransform()
	if self._InverseSkeletonTransform == Class.NIL then
		self._InverseSkeletonTransform = self.SkeletonTransform:Inverse()
	end

	return self._InverseSkeletonTransform
end

function Bone:SetInverseSkeletonTransform(transform)
	if transform ~= self._InverseSkeletonTransform then
		self._InverseSkeletonTransform = transform

		return true, transform
	end
end

function Bone:Destroy()
	if not self._Destroyed then
		self._InverseBindMatrix = nil

		self._SkeletonTransform = nil
		self._InverseSkeletonTransform = nil

		WorldObject.Destroy(self)
	end
end

return Class.CreateClass(Bone, "Bone", WorldObject, scriptpath())