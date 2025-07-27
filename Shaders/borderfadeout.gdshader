shader_type canvas_item;

uniform float divide = 0.065;      
uniform float blur = 0.385;        
uniform float fade_width = 0.995;  

void fragment() {
    // 左右渐隐边缘
    float left_fade_edge = fade_width;
    float right_fade_edge = 1.0 - fade_width;
    
    // 上下渐隐边缘
    float bottom_fade_edge = fade_width;
    float top_fade_edge = 1.0 - fade_width;

    // 初始化透明度因子
    float leftFade = 1.0;
    float rightFade = 1.0;
    float bottomFade = 1.0;
    float topFade = 1.0;

    // 计算左右渐隐
    if (UV.x < left_fade_edge) {
        float px = UV.x / fade_width;
        leftFade = smoothstep(divide, divide + blur, px);
    }

    if (UV.x > right_fade_edge) {
        float px = (1.0 - UV.x) / fade_width;
        rightFade = smoothstep(divide, divide + blur, px);
    }
    
    // 计算上下渐隐
    if (UV.y < bottom_fade_edge) {
        float py = UV.y / fade_width;
        bottomFade = smoothstep(divide, divide + blur, py);
    }

    if (UV.y > top_fade_edge) {
        float py = (1.0 - UV.y) / fade_width;
        topFade = smoothstep(divide, divide + blur, py);
    }

    // 综合四个方向的透明度因子
    COLOR.w *= min(min(leftFade, rightFade), min(bottomFade, topFade));
}
    