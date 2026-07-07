shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0, 0.01);

float lightness(vec3 color_rgb) {
	return max(max(color_rgb.r, color_rgb.g), color_rgb.b);
}

const float FACTOR = 19. / 64.;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	float adjusted_y = UV.y * (1. + 2. * FACTOR) - FACTOR;
	if(lightness(color.rgb) >= 0.3 && adjusted_y > progress) {
		COLOR = color;
	} else {
		COLOR = color * vec4(.8, .8, .8, 1.0);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
