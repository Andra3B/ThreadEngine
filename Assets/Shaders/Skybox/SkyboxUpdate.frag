uniform texture2D Skybox;
uniform uint SkyboxSamples;

uniform uint Mipmap;
uniform uint MipmapCount;

vec2 GetHammersleySample(uint i, uint N) {
	uint bits = i;

	bits = (bits << 16u) | (bits >> 16u);
	bits = ((bits & 0x55555555u) << 1u) | ((bits & 0xAAAAAAAAu) >> 1u);
	bits = ((bits & 0x33333333u) << 2u) | ((bits & 0xCCCCCCCCu) >> 2u);
	bits = ((bits & 0x0F0F0F0Fu) << 4u) | ((bits & 0xF0F0F0F0u) >> 4u);
	bits = ((bits & 0x00FF00FFu) << 8u) | ((bits & 0xFF00FF00u) >> 8u);

	return vec2(float(i)/float(N), float(bits) * 2.3283064365386963e-10);
}

vec2 DirectionToUV(vec3 direction) {
	return vec2(
		atan(direction.x, direction.z) * 0.1591549431 + 0.5,
		asin(clamp(direction.y, -1.0, 1.0)) * -0.3183098862 + 0.5
	);
}

vec4 lovrmain() {
	vec3 N = normalize(PositionWorld);

	if (Mipmap == 1) {
		return vec4(getPixel(Skybox, DirectionToUV(N)).rgb, 1.0);
	} else {
		float roughness = float(Mipmap - 1) / float(MipmapCount - 1);
		float a = roughness * roughness;
		float a2 = a * a;

		vec3 T = normalize(cross(N, N.y < 0.99 ? vec3(0.0, 1.0, 0.0) : vec3(0.0, 0.0, 1.0)));
		vec3 B = cross(T, N);

		mat3 tangentMatrix = mat3(T, N, B);

		vec3 numeratorSum = vec3(0.0);
		float denominatorSum = 0.0;

		for (uint i = 0; i < SkyboxSamples; ++i) {
			vec2 skyboxSample = GetHammersleySample(i, SkyboxSamples);
			
			float phi = TAU * skyboxSample.x;
			float cosTheta2 = (1.0 - skyboxSample.y) / (skyboxSample.y * (a2 - 1.0) + 1.0);

			float cosPhi = cos(phi);
			float sinPhi = sin(phi);

			float k = 2.0 * sqrt(max(0.0, cosTheta2 * (1.0 - cosTheta2)));

			// Go from angles to Lt in one step.
			vec3 Lt = vec3(k * cosPhi, 2.0 * cosTheta2 - 1.0, k * sinPhi);

			vec3 skyboxRadiance = getPixel(Skybox, DirectionToUV(normalize(tangentMatrix * Lt))).rgb;

			float karisWeight = 1.0 / (skyboxRadiance.r * 0.2126 + skyboxRadiance.g * 0.7152 + skyboxRadiance.b * 0.0722 + 1.0);
			float weight = max(0.0, Lt.y) * karisWeight;

			numeratorSum += skyboxRadiance * weight;
			denominatorSum += weight;
		}

		return vec4(numeratorSum / denominatorSum, 1.0);
	}
}