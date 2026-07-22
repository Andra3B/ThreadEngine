readonly buffer SkyboxHarmonics {
	vec3 Harmonics[9];
};

vec4 lovrmain() {
    return vec4(evaluateSphericalHarmonics(Harmonics, normalize(PositionWorld)), 1.0);
}