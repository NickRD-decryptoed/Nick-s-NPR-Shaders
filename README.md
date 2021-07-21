# Nick-s-NPR-Shaders
The Shader(s) of NPR for BlenderMalt.

Now have developed one shader.


1: Nick'Basic NPR Shader(fundamental is the NPR PipeLines in BlenderMalt)
The features that have achieved:basic diffuse,basic specular,lineart,ColorRamp and light based color controlers.
Known problems: 

#1：If the boundary between lighter area and darker area(in ColorRamp) is small tha
0.5,the color of light influence in the lighter area will be cut at the boundary(in material) of the result of lambert(after function  step(0.001,lambert);).PS:the shader use half_lambert_diffuse as the default diffuse. If you use lambert_diffuse as the default diffuse,the problem will be fixed

#2:If there is multiple lights in scene,the multi-specular of different lights may be a mass of specular.
