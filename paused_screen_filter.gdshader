shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform bool enabled;
uniform float effectLevel : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float scanlineBrightness : hint_range(0.0, 1.0, 0.01) = 0.4;

void fragment() {
	vec4 screenColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 fullEffectColor;
	if(enabled){
		float brightness = screenColor.r / 3.0 + screenColor.g / 3.0 + screenColor.b / 3.0;
		fullEffectColor = vec4(brightness, brightness, brightness, screenColor.a);
		float scanline = scanlineBrightness + (1.0-scanlineBrightness)*
			abs(sin(200.0*SCREEN_UV.y + 150.0*SCREEN_UV.x + 2.0*TIME));
		fullEffectColor *= vec4(0.3,0.8*scanline,scanline,1);
		COLOR = effectLevel*fullEffectColor + (1.0 - effectLevel)*screenColor;
	} else {
		COLOR = screenColor;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
