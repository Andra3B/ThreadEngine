local Bone = {}

function Bone.Create(boneIndex)
	local self = Class.CreateInstance(WorldObject.Create(), Bone)

	self._BoneIndex = boneIndex
	self._InverseBindMatrix = Matrix4.Identity

	self._SkeletonTransform = Class.NIL

	return self
end

function Bone:GetBoneIndex()
	return self._BoneIndex
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
	if transform == Class.NIL or transform ~= self._SkeletonTransform then
		local oldTransform = self._SkeletonTransform
		self._SkeletonTransform = transform

		self._Events:TriggerAncestors("DescendantSkeletonTransformChanged", transform, oldTransform)

		return true, transform
	end
end

function Bone:Destroy()
	if not self._Destroyed then
		self._InverseBindMatrix = nil

		self._SkeletonTransform = nil

		WorldObject.Destroy(self)
	end
end

return Class.CreateClass(Bone, "Bone", WorldObject, scriptpath())