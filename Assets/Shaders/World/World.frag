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
		return max(1.0 - distance/range, 0.0);
	} else if (fallOffType == FALL_OFF_INVERSE_LINEAR) {
		return 1.0 / (1.0 + (coefficient * distance));
	} else if (fallOffType == FALL_OFF_INVERSE_SQUARE) {
		return 1.0 / (1.0 + (coefficient * distance * distance));
	} else {
		return 1.0;
	}
}

vec3 F_SchlickRoughness(const Surface surface, float NoV) {
    return surface.f0 + (max(vec3(1.0 - surface.roughness), surface.f0) - surface.f0) * pow(1.0 - NoV, 5.0);
}

vec3 GetDirectLighting(const Surface surface, vec3 direction, vec4 color, float visibility) {
	if (visibility <= 0.0) {
		return vec3(0.0);
	}

	// Parameters
	vec3 N = surface.normal;
	vec3 V = surface.view;
	vec3 L = normalize(direction);
	vec3 H = normalize(V + L);

	float NoV = clamp(dot(N, V), 0.0, 1.0);
	float NoL = clamp(dot(N, L), 0.0, 1.0);
	float NoH = clamp(dot(N, H), 0.0, 1.0);
	float VoH = clamp(dot(V, H), 0.0, 1.0);

	// Specular
	float D = D_GGX(surface, NoH);
	float G = G_SmithGGXCorrelated(surface, NoV, NoL);
	vec3 F = F_Schlick(surface, VoH);

	vec3 specular = (D * G * F) / max(4.0 * NoV * NoL, 1e-4);

	vec3 kD = (1.0 - F) * (1.0 - surface.metalness);

	// Diffuse
	vec3 diffuse = (kD * surface.diffuse) / PI;

	return (diffuse + specular) * color.rgb * (NoL * color.a * visibility);
}

vec3 GetIndirectLighting(const Surface surface, textureCube skybox, in vec3 sphericalHarmonics[9]) {
	float NoV = clamp(dot(surface.normal, surface.view), 0.0, 1.0);

	vec3 F = F_SchlickRoughness(surface, NoV);
	vec3 irradiance = evaluateSphericalHarmonics(sphericalHarmonics, surface.normal);
	vec3 kD = (1.0 - F) * (1.0 - surface.metalness);

	vec3 diffuse = (irradiance * kD * surface.diffuse) / PI;

	vec2 brdf = prefilteredBRDF(NoV, surface.roughness);

	int mipmapCount = textureQueryLevels(samplerCube(skybox, Sampler));
	vec3 prefilteredColour = textureLod(samplerCube(skybox, Sampler), surface.reflection, surface.roughness * (mipmapCount - 1)).rgb;

	vec3 specular = prefilteredColour * (F * brdf.r + brdf.g);

	return (diffuse + specular) * surface.occlusion;
}

vec4 lovrmain() {
	Surface surface;

	surface.position = PositionWorld;
	surface.geometricNormal = normalize(Normal);

	if (ObjectMaterial.NormalScale < 0) {
		surface.normal = surface.geometricNormal;
	} else {
		vec3 normalScale = vec3(ObjectMaterial.NormalScale, ObjectMaterial.NormalScale, 1.0);
		surface.normal = normalize(TangentMatrix * normalize((getPixel(MaterialNormalTexture, UV).xyz * 2.0 - 1.0) * normalScale));
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
	
	surface.roughness = clamp(ObjectMaterial.Roughness * getPixel(MaterialRoughnessTexture, UV).g, 0.05, 1.0);
	surface.roughness2 = surface.roughness * surface.roughness;
	surface.occlusion = mix(1.0, getPixel(MaterialOcclusionTexture, UV).r, ObjectMaterial.OcclusionStrength);

	// TODO:
	surface.clearcoat = 0.0;
	surface.clearcoatRoughness = 0.0;

	vec3 colour = GetIndirectLighting(surface, Skybox, Harmonics);

	for (uint i = 0; i < LightCount; ++i) {
		Light light = Lights[i];
		if (light.Enabled != 0) {
			vec3 L = light.Position - PositionWorld;
			float lightDistance = length(L);
			L /= lightDistance;

			vec3 irradiance = light.Intensity * (step(lightDistance, light.Range) * GetFallOffFactor(
				light.FallOffType, lightDistance, light.Range, light.FallOffCoefficient
			));

			colour += GetDirectLighting(surface, L, vec4(irradiance, 1.0), 1.0);
		}
	}

	vec4 finalColour = vec4(colour + surface.emissive, surface.baseColor.a);

	return finalColour;
}