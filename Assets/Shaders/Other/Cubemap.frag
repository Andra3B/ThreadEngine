uniform textureCube Cubemap;
uniform float LOD;

vec4 lovrmain() {
	return vec4(textureLod(samplerCube(Cubemap, Sampler), normalize(PositionWorld), LOD).rgb, 1.0);
}