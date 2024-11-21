shader_type canvas_item;

uniform sampler2D u_dither_tex : repeat_enable;

uniform float u_contrast;
uniform float u_offset;
uniform int u_dither_size;

void fragment()
{
    // Получаем размер экрана и масштабируем UV для пикселизации
    vec2 screen_size = vec2(textureSize(TEXTURE, 0)) / float(u_dither_size);
    vec2 screen_sample_uv = floor(UV * screen_size) / screen_size;
    vec3 screen_col = texture(TEXTURE, screen_sample_uv).rgb;

    // Рассчитываем яркость пикселя
    float lum = (screen_col.r * 0.299) + (screen_col.g * 0.587) + (screen_col.b * 0.114);

    // Применяем контраст и смещение
    lum = (lum - 0.5 + u_offset) * u_contrast + 0.5;
    lum = clamp(lum, 0.0, 1.0);

    // Применяем карту диффузии
    ivec2 noise_size = textureSize(u_dither_tex, 0);
    vec2 inv_noise_size = vec2(1.0 / float(noise_size.x), 1.0 / float(noise_size.y));
    vec2 noise_uv = UV * inv_noise_size * vec2(float(screen_size.x), float(screen_size.y));
    float threshold = texture(u_dither_tex, noise_uv).r;

    // Корректируем threshold, чтобы избежать граничных артефактов
    threshold = threshold * 0.99 + 0.005;

    // Если яркость ниже порога, цвет чёрный. Иначе проверяем на красный или белый.
    vec3 final_col;
    if (lum < threshold) {
        final_col = vec3(0.0); // Чёрный
    } else if (screen_col.r > screen_col.g && screen_col.r > screen_col.b) {
        final_col = vec3(1.0, 0.0, 0.0); // Красный
    } else {
        final_col = vec3(1.0); // Белый
    }

    // Возвращаем итоговый цвет
    COLOR.rgb = final_col;
}
