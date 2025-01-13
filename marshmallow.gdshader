shader_type canvas_item;

uniform sampler2D dissolve_texture : source_color;
uniform float dissolve_value : hint_range(0, 1);
uniform vec4 color_uncooked : source_color;
uniform vec4 color_cooked : source_color;

void fragment() {
	vec4 main_texture = texture(TEXTURE, UV);
	vec4 noise_texture = texture(dissolve_texture, UV);
	main_texture *= color_cooked;
	main_texture.a *= floor(dissolve_value + noise_texture.r);
	COLOR = main_texture;
}
