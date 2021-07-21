//Copyright (c) 2020 BlenderNPR and contributors. MIT license.
#include "Pipelines/NPR_Pipeline.glsl"/NPR_Pipeline.glsl"
vec3 get_lambert(){ //原版兰伯特
    return scene_diffuse(POSITION, get_normal());
}
vec3 get_lambert_half(){  //半兰伯特
    return scene_diffuse_half(POSITION, get_normal());
}
vec3 get_279_toonshader_diffuse(float size,float gradient_size){ //2.79blenderinternal 卡通效果漫射
    return get_toon(size, gradient_size, 0, 0);
}
vec3 get_279_toonshader_specular(float size,float gradient_size){  //2.79blenderinternal 卡通效果光泽
    return get_toon(size, gradient_size, 1,0);
}
vec3 get_279_toonshader_specular_fixed(float size,float gradient_size){
    //2.79blenderinternal 卡通效果光泽修复
    return hsv_to_rgb(vec3(rgb_to_hsv(get_279_toonshader_specular(size,gradient_size)).xy,min(rgb_to_hsv(get_279_toonshader_specular(size,gradient_size)).z,rgb_to_hsv(smoothstep(0,gradient_size/2,get_lambert())).z)));
}


uniform sampler1D diffuse_gradient;
uniform sampler1D spec_gradient;

uniform float spec_power;
uniform float spec_light_influence;
uniform float diffuse_light_influence;
uniform int spec_pattern;

uniform vec3 line_color = vec3(0.0,0.0,0.0);
uniform float line_width = 1.0;
uniform float line_depth_threshold = 0.5;
uniform float line_alpha = 1;
uniform int line_blend_pattern = 0;

void COMMON_PIXEL_SHADER(Surface S, inout PixelOutput PO)
{
    //the result of diffuse
    float diffuse_v = rgb_to_hsv(get_lambert_half().rgb).z; //获得漫反射，剥离HSV的V通道
    vec3 diffuse = texture(diffuse_gradient,diffuse_v).rgb; //应用色彩渐变


    //the result of specular
    float spec_v = rgb_to_hsv(get_279_toonshader_specular_fixed(0.5,0.5).rgb).z; //获得高光，剥离HSV的V通道
    vec3 specular = texture(spec_gradient,spec_v).rgb;//应用色彩渐变

    //the light color of diffuse
    vec3 diffuse_light_color = get_279_toonshader_diffuse(0.499,0.001);//获得一整亮面都是光照颜色的材质
    vec3 diffuse_influence = mix(diffuse,diffuse*diffuse_light_color,diffuse_light_influence);//与色彩渐变后的漫反射混合

    //the light color of specular
    vec3 spec_light_color = get_279_toonshader_specular_fixed(0.499,0.001);//与47，48行类似
    vec3 spec_influence = mix(specular,spec_light_color*specular,spec_light_influence);

    //the light color of specular (blender)
    vec3 spec_light_color_b = get_279_toonshader_specular_fixed(0.5,0.001);//混合得到一整个球都是亮面颜色的材质
    vec3 spec_influence_b = mix(specular,spec_light_color*specular,spec_light_influence);////与色彩渐变后的高光

    //Blend
    vec3 screen_blend = vec3(1.0)-mix(vec3(1.0),(vec3(1.0)-spec_influence),spec_power)*(vec3(1.0)-diffuse_influence); //滤色混合

    //Blend2
    vec3 blend_blend = mix(diffuse_influence,spec_influence_b,texture(spec_gradient,spec_v).r);//混合+系数

    vec3 final_result = mix(screen_blend,blend_blend,spec_pattern);
    PO.color.rgb = final_result;

    //Line Shaders
    vec3 line_color_mix = mix(final_result,line_color,line_alpha);
    vec3 line_color_multiply = mix(final_result,final_result*line_color,line_alpha);
    vec3 line_finalcolor = mix(line_color_multiply,line_color_mix,line_blend_pattern);

    float line = get_line_simple(1, line_depth_threshold, 1.0);
    PO.line_color = vec4(line_finalcolor, line);
    PO.line_width = line > 0 ? line_width : 0;
}

