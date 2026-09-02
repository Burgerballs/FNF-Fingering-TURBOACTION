shader_type canvas_item;

uniform vec2 position = vec2(0.0,0.0);
uniform vec4 pointsTop = vec4(0.0,0.0,0.0,0.0);
uniform vec4 pointsBottom = vec4(0.0,0.0,0.0,0.0);
uniform vec2 scale = vec2(1.,1.);
uniform float rot = 0.0;
//https://gist.github.com/ayamflow/c06bc0c8a64f985dd431bd0ac5b557cd
vec2 rotateUV(vec2 uv, float rotation, vec2 mid)
{
    float cosAngle = cos(rotation);
    float sinAngle = sin(rotation);
    return vec2(
        cosAngle * (uv.x - mid.x) + sinAngle * (uv.y - mid.x) + mid.x,
        cosAngle * (uv.y - mid.y) - sinAngle * (uv.x - mid.y) + mid.y
    );
}

void vertex() {
	vec2 center = vec2(80.,80.);
	if (VERTEX_ID == 0) {
		VERTEX += pointsTop.rg;
	} else if (VERTEX_ID == 2) {
		VERTEX += pointsTop.ba;
	}
	if (VERTEX_ID == 1) {
		VERTEX += pointsBottom.rg;
	} else if (VERTEX_ID == 3) {
		VERTEX += pointsBottom.ba;
	}
	float convertRot = mod((rot * 6.3) / 359., 6.3);
	VERTEX = rotateUV(VERTEX,convertRot,vec2(0.,0.));
	VERTEX.x = (VERTEX.x * scale.x);
	VERTEX.y = (VERTEX.y * scale.y);
	VERTEX += position;
}
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
uniform vec3 color = vec3(1.,0.,0.);
uniform bool canColor = false; 
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

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
