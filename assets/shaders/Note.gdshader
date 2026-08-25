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

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
