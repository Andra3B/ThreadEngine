vec4 lovrmain() {
	vec4 projectedPosition = Projection * View * vec4(VertexPosition.xyz, 0.0);
	return vec4(projectedPosition.xy, 0.0, projectedPosition.w);
}