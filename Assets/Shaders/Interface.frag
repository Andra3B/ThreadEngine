uniform mat4 InverseInterfaceTransform;

uniform vec2 Size;
uniform vec4 CornerRadius;
uniform float BorderSize;
uniform vec4 BorderColour;
uniform vec4 BackgroundColour;

float RoundedRectangleSDF(vec2 position, vec2 halfSize, vec4 cornerRadius) {
	position = position - halfSize;

	cornerRadius.xy = (position.x > 0.0) ? cornerRadius.zy : cornerRadius.wx;
	cornerRadius.x = (position.y > 0.0) ? cornerRadius.x : cornerRadius.y;

	vec2 q = abs(position) - halfSize + cornerRadius.x;

	return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - cornerRadius.x;
}

vec4 lovrmain() {
	vec4 colour = BackgroundColour;

	if (BorderSize > 0.0 || dot(CornerRadius, CornerRadius) > 0.0) {
		float distance = RoundedRectangleSDF((InverseInterfaceTransform * vec4(FragCoord.xy, 0.0, 1.0)).xy, Size * 0.5, CornerRadius);

		colour = mix(colour, BorderColour, step(0.0, distance)) * (1.0 - step(BorderSize, distance));
	}

	return colour;
}