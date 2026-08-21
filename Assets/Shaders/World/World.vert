struct _Material {
	vec4 Colour;
	
	vec4 Glow;

	float Metalness;

	float Roughness;

	float NormalScale;

	float OcclusionStrength;
};

layout(std430) readonly buffer _MaterialBuffer {
	_Material ObjectMaterial;
};

uniform uint BoneTransformCount;

layout (std430) readonly buffer BoneTransformBuffer {
	mat4 BoneTransforms[];
};

in uvec4 VertexBoneIndices;
in vec4 VertexBoneWeights;

vec4 lovrmain() {
	vec4 localPosition = vec4(VertexPosition.xyz, 1.0);

	if (BoneTransformCount > 0) {
		mat4 boneMatrix =
			BoneTransforms[VertexBoneIndices.x]*VertexBoneWeights.x + 
			BoneTransforms[VertexBoneIndices.y]*VertexBoneWeights.y +
			BoneTransforms[VertexBoneIndices.z]*VertexBoneWeights.z +
			BoneTransforms[VertexBoneIndices.w]*VertexBoneWeights.w;

		localPosition = boneMatrix * localPosition;
		Normal = normalize(cofactor3(mat4x3(boneMatrix)) * VertexNormal);
	}

	return Projection * View * Transform * localPosition;
}