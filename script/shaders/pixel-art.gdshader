shader_type canvas_item;
render_mode unshaded;
 
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

uniform vec2 target_resolution = vec2(960.0, 540.0);
uniform int range_per_color = 12;

void fragment() {
    // Pixelation
    vec2 pixel_uv = floor(SCREEN_UV * target_resolution) / target_resolution;

    // Sample pixelated screen
    vec3 color = texture(screen_texture, pixel_uv).rgb;

    // Color quantization
    float r = round(color.r * float(range_per_color)) / float(range_per_color);
    float g = round(color.g * float(range_per_color)) / float(range_per_color);
    float b = round(color.b * float(range_per_color)) / float(range_per_color);

    COLOR = vec4(r, g, b, 1.0);
}
