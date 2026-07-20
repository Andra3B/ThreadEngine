uniform texture2D Skybox;

const vec2 inverseAtan = vec2(0.1591549431, -0.3183098862); // (1 / (2 * PI), -1 / PI)

vec4 lovrmain() {
	vec3 direction = normalize(PositionWorld);
	vec2 skyboxUV = vec2(atan(direction.x, direction.z), asin(direction.y)) * inverseAtan + 0.5;

	return vec4(getPixel(Skybox, skyboxUV).rgb, 1.0);
}