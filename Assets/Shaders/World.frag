vec4 lovrmain() {
	vec3 colour = vec3(0);

	Surface surface = getDefaultSurface();

	colour += getLighting(surface, PositionWorld - vec3(1, 1, 1), vec4(1, 1, 1, 1), 1.0);

	return vec4(colour, 1.0);
}