uniform vec2 Size;
uniform float BorderSize;

vec4 lovrmain() {
	vec2 position = VertexPosition.xy;
	vec2 normal = 2.0 * position - 1.0;

	return Projection * Transform * vec4((position * Size) + (BorderSize * normal), 0.0, 1.0);
}