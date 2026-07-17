uniform textureCube Skybox;

in vec3 Direction;

vec4 lovrmain() {
	return getPixel(Skybox, normalize(Direction));
}