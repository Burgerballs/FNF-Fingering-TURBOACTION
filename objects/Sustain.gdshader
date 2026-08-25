shader_type canvas_item;
uniform vec3 color = vec3(1.,0.,0.);
uniform bool canColor = true; 

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
uniform bool canColor = true; 
void fragment() {
	vec4 col = COLOR;
	if (canColor) {
		vec3 col3 = col.rgb;
		vec3 colHSV = rgb2hsv(col3);
		vec3 newColor = rgb2hsv(color);
		colHSV.r = newColor.r;
		colHSV.g *= newColor.g;
		colHSV.b *= newColor.b;
		col = vec4(hsv2rgb(colHSV).rgb, col.a);
	}
	COLOR = col;
}