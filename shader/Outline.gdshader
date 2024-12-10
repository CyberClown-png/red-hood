shader_type spatial;
render_mode unshaded,depth_draw_always ;

/*
	Normal/Depth outline shader. Apply to nodes as a next pass shader texture.
	Inspired by Yui Kinomoto @arlez80, lukky_nl (YT), Robin Seibold (YT)
	Uses Sobel Edge detection on a normal and depth texture
	Written by William Li (LoudFlameLava)

	MIT License
*/

// Might create an outline at the edge of the viewport

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;

uniform float normal_threshold = 0.1;
uniform float depth_threshold = 0.05;
uniform float depth_artifact_correction_coef = 2;
uniform vec3 outline_color: source_color;

const mat3 sobel_y = mat3(
	vec3(1.0, 0.0, -1.0),
	vec3(2.0, 0.0, -2.0),
	vec3(1.0, 0.0, -1.0)
);

const mat3 sobel_x = mat3(
	vec3(1.0, 2.0, 1.0),
	vec3(0.0, 0.0, 0.0),
	vec3(-1.0, -2.0, -1.0)
);

float edge_value_normal(sampler2D normal_tex, vec2 uv, vec2 pixel_size, mat3 sobel) {
    float output = 0.0;
    vec3 normal = texture(normal_tex, uv).rgb;

    for (int y = -2; y <= 2; y++) {
        for (int x = -2; x <= 2; x++) {
            if (x == 0 && y == 0) continue;
            vec3 neighbor = texture(normal_tex, uv + vec2(float(x), float(y)) * pixel_size).rgb;
            float distance_factor = 1.0 / (abs(float(x)) + abs(float(y)));
            output += length(normal - neighbor) * distance_factor;
        }
    }

    return output;
}

float get_depth(sampler2D depth_tex, vec2 uv, mat4 inv_projection_matrix) {
	float depth_raw = texture(depth_tex, uv).x;
	vec3 ndc = vec3(uv * 2.0 - 1.0, depth_raw);
	vec4 view = inv_projection_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float depth_linear = -view.z;
	return depth_linear;
}

float edge_value_depth(sampler2D depth_tex, vec2 uv, vec2 pixel_size, mat3 sobel, mat4 inv_projection_matrix){
    float output = 0.0;
    float depth = get_depth(depth_tex, uv, inv_projection_matrix);

    for (int y = -2; y <= 2; y++) {
        for (int x = -2; x <= 2; x++) {
            if (x == 0 && y == 0) continue;
            float neighbor_depth = get_depth(depth_tex, uv + vec2(float(x), float(y)) * pixel_size, inv_projection_matrix);
            float distance_factor = 1.0 / (abs(float(x)) + abs(float(y))); // Ослабление с расстоянием
            output += abs(depth - neighbor_depth) / depth * distance_factor;
        }
    }

    return output;
}



void fragment() {
	float has_outline = 0.0;
	vec2 pixel_size = vec2(1.0) / VIEWPORT_SIZE;
	ALBEDO = texture(SCREEN_TEXTURE, SCREEN_UV).xyz;
	//ALBEDO = vec3(get_depth(DEPTH_TEXTURE, SCREEN_UV, INV_PROJECTION_MATRIX));
	if (edge_value_normal(NORMAL_TEXTURE, SCREEN_UV, pixel_size, sobel_x) + edge_value_normal(NORMAL_TEXTURE, SCREEN_UV, pixel_size, sobel_y) > normal_threshold){
		ALBEDO = outline_color;
		has_outline += 1.0;
	}
	vec3 normal = texture(NORMAL_TEXTURE, SCREEN_UV).rgb;
	float angle = 1.0 - dot(normalize(normal-vec3(0.5)),  vec3(0.0,0.0,1.0));
	if (edge_value_depth(DEPTH_TEXTURE, SCREEN_UV, pixel_size, sobel_x, INV_PROJECTION_MATRIX) + edge_value_depth(DEPTH_TEXTURE, SCREEN_UV, pixel_size, sobel_y, INV_PROJECTION_MATRIX) > depth_threshold + angle * depth_artifact_correction_coef){
		ALBEDO = outline_color;
		has_outline += 1.0;
	}
	if (has_outline < 0.1){
		ALPHA = 0.0;
	}
}