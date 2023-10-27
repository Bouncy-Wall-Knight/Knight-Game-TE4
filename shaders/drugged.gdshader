shader_type canvas_item;

uniform sampler2D noise: repeat_enable;

void fragment() {	
	vec4 textureColor = texture(TEXTURE, UV + vec2(0.1,0.1) * TIME);
	COLOR = textureColor;
	// Place fragment code here.
}
