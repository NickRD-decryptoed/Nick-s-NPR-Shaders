# Nick-s-NPR-Shaders
The Shader(s) of NPR for BlenderMalt.
BlenderMalt中的着色器

已经完成一个着色器

1：Nick's基本NPR着色器（基于Malt内置渲染管线
已经实现：基本漫反射 基本光泽 描边 基于颜色渐变的颜色控制 漫反射和光泽随灯光颜色改变亮面颜色
已知问题：
#1：如果控制漫反射的颜色渐变中，亮面与阴影面的手柄位置，小于0.5。则在材质输出中，受灯光影响的区域会在step(0.01,lambert)的结果的明暗交界处被突然截断。 PS：因为在着色器中，使用半兰伯特作为默认漫反射模型，而用兰伯特作为灯光颜色的生成。
#2：如果场景中有多个灯光，高光可能粘连在一起



English：
Now have developed one shader.

1: Nick'Basic NPR Shader(fundamental is the NPR PipeLines in BlenderMalt)
The features that have achieved:basic diffuse,basic specular,lineart,ColorRamp and light based color controlers.
Known problems: 

#1:If the boundary between lighter area and darker area(in ColorRamp of diffuse) is small tha
0.5,the color of light influence in the lighter area will be cut at the boundary(in material) of the result of lambert(after function  step(0.001,lambert);).PS:the shader use half_lambert_diffuse as the default diffuse. If you use lambert_diffuse as the default diffuse,the problem will be fixed

#2:If there is multiple lights in scene,the multi-specular of different lights may be a mass of specular.
