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

vec4 lovrmain() {
	UV *= ObjectMaterial.UVScale;
	UV += ObjectMaterial.UVShift;

	return Projection * View * Transform * VertexPosition;
}