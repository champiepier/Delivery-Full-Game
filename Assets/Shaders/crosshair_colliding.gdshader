shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 original_color = texture(TEXTURE, UV);
    COLOR = vec4(0.0, 1.0, 1.0, original_color.a - 0.25);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
