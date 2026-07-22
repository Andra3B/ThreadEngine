#define FALL_OFF_NONE 0
#define FALL_OFF_LINEAR 1
#define FALL_OFF_INVERSE_LINEAR 2
#define FALL_OFF_INVERSE_SQUARE 3

#define POINT_LIGHT 0
#define SPOT_LIGHT 1
#define DIRECTIONAL_LIGHT 2

struct Light {
	uint Enabled;
	uint Type;

	uint FallOffType;
	float FallOffCoefficient;
	float Radius;
	float Range;

	vec3 Intensity;

	vec3 Position;
	vec3 Direction;
};

struct _Material {
	vec4 Colour;
	
	vec4 Glow;

	float Metalness;

	float Roughness;

	float NormalScale;

	float OcclusionStrength;

	vec2 UVShift;
	vec2 UVScale;

	float AlphaCutoff;
};

uniform textureCube Skybox;

layout(std430) readonly buffer SkyboxHarmonics {
	vec3 Harmonics[9];
};

uniform uint LightCount;

layout (std430) readonly buffer LightBuffer {
	Light Lights[];
};

layout(std430) readonly buffer _MaterialBuffer {
	_Material ObjectMaterial;
};

uniform texture2D MaterialColourTexture;
uniform texture2D MaterialGlowTexture;
uniform texture2D MaterialMetalnessTexture;
uniform texture2D MaterialRoughnessTexture;
uniform texture2D MaterialOcclusionTexture;
uniform texture2D MaterialNormalTexture;

float GetFallOffFactor(uint fallOffType, float distance, float range, float coefficient) {
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
	Surface surface;

	surface.position = PositionWorld;
	surface.geometricNormal = normalize(Normal);

	if (ObjectMaterial.NormalScale < 0) {
		surface.normal = surface.geometricNormal;
	} else {
		vec3 normalScale = vec3(ObjectMaterial.NormalScale, ObjectMaterial.NormalScale, 1.0);
		surface.normal = TangentMatrix * normalize((getPixel(MaterialNormalTexture, UV).xyz * 2.0 - 1.0) * normalScale);
	}

	if (!FrontFacing) {
		surface.geometricNormal = -surface.geometricNormal;
		surface.normal = - surface.normal;
	}

	surface.view = normalize(CameraPositionWorld - PositionWorld);
	surface.reflection = reflect(-surface.view, surface.normal);

	surface.baseColor = Color * ObjectMaterial.Colour * getPixel(MaterialColourTexture, UV);
	surface.metalness = ObjectMaterial.Metalness * getPixel(MaterialMetalnessTexture, UV).b;

	surface.f0 = mix(vec3(0.04), surface.baseColor.rgb, surface.metalness);
  	surface.diffuse = mix(surface.baseColor.rgb, vec3(0.0), surface.metalness);

	vec4 glowSample = getPixel(MaterialGlowTexture, UV);
	surface.emissive = ObjectMaterial.Glow.rgb * ObjectMaterial.Glow.a * glowSample.rgb * glowSample.a;
	
	surface.roughness = max(ObjectMaterial.Roughness * getPixel(MaterialRoughnessTexture, UV).g, 0.05);
	surface.roughness2 = surface.roughness * surface.roughness;
	surface.occlusion = getPixel(MaterialOcclusionTexture, UV).r * ObjectMaterial.OcclusionStrength;

	// TODO:
	surface.clearcoat = 0.0;
	surface.clearcoatRoughness = 0.0;

	vec3 colour = getIndirectLighting(surface, Skybox, Harmonics);

	for (uint i = 0; i < LightCount; ++i) {
		Light light = Lights[i];
		if (light.Enabled != 0) {
			vec3 L = light.Position - PositionWorld;
			float lightDistance = length(L);

			vec3 irradiance = light.Intensity * (step(-light.Range, -lightDistance) * GetFallOffFactor(
				light.FallOffType, lightDistance, light.Range, light.FallOffCoefficient
			));

			colour += getLighting(surface, -L, vec4(irradiance, 1.0), 1.0);
		}
	}

	vec4 finalColour = vec4(colour, surface.baseColor.a);
	
	if (finalColour.a <= ObjectMaterial.AlphaCutoff) {
		discard;
	}

	return finalColour;
}