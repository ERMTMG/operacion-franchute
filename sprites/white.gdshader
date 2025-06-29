shader_type canvas_item;
uniform bool enabled = false;
uniform bool fx_on = true;
void fragment() {
	vec4 currentcolor = texture(TEXTURE, UV);
	if (enabled && fx_on) {
		COLOR = vec4(currentcolor.b+0.8, currentcolor.r+0.8, currentcolor.g+0.8, currentcolor.a);
		}
}
