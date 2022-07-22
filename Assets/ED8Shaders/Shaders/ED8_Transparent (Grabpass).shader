Shader "ED8/Cold Steel Shader/Transparent (Grabpass)" {
    Properties {	
        [HideInInspector] shader_is_using_thry_editor("", Float)= 0
        [HideInInspector] shader_master_label ("<color=#000000ff>Trails of Cold Steel Shader</color>", Float) = 0
        [HideInInspector] shader_properties_label_file ("ed8Labels", Float) = 0
        [ThryShaderOptimizerLockButton] _ShaderOptimizerEnabled ("", Int) = 0

        [Enum(Off,0,Front,1,Back,2)] _Culling ("Culling Mode", Float) = 2
        [Toggle(NOTHING_ENABLED)]_NothingEnabled ("Nothing Enabled (No Lighting)", Float) = 0
        [Toggle(CASTS_SHADOWS_ONLY)]_CastShadowsOnlyEnabled ("Casts Shadows Only", Float) = 0
        [Toggle(CASTS_SHADOWS)]_CastShadowsEnabled ("Casts Shadows", Float) = 0
        [Toggle(RECEIVE_SHADOWS)]_ReceiveShadowsEnabled ("Receive Shadows", Float) = 0

        _GlobalAmbientColor("Global Ambient Color", Color) = (0.50, 0.50, 0.50, 1)
        [Toggle(USE_DIRECTIONAL_LIGHT_COLOR)]_UseDirectionalLightColorEnabled ("Use Directional Light Color", Float) = 0
        [HDR]_MainLightColor("Main Light Color", Color) = (1, 0.9568, 0.8392, 1)

        // #if defined (MAINLIGHT_CLAMP_FACTOR_ENABLED)
        // #if !defined(PER_MATERIAL_MAIN_LIGHT_CLAMP_ENABLED)
        _GlobalMainLightClampFactor("Global MainLight Clamp", Range(0.0, 2.0)) = 1.50
        // #endif (!PER_MATERIAL_MAIN_LIGHT_CLAMP_ENABLED)
        // #endif (MAINLIGHT_CLAMP_FACTOR_ENABLED)

        // #if defined(GENERATE_RELFECTION_ENABLED) || defined(WATER_SURFACE_ENABLED)
        _UserClipPlane("User Clip Plane", Vector) = (0.0, 1.0, 0.0, 0.0)
        [HideInInspector] m_start_WaterSurface ("Enable Water Surface", Float) = 0
        [HideInInspector][Toggle(WATER_SURFACE_ENABLED)]_WaterSurfaceEnabled ("Enable Water Surface", Float) = 0
        // #endif GENERATE_RELFECTION_ENABLED) || (WATER_SURFACE_ENABLED)

        _ReflectionFresnel("Reflection Fresnel", Range(0.0, 10.0)) = 0.5
        _ReflectionIntensity("Reflection Intensity", Range(0.0, 10.0)) = 0.75
        [HideInInspector] m_end_WaterSurface ("Enable Water Surface", Float) = 0
        
        [Toggle(TRANSPARENT_DELAY_ENABLED)]_TransparentDelayEnabled ("Enable Transparent Delay", Float) = 0
        [Toggle(VERTEX_COLOR_ENABLED)]_VertexColorEnabled ("Enable Vertex Color", Float) = 0
        [Toggle(BLEND_VERTEX_COLOR_BY_ALPHA_ENABLED)]_BlendVertexColorAlphaEnabled ("Blend Vertex Color Alpha", Float) = 0
        [Toggle(NO_ALL_LIGHTING_ENABLED)]_NoAllLightingEnabled ("Enable No All Lighting", Float) = 0
        [Toggle(NO_MAIN_LIGHT_SHADING_ENABLED)]_NoMainLightShadingEnabled ("Enable No Main Light Shading", Float) = 0
        [Toggle(HALF_LAMBERT_LIGHTING_ENABLED)]_HalfLambertLightingEnabled ("Enable Half Lambert Lighting", Float) = 0

        _GameMaterialID("Game Material ID", Range(0, 100)) = 0

        [HideInInspector] m_start_GameMaterial ("Game Material", Float) = 0
        _GameMaterialDiffuse("Game Material Diffuse", Color) = (1, 1, 1, 1)
        _GameMaterialEmission("Game Material Emission", Color) = (0, 0, 0, 0)
        _GameMaterialTexcoord("Game Material Texcoord", Vector) = (0.0, 0.0, 1.0, 1.0)

        // #if defined (UVA_SCRIPT_ENABLED)
        [HideInInspector] m_start_UVA ("Enable UV Animation", Float) = 0
        [HideInInspector][Toggle(UVA_SCRIPT_ENABLED)]_UVAEnabled ("Enable UV Animation", Float) = 0
        _UVaMUvColor("UVaMUVColor", Vector) = (1.0, 1.0, 1.0, 1.0)
        _UVaProjTexcoord("UVaProjTexcoord", Vector) = (0.0, 0.0, 1.0, 1.0)
        _UVaMUvTexcoord("UVaMUvTexcoord", Vector) = (0.0, 0.0, 1.0, 1.0)
        _UVaMUv2Texcoord("UVaMUv2Texcoord", Vector) = (0.0, 0.0, 1.0, 1.0)
        _UVaDuDvTexcoord("UVaDuDvTexcoord", Vector) = (0.0, 0.0, 1.0, 1.0)
        [HideInInspector] m_end_UVA ("Enable UV Animation", Float) = 0
        // #endif (UVA_SCRIPT_ENABLED)
        [HideInInspector] m_end_GameMaterial ("Game Material", Float) = 0

        [Toggle(FAR_CLIP_BY_DITHER_ENABLED)]_FarClipDitherEnabled ("Enable Far Clip by Dither", Float) = 0
        _AlphaThreshold("Alpha Threshold", Range(0.004, 1.0)) = 0.5

        // #if defined(FOG_ENABLED)
        [HideInInspector] m_start_Fog ("Enable Fog", Float) = 0
        [HideInInspector][Toggle(FOG_ENABLED)]_FogEnabled ("Enable Fog", Float) = 0
        _FogColor("Fog Color", Color) = (0.5, 0.5, 0.5, 0.0)
        _FogRangeParameters("Fog Range Params", Vector) = (10.0, 500.0, 0.0, 0.0)
        _HeightFogRangeParameters("Height Fog Range Params", Vector) = (10.0, 500.0, 0.0, 0.0)
        _FogRateClamp("Fog Rate", Float) = 1
        _HeightDepthBias("Height Fog Depth Bias", Float) = 1
        _HeightCamRate("Height Fog Cam Rate", Float) = 1
        [Toggle(FOG_RATIO_ENABLED)]_FogRatioEnabled ("Enable Fog Ratio", Float) = 0
        _FogRatio("Fog Ratio", Range(0.0, 1.0)) = 0.5
        [HideInInspector] m_end_Fog ("Enable Fog", Float) = 1
        // #endif (FOG_ENABLED)

        // #if defined(SHADOW_COLOR_SHIFT_ENABLED)
        [HideInInspector] m_start_ShadowColorShift ("Enable Shadow Color Shift", Float) = 0
        [HideInInspector][Toggle(SHADOW_COLOR_SHIFT_ENABLED)]_ShadowColorShiftEnabled ("Enable Shadow Color Shift", Float) = 0
        _ShadowColorShift("Shadow Color Shift", Color) = (0.10, 0.02, 0.02, 0.0)
        [HideInInspector] m_end_ShadowColorShift ("Enable Shadow Color Shift", Float) = 0
        // #endif (SHADOW_COLOR_SHIFT_ENABLED)

        [HideInInspector] m_start_HSA ("Hemisphere Ambient", Float) = 0
        _HemiSphereAmbientSkyColor("HSA Sky Color", Color) = (0.667, 0.667, 0.667, 0.0)
        _HemiSphereAmbientGndColor("HSA Ground Color", Color) = (0.333, 0.333, 0.333, 0.0)
        _HemiSphereAmbientAxis("HSA Axis", Vector) = (0.0, 1.0, 0.0, 0.0)
        [Toggle(FLAT_AMBIENT_ENABLED)]_FlatAmbientEnabled ("Enable Flat Ambient (CS3+)", Float) = 0
        [HideInInspector] m_end_HSA ("Hemisphere Ambient", Float) = 0

        // #if defined(SPECULAR_ENABLED)
        [HideInInspector] m_start_Specular ("Enable Specular", Float) = 0
        [HideInInspector][Toggle(SPECULAR_ENABLED)]_SpecularEnabled ("Enable Specular", Float) = 0
        _Shininess("Shininess", Range(0.0, 10.0)) = 0.5
        _SpecularPower("Specular Power", Range(0.001, 100.0)) = 50.0
        [Toggle(FAKE_CONSTANT_SPECULAR_ENABLED)]_FakeConstantSpecularEnabled ("Enable Fake Constant Specular", Float) = 0

        // #if defined(SPECULAR_COLOR_ENABLED)
        [HideInInspector] m_start_SpecColor ("Enable Specular Color", Float) = 0
        [HideInInspector][Toggle(SPECULAR_COLOR_ENABLED)]_SpecularColorEnabled ("Enable Specular Color", Float) = 0
        _SpecularColor("Specular Color", Color) = (1.0, 1.0, 1.0, 0.0)
        [HideInInspector] m_end_SpecColor ("Enable Specular Color", Float) = 0
        [HideInInspector] m_end_Specular ("Enable Specular", Float) = 0
        // #endif (SPECULAR_COLOR_ENABLED)
        // #endif (SPECULAR_ENABLED)

        // #if defined(RIM_LIGHTING_ENABLED)
        [HideInInspector] m_start_RimLighting ("Enable Rim Lighting", Float) = 0
        [HideInInspector][Toggle(RIM_LIGHTING_ENABLED)]_RimLightingEnabled ("Enable Rim Lighting", Float) = 0
        [Toggle(RIM_TRANSPARENCY_ENABLED)]_RimTransparencyEnabled ("Enable Rim Transparency", Float) = 0
        _RimLitColor("Rim Lit Color", Color) = (1.0, 1.0, 1.0, 0.0)
        _RimLitIntensity("Rim Lit Intensity", Range(0.001, 100.0)) = 4.0
        _RimLitPower("Rim Lit Power", Range(0.001, 50.0)) = 2.0
        [HideInInspector] m_start_RimClamp ("Enable Rim Clamp", Float) = 0
        [Toggle(RIM_CLAMP_ENABLED)]_RimClampEnabled ("Enable Rim Clamp", Float) = 0
        _RimLightClampFactor("Rim Light Clamp", Range(0.001, 50.0)) = 1.0
        [HideInInspector] m_end_RimClamp ("Enable Rim Clamp", Float) = 0
        [HideInInspector] m_end_RimLighting ("Enable Rim Lighting", Float) = 0
        // #endif (RIM_LIGHTING_ENABLED)

        [Toggle(TEXCOORD_OFFSET_ENABLED)]_TexcoordOffsetEnabled ("Enable Texcoord Offset", Float) = 0
        _TexCoordOffset("TexCoordOffset", Vector) = (0.0, 0.0, 0.0, 0.0)
        _TexCoordOffset2("TexCoordOffset2", Vector) = (0.0, 0.0, 0.0, 0.0)
        _TexCoordOffset3("TexCoordOffset3", Vector) = (0.0, 0.0, 0.0, 0.0)

        // #if !defined(NOTHING_ENABLED)
        _MainTex("Diffuse Map", 2D) = "white" {}
        // #endif (!NOTHING_ENABLED)

        [Toggle(NORMAL_MAPP_DXT5_NM_ENABLED)]_NormalMapDXT5NMEnabled ("Enable Normal Map DXT5 NM", Float) = 0
        [Toggle(NORMAL_MAPP_DXT5_LP_ENABLED)]_NormalMapDXT5LPEnabled ("Enable Normal Map DXT5 LP", Float) = 0
        // #if defined(NORMAL_MAPPING_ENABLED)
        [HideInInspector] m_start_NormalMap ("Enable Normal Mapping", Float) = 0
        [HideInInspector][Toggle(NORMAL_MAPPING_ENABLED)]_NormalMappingEnabled ("Enable Normal Mapping", Float) = 0
        _BumpMap("Normal Map", 2D) = "bump" {}
        [HideInInspector] m_end_NormalMap ("Enable Normal Mapping", Float) = 0
        // #endif (NORMAL_MAPPING_ENABLED)

        // #if defined(SPECULAR_MAPPING_ENABLED)
        [HideInInspector] m_start_SpecularMap ("Enable Specular Mapping", Float) = 0
        [HideInInspector][Toggle(SPECULAR_MAPPING_ENABLED)]_SpecularMappingEnabled ("Enable Specular Mapping", Float) = 0
        _SpecularMapSampler("Specular Map", 2D) = "white" {}
        [HideInInspector] m_end_SpecularMap ("Enable Specular Mapping", Float) = 0
        // #endif (SPECULAR_MAPPING_ENABLED)

        // #if defined(OCCULUSION_MAPPING_ENABLED)
        [HideInInspector] m_start_OcculusionMap ("Enable Occulusion Mapping", Float) = 0
        [HideInInspector][Toggle(OCCULUSION_MAPPING_ENABLED)]_OcculusionMappingEnabled ("Enable Occulusion Mapping", Float) = 0
        _OcculusionMapSampler("Occulusion Map", 2D) = "white" {}
        [HideInInspector] m_end_OcculusionMap ("Enable Occulusion Mapping", Float) = 0
        // #endif (OCCULUSION_MAPPING_ENABLED)

        // #if defined(EMISSION_MAPPING_ENABLED)
        [HideInInspector] m_start_EmissionMap ("Enable Emission Mapping", Float) = 0
        [HideInInspector][Toggle(EMISSION_MAPPING_ENABLED)]_EmissionMappingEnabled ("Enable Emission Mapping", Float) = 0
        _EmissionMapSampler("Emission Map", 2D) = "white" {}
        [HideInInspector] m_end_EmissionMap ("Enable Emission Mapping", Float) = 0
        // #endif (EMISSION_MAPPING_ENABLED)

        // #if defined(MULTI_UV_ENANLED)
        //#if !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
        [HideInInspector] m_start_MultiUV ("Enable Multi UV", Float) = 0
        [HideInInspector][Toggle(MULTI_UV_ENANLED)]_MultiUVEnabled ("Enable Multi UV", Float) = 0
        [Toggle(MULTI_UV_ADDITIVE_BLENDING_ENANLED)]_MultiUVAdditiveBlendingEnabled ("Multi UV Additive Blending", Float) = 0
        [Toggle(MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED)]_MultiUVMultiplicativeBlendingEnabled ("Multi UV Multiplicative Blending", Float) = 0
        [Toggle(MULTI_UV_MULTIPLICATIVE_BLENDING_LM_ENANLED)]_MultiUVMultiplicativeBlendingLMEnabled ("Multi UV Multiplicative Blending LM", Float) = 0
        [Toggle(MULTI_UV_MULTIPLICATIVE_BLENDING_EX_ENANLED)]_MultiUVMultiplicativeBlendingEXEnabled ("Multi UV Multiplicative Blending EX", Float) = 0
        [Toggle(MULTI_UV_SHADOW_ENANLED)]_MultiUVShadowEnabled ("Multi UV Shadow", Float) = 0
        [Toggle(MULTI_UV_FACE_ENANLED)]_MultiUVFaceEnabled ("Multi UV Face", Float) = 0
        [Toggle(MULTI_UV_TEXCOORD_OFFSET_ENABLED)]_MultiUVTexCoordOffsetEnabled ("Multi UV Texcoord Offset", Float) = 0
        [Toggle(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)]_MultiUVNoDiffuseEnabled ("Multi UV No Diffuse Map", Float) = 0
        _BlendMulScale2("Multiplicative Blend Scale", Range(0.001, 10.0)) = 0.001
        _DiffuseMap2Sampler("Diffuse Map 2", 2D) = "white" {}
        // #endif (!MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

        // #if defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
        [HideInInspector] m_start_MultiUVNormalMap ("Enable Normal Map 2", Float) = 0
        [HideInInspector][Toggle(MULTI_UV_NORMAL_MAPPING_ENABLED)]_MultiUVNormalMappingEnabled ("Enable Normal Map 2", Float) = 0
        _NormalMap2Sampler("Normal Map 2", 2D) = "white" {}
        [HideInInspector] m_end_MultiUVNormalMap ("Enable Normal Map 2", Float) = 0
        // #endif (MULTI_UV_NORMAL_MAPPING_ENABLED)

        // #if defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
        [HideInInspector] m_start_MultiUVSpecularMap ("Enable Specular Map 2", Float) = 0
        [HideInInspector][Toggle(MULTI_UV_SPECULAR_MAPPING_ENABLED)]_MultiUVSpecularMappingEnabled ("Enable Specular Map 2", Float) = 0
        _SpecularMap2Sampler("Specular Map 2", 2D) = "white" {}
        [HideInInspector] m_end_MultiUVSpecularMap ("Enable Specular Map 2", Float) = 0
        // #endif (MULTI_UV_SPECULAR_MAPPING_ENABLED)

        // #if defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
        [HideInInspector] m_start_MultiUVOcculusionMap ("Enable Occulusion Map 2", Float) = 0
        [HideInInspector][Toggle(MULTI_UV_OCCULUSION_MAPPING_ENABLED)]_MultiUVOcculusionMappingEnabled ("Enable Occulusion Map 2", Float) = 0
        _OcculusionMap2Sampler("Occulusion Map 2", 2D) = "white" {}
        [HideInInspector] m_end_MultiUVOcculusionMap ("Enable Occulusion Map 2", Float) = 0
        // #endif (MULTI_UV_OCCULUSION_MAPPING_ENABLED)

        // #if defined(MULTI_UV_GLARE_MAP_ENABLED)
        [HideInInspector] m_start_MultiUVGlareMap ("Enable Glare Map 2", Float) = 0
        [HideInInspector][Toggle(MULTI_UV_GLARE_MAP_ENABLED)]_MultiUVGlareMappingEnabled ("Enable Glare Map 2", Float) = 0
        _GlareMap2Sampler("Glare Map 2", 2D) = "white" {}
        [HideInInspector] m_end_MultiUVGlareMap ("Enable Glare Map 2", Float) = 0
        [HideInInspector] m_end_MultiUV ("Enable Multi UV", Float) = 0
        // #endif (MULTI_UV_GLARE_MAP_ENABLED)
        // #endif (MULTI_UV_ENANLED)

        // #if defined(MULTI_UV2_ENANLED)
        //#if !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
        [HideInInspector] m_start_MultiUV2 ("Enable Multi UV 2", Float) = 0
        [HideInInspector][Toggle(MULTI_UV2_ENANLED)]_MultiUV2Enabled ("Enable Multi UV 2", Float) = 0
        [Toggle(MULTI_UV2_ADDITIVE_BLENDING_ENANLED)]_MultiUV2AdditiveBlendingEnabled ("Multi UV2 Additive Blending", Float) = 0
        [Toggle(MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED)]_MultiUV2MultiplicativeBlendingEnabled ("Multi UV2 Multiplicative Blending", Float) = 0
        [Toggle(MULTI_UV2_MULTIPLICATIVE_BLENDING_LM_ENANLED)]_MultiUV2MultiplicativeBlendingLMEnabled ("Multi UV2 Multiplicative Blending LM", Float) = 0
        [Toggle(MULTI_UV2_MULTIPLICATIVE_BLENDING_EX_ENANLED)]_MultiUV2MultiplicativeBlendingEXEnabled ("Multi UV2 Multiplicative Blending EX", Float) = 0
        [Toggle(MULTI_UV2_SHADOW_ENANLED)]_MultiUV2ShadowEnabled ("Multi UV2 Shadow", Float) = 0
        [Toggle(MULTI_UV2_FACE_ENANLED)]_MultiUV2FaceEnabled ("Multi UV2 Face", Float) = 0
        [Toggle(MULTI_UV2_TEXCOORD_OFFSET_ENABLED)]_MultiUV2TexCoordOffsetEnabled ("Multi UV2 Texcoord Offset", Float) = 0
        [Toggle(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)]_MultiUV2NoDiffuseEnabled ("Multi UV2 No Diffuse Map", Float) = 0
        _BlendMulScale3("Multiplicative Blend Scale", Range(0.001, 10.0)) = 0.001
        _DiffuseMap3Sampler("Diffuse Map 3", 2D) = "white" {}
        // #endif (!MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)

        // #if defined(MULTI_UV2_NORMAL_MAPPING_ENABLED)
        [HideInInspector] m_start_MultiUV2NormalMap ("Enable Normal Map 3", Float) = 0
        [HideInInspector][Toggle(MULTI_UV2_NORMAL_MAPPING_ENABLED)]_MultiUV2NormalMappingEnabled ("Enable Normal Map 3", Float) = 0
        _NormalMap3Sampler("Normal Map 3", 2D) = "white" {}
        [HideInInspector] m_end_MultiUV2NormalMap ("Enable Normal Map 3", Float) = 0
        // #endif (MULTI_UV2_NORMAL_MAPPING_ENABLED)

        // #if defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED)
        [HideInInspector] m_start_MultiUV2SpecularMap ("Enable Specular Map 3", Float) = 0
        [HideInInspector][Toggle(MULTI_UV2_SPECULAR_MAPPING_ENABLED)]_MultiUV2SpecularMappingEnabled ("Enable Specular Map 3", Float) = 0
        _SpecularMap3Sampler("Specular Map 3", 2D) = "white" {}
        [HideInInspector] m_end_MultiUV2SpecularMap ("Enable Specular Map 3", Float) = 0
        // #endif (MULTI_UV2_SPECULAR_MAPPING_ENABLED)

        // #if defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
        [HideInInspector] m_start_MultiUV2OcculusionMap ("Enable Occulusion Map 3", Float) = 0
        [HideInInspector][Toggle(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)]_MultiUV2OcculusionMappingEnabled ("Enable Occulusion Map 3", Float) = 0
        _OcculusionMap3Sampler("Occulusion Map 3", 2D) = "white" {}
        [HideInInspector] m_end_MultiUV2OcculusionMap ("Enable Occulusion Map 3", Float) = 0
        // #endif (MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
        [HideInInspector] m_end_MultiUV2 ("Enable Multi UV 2", Float) = 0
        // #endif (MULTI_UV2_ENANLED)

        // #if defined(CARTOON_SHADING_ENABLED)
        [HideInInspector] m_start_CartoonShading ("Enable Cartoon Shading", Float) = 0
        [HideInInspector][Toggle(CARTOON_SHADING_ENABLED)]_CartoonShadingEnabled ("Enable Cartoon Shading", Float) = 0
        _CartoonMapSampler("Cartoon Map", 2D) = "white" {}

        // #if defined(CARTOON_HILIGHT_ENABLED)
        [HideInInspector] m_start_CartoonHilight ("Enable Cartoon Hilight", Float) = 0
        [HideInInspector][Toggle(CARTOON_HILIGHT_ENABLED)]_CartoonHilightEnabled ("Enable Cartoon Hilight", Float) = 0
        _HighlightMapSampler("Hilight Map", 2D) = "white" {}
        _HighlightColor("Hilight Color", Color) = (1.0, 1.0, 1.0, 0.0)
        _HighlightIntensity("Hilight Intensity", Range(0.001, 10.0)) = 2.0
        [HideInInspector] m_end_CartoonHilight ("Enable Cartoon Hilight", Float) = 0
        // #endif (CARTOON_HILIGHT_ENABLED)

        _ShadowReceiveOffset("ShadowReceiveOffset", Range(0.0, 10.0)) = 0.75
        [HideInInspector] m_end_CartoonShading ("Enable Cartoon Shading", Float) = 0
        // #endif (CARTOON_SHADING_ENABLED)

        [Toggle(EMVMAP_AS_IBL_ENABLED)]_EMVMapAsIBLEnabled ("Enable EMVMap as IBL", Float) = 0

        // #if defined(SPHERE_MAPPING_ENABLED)
        [HideInInspector] m_start_SphereMap ("Enable Sphere Mapping", Float) = 0
        [HideInInspector][Toggle(SPHERE_MAPPING_ENABLED)]_SphereMappingEnabled ("Enable Sphere Mapping", Float) = 0
        _SphereMapSampler("Sphere Map", 2D) = "white" {}
        _SphereMapIntensity("Sphere Map Intensity", Range(0.0, 10.0)) = 1.0
        [HideInInspector] m_end_SphereMap ("Enable Sphere Mapping", Float) = 0
        // #endif (SPHERE_MAPPING_ENABLED)

        // #if defined(CUBE_MAPPING_ENABLED)
        [HideInInspector] m_start_CubeMap ("Enable Cube Mapping", Float) = 0
        [HideInInspector][Toggle(CUBE_MAPPING_ENABLED)]_CubeMappingEnabled ("Enable Cube Mapping", Float) = 0
        _CubeMapSampler("Cube Map", CUBE) = "" {}
        _CubeMapFresnel("Cube Map Fresnel", Range(0.0, 10.0)) = 0.0
        _CubeMapIntensity("Cube Map Intensity", Range(0.0, 10.0)) = 0.0
        [HideInInspector] m_end_CubeMap ("Enable Cube Mapping", Float) = 0
        // #endif (CUBE_MAPPING_ENABLED)

        // #if defined(PROJECTION_MAP_ENABLED)
        [HideInInspector] m_start_ProjectionMap ("Enable Projection Mapping", Float) = 0
        [HideInInspector][Toggle(PROJECTION_MAP_ENABLED)]_ProjectionMappingEnabled ("Enable Projection Mapping", Float) = 0
        _ProjectionMapSampler("Projection Map", 2D) = "white" {}
        _ProjectionScale("Projection Scale", Vector) = (1.0, 1.0, 0.0, 0.0)
        _ProjectionScroll("Projection Scroll", Vector) = (0.00, 0.00, 0.00, 0.00)
        [HideInInspector] m_end_ProjectionMap ("Enable Projection Mapping", Float) = 0
        // #endif (PROJECTION_MAP_ENABLED)

        // #if defined(DUDV_MAPPING_ENABLED)
        [HideInInspector] m_start_DuDvMap ("Enable DuDv Mapping", Float) = 0
        [HideInInspector][Toggle(DUDV_MAPPING_ENABLED)]_DuDvMappingEnabled ("Enable DuDv Mapping", Float) = 0
        _DuDvMapSampler("DuDv Map", 2D) = "white" {}
        _DuDvMapImageSize("DuDv Map Image Size", Vector) = (256.0, 256.0, 0.0, 0.0)
        _DuDvScale("DuDv Scale", Vector) = (4.0, 4.0, 0.0, 0.0)
        _DuDvScroll("DuDv Scroll", Vector) = (1.0, 1.0, 0.0, 0.0)
        [HideInInspector] m_end_DuDvMap ("Enable DuDv Mapping", Float) = 0
        // #endif (DUDV_MAPPING_ENABLED)

        // #if defined(WINDY_GRASS_ENABLED)
        [HideInInspector] m_start_WindyGrass ("Enable Windy Grass", Float) = 0
        [HideInInspector][Toggle(WINDY_GRASS_ENABLED)]_WindyGrassEnabled ("Enable Windy Grass", Float) = 0
        [Toggle(WINDY_GRASS_TEXV_WEIGHT_ENABLED)]_WindyGrassTexVEnabled ("Enable Tex V Weight", Float) = 0
        _WindyGrassDirection("Windy Grass Direction", Vector) = (0.0, 0.0, 0.0, 0.0)
        _WindyGrassSpeed("Windy Grass Speed", Range(0.01, 100.0)) = 2.0
        _WindyGrassHomogenity("Windy Grass Homogenity", Range(1.0, 10.0)) = 2.0
        _WindyGrassScale("Windy Grass Scale", Range(1.0, 10.0)) = 1.0
        [HideInInspector] m_end_WindyGrass ("Enable Windy Grass", Float) = 0
        // #endif (WINDY_GRASS_ENABLED)

        // #if defined(GLARE_MAP_ENABLED)
        [HideInInspector] m_start_GlareMap ("Enable Glare Mapping", Float) = 0
        [HideInInspector][Toggle(GLARE_MAP_ENABLED)]_GlareMappingEnabled ("Enable Glare Mapping", Float) = 0
        _GlareMapSampler("Glare Map", 2D) = "white" {}
        [HideInInspector] m_end_GlareMap ("Enable Glare Mapping", Float) = 0
        // #endif (GLARE_MAP_ENABLED)

        [Toggle(GLARE_HIGHTPASS_ENABLED)]_GlareHilightPassEnabled ("Enable Glare HilightPass", Float) = 0
        //[Toggle(GLARE_EMISSION_ENABLED)]_GlareEmissionEnabled ("Enable Glare Emission", Float) = 0
        _GlareIntensity("Glare Intensity", Range(0.0, 20.0)) = 0.0

        [HideInInspector] m_start_BlendOptions ("Blending", Float) = 0
        [Toggle(ADDITIVE_BLENDING_ENABLED)]_AdditiveBlendEnabled ("Enable Additive Blending", Float) = 0
        [Toggle(SUBTRACT_BLENDING_ENABLED)]_SubtractiveBlendEnabled ("Enable Subtract Blending", Float) = 0
        [Toggle(MULTIPLICATIVE_BLENDING_ENABLED)]_MultiplicativeBlendEnabled ("Enable Multiplicative Blending", Float) = 0
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Source Blend", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Destination Blend", Float) = 10
        [Enum(DepthWrite)] _ZWrite("Depth Write", Float) = 0
        _Factor ("Z Factor", Float) = 0
        _Units ("Z Units", Float) = 0
        [HideInInspector] m_end_BlendOptions ("Blending", Float) = 0

        [HideInInspector] m_start_StencilOptions ("Stencil", Float) = 0
        [IntRange] _StencilRef ("Stencil Reference Value", Range(0, 255)) = 0
        [IntRange] _StencilReadMask ("Stencil ReadMask Value", Range(0, 255)) = 255
        [IntRange] _StencilWriteMask ("Stencil WriteMask Value", Range(0, 255)) = 255
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilPassOp ("Stencil Pass Op", Float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilFailOp ("Stencil Fail Op", Float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilZFailOp ("Stencil ZFail Op", Float) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilCompareFunction ("Stencil Compare Function", Float) = 8
        [HideInInspector] m_end_StencilOptions ("Stencil", Float) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("Depth Test", Float) = 4
        [Enum(DepthWrite)] _ZWrite("Depth Write", Float) = 1
        [HideInInspector] Instancing ("Instancing", Float) = 0 //add this property for instancing variants settings to be shown

        //[HideInInspector] m_animationToggles ("Animation Support Toggles", Float) = 0
        //[HelpBox(1)] _AnimationToggleHelp ("You don't need to search through this list. You can enable animation support on any property by right clicking it", Int) = 0
        [HideInInspector]_GlobalAmbientColorAnimated("Global Ambient Color", Int) = 0
        [HideInInspector]_MainLightColorAnimated("Main Light Color", Int) = 0
        [HideInInspector]_GlobalMainLightClampFactorAnimated("Global MainLight Clamp", Int) = 0
        [HideInInspector]_GameMaterialDiffuseAnimated("Game Material Diffuse", Int) = 0
        [HideInInspector]_GameMaterialEmissionAnimated("Game Material Emission", Int) = 0
        [HideInInspector]_FogColorAnimated("Fog Color", Int) = 0
        [HideInInspector]_FogRangeParametersAnimated("Fog Range Params", Int) = 0
        [HideInInspector]_HeightFogRangeParametersAnimated("Height Fog Range Params", Int) = 0
        [HideInInspector]_HeightDepthBiasAnimated("Height Fog Depth Bias", Int) = 0
        [HideInInspector]_HeightCamRateAnimated("Height Fog Cam Rate", Int) = 0
        [HideInInspector]_FogRateClampAnimated("Fog Rate", Int) = 0
        [HideInInspector]_HemiSphereAmbientSkyColorAnimated("HSA Sky Color", Int) = 0
        [HideInInspector]_HemiSphereAmbientGndColorAnimated("HSA Ground Color", Int) = 0
        [HideInInspector]_HemiSphereAmbientAxisAnimated("HSA Axis", Int) = 0
    }

    CustomEditor "Thry.ShaderEditor"
    SubShader {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True"}
        Cull [_Culling]
        LOD 200
        ZTest[_ZTest]
        Stencil {
            Ref [_StencilRef]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
            Comp [_StencilCompareFunction]
            Pass [_StencilPassOp]
            Fail [_StencilFailOp]
            ZFail [_StencilZFailOp]
        }

        //Pass {
        //    ZWrite On
        //    ColorMask 0
        //}

        GrabPass { "_RefractionTexture" }

        Pass {
            Name "FORWARD"
            Tags { "LightMode" = "ForwardBase" }
            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]
            Offset [_Factor], [_Units]
            
            CGPROGRAM

            #pragma target 5.0
            
            #ifndef UNITY_PASS_FORWARDBASE
                #define UNITY_PASS_FORWARDBASE
            #endif

            #define ALPHA_BLENDING_ENABLED
            #define ED8_GRABPASS

            #pragma shader_feature NOTHING_ENABLED
            #pragma shader_feature CASTS_SHADOWS_ONLY
            #pragma shader_feature CASTS_SHADOWS
            #pragma shader_feature RECEIVE_SHADOWS
            #pragma shader_feature USE_DIRECTIONAL_LIGHT_COLOR
            #pragma shader_feature ADDITIVE_BLENDING_ENABLED
            #pragma shader_feature SUBTRACT_BLENDING_ENABLED
            #pragma shader_feature MULTIPLICATIVE_BLENDING_ENABLED
            #pragma shader_feature WATER_SURFACE_ENABLED
            #pragma shader_feature_local TRANSPARENT_DELAY_ENABLED
            #pragma shader_feature VERTEX_COLOR_ENABLED
            #pragma shader_feature_local BLEND_VERTEX_COLOR_BY_ALPHA_ENABLED
            #pragma shader_feature_local FAR_CLIP_BY_DITHER_ENABLED
            #pragma shader_feature_local NO_ALL_LIGHTING_ENABLED
            #pragma shader_feature_local NO_MAIN_LIGHT_SHADING_ENABLED
            #pragma shader_feature_local HALF_LAMBERT_LIGHTING_ENABLED
            #pragma shader_feature FLAT_AMBIENT_ENABLED
            #pragma shader_feature_local UVA_SCRIPT_ENABLED
            #pragma shader_feature FOG_ENABLED
            #pragma shader_feature_local FOG_RATIO_ENABLED
            #pragma shader_feature_local SHADOW_COLOR_SHIFT_ENABLED
            #pragma shader_feature SPECULAR_ENABLED
            #pragma shader_feature_local FAKE_CONSTANT_SPECULAR_ENABLED
            #pragma shader_feature_local SPECULAR_COLOR_ENABLED
            #pragma shader_feature_local RIM_LIGHTING_ENABLED
            #pragma shader_feature RIM_CLAMP_ENABLED
            #pragma shader_feature_local RIM_TRANSPARENCY_ENABLED
            #pragma shader_feature_local TEXCOORD_OFFSET_ENABLED
            #pragma shader_feature_local NORMAL_MAPP_DXT5_NM_ENABLED
            #pragma shader_feature_local NORMAL_MAPP_DXT5_LP_ENABLED
            #pragma shader_feature_local NORMAL_MAPPING_ENABLED
            #pragma shader_feature_local SPECULAR_MAPPING_ENABLED
            #pragma shader_feature_local OCCULUSION_MAPPING_ENABLED
            #pragma shader_feature_local EMISSION_MAPPING_ENABLED
            #pragma shader_feature_local MULTI_UV_ENANLED
            #pragma shader_feature_local MULTI_UV_ADDITIVE_BLENDING_ENANLED
            #pragma shader_feature_local MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED
            #pragma shader_feature_local MULTI_UV_MULTIPLICATIVE_BLENDING_LM_ENANLED
            #pragma shader_feature_local MULTI_UV_MULTIPLICATIVE_BLENDING_EX_ENANLED
            #pragma shader_feature_local MULTI_UV_SHADOW_ENANLED
            #pragma shader_feature_local MULTI_UV_FACE_ENANLED
            #pragma shader_feature_local MULTI_UV_TEXCOORD_OFFSET_ENABLED
            #pragma shader_feature_local MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED
            #pragma shader_feature_local MULTI_UV_NORMAL_MAPPING_ENABLED
            #pragma shader_feature_local MULTI_UV_SPECULAR_MAPPING_ENABLED
            #pragma shader_feature_local MULTI_UV_OCCULUSION_MAPPING_ENABLED
            #pragma shader_feature_local MULTI_UV_GLARE_MAP_ENABLED
            #pragma shader_feature_local MULTI_UV2_ENANLED
            #pragma shader_feature_local MULTI_UV2_ADDITIVE_BLENDING_ENANLED
            #pragma shader_feature_local MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED
            #pragma shader_feature_local MULTI_UV2_MULTIPLICATIVE_BLENDING_LM_ENANLED
            #pragma shader_feature_local MULTI_UV2_MULTIPLICATIVE_BLENDING_EX_ENANLED
            #pragma shader_feature_local MULTI_UV2_SHADOW_ENANLED
            #pragma shader_feature_local MULTI_UV2_FACE_ENANLED
            #pragma shader_feature_local MULTI_UV2_TEXCOORD_OFFSET_ENABLED
            #pragma shader_feature_local MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED
            #pragma shader_feature_local MULTI_UV2_NORMAL_MAPPING_ENABLED
            #pragma shader_feature_local MULTI_UV2_SPECULAR_MAPPING_ENABLED
            #pragma shader_feature_local MULTI_UV2_OCCULUSION_MAPPING_ENABLED
            #pragma shader_feature_local CARTOON_SHADING_ENABLED
            #pragma shader_feature_local CARTOON_HILIGHT_ENABLED
            #pragma shader_feature_local EMVMAP_AS_IBL_ENABLED
            #pragma shader_feature_local SPHERE_MAPPING_ENABLED
            #pragma shader_feature_local CUBE_MAPPING_ENABLED
            #pragma shader_feature_local PROJECTION_MAP_ENABLED
            #pragma shader_feature_local DUDV_MAPPING_ENABLED
            #pragma shader_feature_local WINDY_GRASS_ENABLED
            #pragma shader_feature_local WINDY_GRASS_TEXV_WEIGHT_ENABLED
            #pragma shader_feature USE_OUTLINE
            #pragma shader_feature_local USE_OUTLINE_COLOR
            #pragma shader_feature USE_SCREEN_UV
            #pragma shader_feature_local GLARE_MAP_ENABLED
            #pragma shader_feature_local GLARE_HIGHTPASS_ENABLED

            #pragma multi_compile_instancing
            #pragma multi_compile_fwdbase
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma vertex DefaultVPShader
            #pragma fragment DefaultFPShader
            
            #include "../CGIncludes/ED8_Defines.cginc"
            #include "../CGIncludes/ED8_HelperFunctions.cginc"
            #include "../CGIncludes/ED8_Lighting.cginc"
            #include "../CGIncludes/ED8_Vert.cginc"
            #include "../CGIncludes/ED8_Frag.cginc"
            ENDCG
        }

        Pass {
            Name "FWDADD"
            Tags { "LightMode" = "ForwardAdd" }
            Blend SrcAlpha One
            ZWrite [_ZWrite]
            Offset [_Factor], [_Units]

            CGPROGRAM

            #pragma target 5.0
            
            #ifndef UNITY_PASS_FORWARDADD
                 #define UNITY_PASS_FORWARDADD
            #endif

            #define ALPHA_BLENDING_ENABLED
            #define ED8_GRABPASS

            #pragma shader_feature NOTHING_ENABLED
            #pragma shader_feature CASTS_SHADOWS_ONLY
            #pragma shader_feature CASTS_SHADOWS
            #pragma shader_feature RECEIVE_SHADOWS
            #pragma shader_feature USE_DIRECTIONAL_LIGHT_COLOR
            #pragma shader_feature ADDITIVE_BLENDING_ENABLED
            #pragma shader_feature SUBTRACT_BLENDING_ENABLED
            #pragma shader_feature MULTIPLICATIVE_BLENDING_ENABLED
            #pragma shader_feature WATER_SURFACE_ENABLED
            #pragma shader_feature_local TRANSPARENT_DELAY_ENABLED
            #pragma shader_feature VERTEX_COLOR_ENABLED
            #pragma shader_feature_local BLEND_VERTEX_COLOR_BY_ALPHA_ENABLED
            #pragma shader_feature_local FAR_CLIP_BY_DITHER_ENABLED
            #pragma shader_feature_local NO_ALL_LIGHTING_ENABLED
            #pragma shader_feature_local NO_MAIN_LIGHT_SHADING_ENABLED
            #pragma shader_feature_local HALF_LAMBERT_LIGHTING_ENABLED
            #pragma shader_feature FLAT_AMBIENT_ENABLED
            #pragma shader_feature_local UVA_SCRIPT_ENABLED
            #pragma shader_feature FOG_ENABLED
            #pragma shader_feature_local FOG_RATIO_ENABLED
            #pragma shader_feature_local SHADOW_COLOR_SHIFT_ENABLED
            #pragma shader_feature SPECULAR_ENABLED
            #pragma shader_feature_local FAKE_CONSTANT_SPECULAR_ENABLED
            #pragma shader_feature_local SPECULAR_COLOR_ENABLED
            #pragma shader_feature_local RIM_LIGHTING_ENABLED
            #pragma shader_feature RIM_CLAMP_ENABLED
            #pragma shader_feature_local RIM_TRANSPARENCY_ENABLED
            #pragma shader_feature_local TEXCOORD_OFFSET_ENABLED
            #pragma shader_feature_local NORMAL_MAPP_DXT5_NM_ENABLED
            #pragma shader_feature_local NORMAL_MAPP_DXT5_LP_ENABLED
            #pragma shader_feature_local NORMAL_MAPPING_ENABLED
            #pragma shader_feature_local SPECULAR_MAPPING_ENABLED
            #pragma shader_feature_local OCCULUSION_MAPPING_ENABLED
            #pragma shader_feature_local EMISSION_MAPPING_ENABLED
            #pragma shader_feature_local MULTI_UV_ENANLED
            #pragma shader_feature_local MULTI_UV_ADDITIVE_BLENDING_ENANLED
            #pragma shader_feature_local MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED
            #pragma shader_feature_local MULTI_UV_MULTIPLICATIVE_BLENDING_LM_ENANLED
            #pragma shader_feature_local MULTI_UV_MULTIPLICATIVE_BLENDING_EX_ENANLED
            #pragma shader_feature_local MULTI_UV_SHADOW_ENANLED
            #pragma shader_feature_local MULTI_UV_FACE_ENANLED
            #pragma shader_feature_local MULTI_UV_TEXCOORD_OFFSET_ENABLED
            #pragma shader_feature_local MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED
            #pragma shader_feature_local MULTI_UV_NORMAL_MAPPING_ENABLED
            #pragma shader_feature_local MULTI_UV_SPECULAR_MAPPING_ENABLED
            #pragma shader_feature_local MULTI_UV_OCCULUSION_MAPPING_ENABLED
            #pragma shader_feature_local MULTI_UV_GLARE_MAP_ENABLED
            #pragma shader_feature_local MULTI_UV2_ENANLED
            #pragma shader_feature_local MULTI_UV2_ADDITIVE_BLENDING_ENANLED
            #pragma shader_feature_local MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED
            #pragma shader_feature_local MULTI_UV2_MULTIPLICATIVE_BLENDING_LM_ENANLED
            #pragma shader_feature_local MULTI_UV2_MULTIPLICATIVE_BLENDING_EX_ENANLED
            #pragma shader_feature_local MULTI_UV2_SHADOW_ENANLED
            #pragma shader_feature_local MULTI_UV2_FACE_ENANLED
            #pragma shader_feature_local MULTI_UV2_TEXCOORD_OFFSET_ENABLED
            #pragma shader_feature_local MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED
            #pragma shader_feature_local MULTI_UV2_NORMAL_MAPPING_ENABLED
            #pragma shader_feature_local MULTI_UV2_SPECULAR_MAPPING_ENABLED
            #pragma shader_feature_local MULTI_UV2_OCCULUSION_MAPPING_ENABLED
            #pragma shader_feature_local CARTOON_SHADING_ENABLED
            #pragma shader_feature_local CARTOON_HILIGHT_ENABLED
            #pragma shader_feature_local EMVMAP_AS_IBL_ENABLED
            #pragma shader_feature_local SPHERE_MAPPING_ENABLED
            #pragma shader_feature_local CUBE_MAPPING_ENABLED
            #pragma shader_feature_local PROJECTION_MAP_ENABLED
            #pragma shader_feature_local DUDV_MAPPING_ENABLED
            #pragma shader_feature_local WINDY_GRASS_ENABLED
            #pragma shader_feature_local WINDY_GRASS_TEXV_WEIGHT_ENABLED
            #pragma shader_feature USE_OUTLINE
            #pragma shader_feature_local USE_OUTLINE_COLOR
            #pragma shader_feature USE_SCREEN_UV
            #pragma shader_feature_local GLARE_MAP_ENABLED
            #pragma shader_feature_local GLARE_HIGHTPASS_ENABLED

            #pragma multi_compile_instancing
            #pragma multi_compile_fwdadd_fullshadows
            #pragma vertex DefaultVPShader
            #pragma fragment DefaultFPShader
            
            #include "../CGIncludes/ED8_Defines.cginc"
            #include "../CGIncludes/ED8_HelperFunctions.cginc"
            #include "../CGIncludes/ED8_Lighting.cginc"
            #include "../CGIncludes/ED8_Vert.cginc"
            #include "../CGIncludes/ED8_Frag.cginc"
            ENDCG
        }

        //Pass {
        //    Name "ShadowCaster"
        //    Tags{ "LightMode" = "ShadowCaster" }
        //    ZWrite On ZTest LEqual
        //    CGPROGRAM

        //    #pragma target 5.0

        //    #ifndef UNITY_PASS_SHADOWCASTER
        //        #define UNITY_PASS_SHADOWCASTER
        //    #endif

        //    #pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
        //    #pragma shader_feature_local WINDY_GRASS_ENABLED
        //    #pragma shader_feature_local WINDY_GRASS_TEXV_WEIGHT_ENABLED

        //    #pragma multi_compile_instancing
        //    #pragma vertex ShadowVPShader
        //    #pragma fragment ShadowFPShader
        //    #pragma multi_compile_shadowcaster
            
        //    #include "../CGIncludes/ED8_Defines.cginc"
        //    #include "../CGIncludes/ED8_HelperFunctions.cginc"
        //    #include "../CGIncludes/ED8_ShadowCaster.cginc"
        //    ENDCG
        //}
    }

    Fallback "Transparent/Diffuse"
}
