#define FALL_OFF_NONE 0
#define FALL_OFF_LINEAR 1
#define FALL_OFF_INVERSE_LINEAR 2
#define FALL_OFF_INVERSE_SQUARE 3

#define POINT_LIGHT 0
#define SPOT_LIGHT 1
#define DIRECTIONAL_LIGHT 2

layout(constant_id = 0) const int flag_MaximumLights = 32;

uniform int LightCount;

uniform Lights {
	vec4 Position[flag_MaximumLights];	// Position, Enabled
	vec4 Direction[flag_MaximumLights];	// Direction, Radius
	vec4 Intensity[flag_MaximumLights];	// Intensity, 0
	vec4 FallOff[flag_MaximumLights];	// Type, FallOffType, FallOffCoefficient, Range
} Light;

float GetFallOffFactor(int fallOffType, float distance, float range, float coefficient) {
	if (fallOffType == FALL_OFF_LINEAR) {
		return 1.0 - distance/range;
	} else if (fallOffType == FALL_OFF_INVERSE_LINEAR) {
		return 1.0 / (1.0 + (coefficient * distance));
	} else if (fallOffType == FALL_OFF_INVERSE_SQUARE) {
		return 1.0 / (1.0 + (coefficient * distance * distance));
	} else {
		return 1.0;
	}
}

vec4 lovrmain() {
	vec3 colour = vec3(0);

	Surface surface = getDefaultSurface();

	for (int lightIndex = 0; lightIndex < LightCount; lightIndex++) {
		if (int(Light.Position[lightIndex].w) == 1) {
			vec3 lightPosition = Light.Position[lightIndex].xyz;
			vec3 lightIntensity = Light.Intensity[lightIndex].rgb;
			vec4 lightFallOff = Light.FallOff[lightIndex];

			vec3 L = lightPosition - PositionWorld;
			float lightDistance = length(L);

			vec3 irradiance = lightIntensity * (step(-lightFallOff.w, -lightDistance) * GetFallOffFactor(
				int(lightFallOff.y), lightDistance, lightFallOff.w, lightFallOff.z
			));

			colour += getLighting(surface, -L, vec4(irradiance, 1.0), 1.0);
		}
	}

	return vec4(colour, 1.0);
}