uniform mat4 WorldTransform;

vec4 lovrmain() {
	return Projection * View * WorldTransform * vec4(VertexPosition.xyz, 1.0);
}