shader_type canvas_item;

uniform float scroll_speed: hint_range(0, 2) = 0.05;
uniform float angle_degrees: hint_range(0, 360, 1) = 45.0;
uniform float repeat_x: hint_range(1, 20, 1) = 1;
uniform float repeat_y: hint_range(1, 20, 1) = 1;
uniform float spacing: hint_range(0, 1) = 0.1; // New uniform for spacing
uniform vec4 tint: source_color = vec4(1.0);
uniform sampler2D texture_to_scroll;

void fragment() {
    float angle_rad = radians(angle_degrees);
    vec2 direction = vec2(cos(angle_rad), sin(angle_rad));
    vec2 offset_uv = UV - (TIME * scroll_speed * direction);
    
    // Calculate scaled UVs with spacing
    vec2 scaled_uv = vec2(fract(offset_uv.x * repeat_x), fract(offset_uv.y * repeat_y));
    
    // Adjust UVs to create spacing without cropping
    scaled_uv = scaled_uv * (1.0 + spacing) - (spacing * 0.5); // Scale and center the UVs
    
    vec2 texel_size = vec2(1.0) / vec2(textureSize(texture_to_scroll, 0));
    vec2 snapped_uv = round(scaled_uv / texel_size) * texel_size;
    
    COLOR = texture(texture_to_scroll, snapped_uv) * tint;
}
