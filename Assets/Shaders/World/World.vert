struct _Material {
	vec4 Colour;
	
	vec4 Glow;

	float Metalness;

	float Roughness;

	float NormalScale;

	float OcclusionStrength;

	vec2 UVShift;
	vec2 UVScale;

	float AlphaCutoff;
};

layout(std430) readonly buffer _MaterialBuffer {
	_Material ObjectMaterial;
};

uniform uint BoneTransformCount;

layout (std430) readonly buffer BoneTransformBuffer {
	mat4 BoneTransforms[];
};

in uvec4 VertexBoneIDs;
in vec4 VertexBoneWeights;

vec4 lovrmain() {
	UV *= ObjectMaterial.UVScale;
	UV += ObjectMaterial.UVShift;

	vec4 localPosition = vec4(VertexPosition.xyz, 1.0);

	if (BoneTransformCount > 0) {
		mat4 boneMatrix =
			BoneTransforms[VertexBoneIDs.x]*VertexBoneWeights.x + 
			BoneTransforms[VertexBoneIDs.y]*VertexBoneWeights.y +
			BoneTransforms[VertexBoneIDs.z]*VertexBoneWeights.z +
			BoneTransforms[VertexBoneIDs.w]*VertexBoneWeights.w;

		localPosition = boneMatrix * localPosition;
		Normal = normalize(cofactor3(mat4x3(boneMatrix)) * VertexNormal);
	}

	return Projection * View * Transform * localPosition;
}