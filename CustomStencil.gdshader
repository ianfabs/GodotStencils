shader_type canvas_item;

varying vec4 vColor;
uniform vec4 color: hint_color = vec4(0.0,0.0,1.0,1.0);

void fragment() {
	vec4 ncolor = texture(NORMAL_TEXTURE, vec2(UV.x, UV.y));
	COLOR = color + texture(TEXTURE, vec2(UV.x, UV.y));
//	if (COLOR.rgb == color.rgb) {
	if (COLOR.rgb == vec3(0,0,0)) {
		discard;
	} else {
		COLOR.rgb = color.rgb;
	}
	
}

//void vertex() {
//	if (COLOR.rgb == vec3(0,0,0)) {
//		discard;
//	}
//}