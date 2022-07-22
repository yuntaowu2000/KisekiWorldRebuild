#define FP_DEFAULT
#undef FP_DEFAULTRT
#undef FP_FORCETRANSPARENT
#undef FP_PORTRAIT
#undef FP_SHINING

#if defined(GENERATE_RELFECTION_ENABLED) //|| defined(WATER_SURFACE_ENABLED)
	#undef FP_DEFAULT
	#define FP_DEFAULTRT
	#undef FP_FORCETRANSPARENT
	#undef FP_PORTRAIT
	#undef FP_SHINING
#elif defined(LIGHT_DIRECTION_FOR_CHARACTER_ENABLED)
	#undef FP_DEFAULT
	#undef FP_DEFAULTRT
	#undef FP_FORCETRANSPARENT
	#define FP_PORTRAIT
	#undef FP_SHINING
//#elif defined(SHINING_MODE_ENABLED)
//	#undef FP_DEFAULT
//	#undef FP_DEFAULTRT
//	#undef FP_FORCETRANSPARENT
//	#undef FP_PORTRAIT
//	#define FP_SHINING
#endif

//-----------------------------------------------------------------------------
// fragment shader
fixed4 DefaultFPShader (DefaultVPOutput i) : SV_TARGET {
    UNITY_SETUP_INSTANCE_ID(i);

    #if defined(NOTHING_ENABLED)
	    float4 resultColor = i.Color0;
        #if defined(FP_FORCETRANSPARENT) || defined(FP_PORTRAIT)
            return resultColor;
        #endif // FP_FORCETRANSPARENT

        #if defined(FP_DEFAULT) || defined(FP_DEFAULTRT)
            #if !defined(ALPHA_BLENDING_ENABLED)
                return float4(resultColor.rgb, 0.0f);
            #else // !defined(ALPHA_BLENDING_ENABLED)
                return resultColor;
            #endif // !defined(ALPHA_BLENDING_ENABLED)
        #endif
    #else // NOTHING_ENABLED
        #if defined(FP_DEFAULTRT)
            float3 waterNorm = float3(i.WorldPositionDepth.x, i.WorldPositionDepth.y - _UserClipPlane.w, i.WorldPositionDepth.z);
            clip(dot(normalize(_UserClipPlane.xyz), normalize(waterNorm)));
        #endif // FP_DEFAULTRT

        #if defined(DUDV_MAPPING_ENABLED)
	        float2 dudvValue = tex2D(_DuDvMapSampler, i.DuDvTexCoord.xy).xy;
            #if !defined(UNITY_COLORSPACE_GAMMA)
                dudvValue.x = LinearToGammaSpaceExact(dudvValue.x);
                dudvValue.y = LinearToGammaSpaceExact(dudvValue.y);
                //dudvValue.rgb = pow(dudvValue.rgb, 1 / 1.3635f);
            #endif

            dudvValue = (dudvValue * 2.0f - 1.0f) * (_DuDvScale / _DuDvMapImageSize);
            //i.DuDvTexCoord = dudvValue.xy;
        #endif // DUDV_MAPPING_ENABLED

	    float4 diffuseAmt = float4(0.0f, 0.0f, 0.0f, 0.0f);
        float4 materialDiffuse = (float4)_GameMaterialDiffuse;
        
        #if !defined(MULTI_UV_MULTIPLICATIVE_BLENDING_EX_ENANLED) && !defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_EX_ENANLED)
            diffuseAmt = tex2D(_MainTex, i.uv.xy 
            #if defined(DUDV_MAPPING_ENABLED)
                + dudvValue
            #endif // DUDV_MAPPING_ENABLED
            );

            #if !defined(UNITY_COLORSPACE_GAMMA)
                //diffuseAmt.rgb = GammaToLinearSpace(diffuseAmt.rgb);
            #endif

            #if !defined(ALPHA_TESTING_ENABLED)
                diffuseAmt.a *= (float)i.Color0.a;
            #endif
        #endif

        #if defined(FP_FORCETRANSPARENT)
            #if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
                #if defined(ALPHA_TESTING_ENABLED)
                    clip(diffuseAmt.a - _AlphaThreshold * (float)i.Color0.a);
                #else
                    clip(diffuseAmt.a - 0.004f);
                #endif
            #endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
        #elif defined(FP_DEFAULT) || defined(FP_DEFAULTRT) || defined(FP_PORTRAIT)
            #if defined(ALPHA_BLENDING_ENABLED) || defined(ALPHA_TESTING_ENABLED)
                #if defined(TWOPASS_ALPHA_BLENDING_ENABLED)
                    float alphaAmt = diffuseAmt.a - _AlphaThreshold * (float)i.Color0.a;
                    clip((alphaAmt > 0.0f) ? (alphaAmt * _AlphaTestDirection) : (-1.0f/255.0f));
                #else // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
                    #if defined(ALPHA_TESTING_ENABLED)
                        //clip(diffuseAmt.a - _AlphaThreshold); // * (float)i.Color0.a);
                    #else
                        //clip(diffuseAmt.a - 0.004f);
                    #endif
                #endif // defined(TWOPASS_ALPHA_BLENDING_ENABLED)
            #endif // ALPHA_BLENDING_ENABLED || ALPHA_TESTING_ENABLED
        #endif

        UNITY_LIGHT_ATTENUATION(attenuation, i, i.WorldPositionDepth.xyz);

        #if defined(MULTI_UV_ENANLED)
	        #if !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
                float4 diffuse2Amt = tex2D(_DiffuseMap2Sampler, i.uv2.xy);

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    //diffuse2Amt.rgb = GammaToLinearSpace(diffuse2Amt.rgb);
                #endif

		        #if defined(UVA_SCRIPT_ENABLED)
	                diffuse2Amt *= (float4)_UVaMUvColor;
		        #endif // UVA_SCRIPT_ENABLED

                #if defined(MULTI_UV_FACE_ENANLED)
                    float multi_uv_alpha = (float)diffuse2Amt.a;
                #else // defined(MULTI_UV_FACE_ENANLED)
                    float multi_uv_alpha = (float)i.Color0.a * diffuse2Amt.a;
                #endif // defined(MULTI_UV_FACE_ENANLED)

		        #if defined(MULTI_UV_ADDITIVE_BLENDING_ENANLED)
	                // 加算
	                float3 muvtex_add = diffuse2Amt.rgb * multi_uv_alpha;

	                diffuseAmt.rgb += muvtex_add;
		        #elif defined(MULTI_UV_MULTIPLICATIVE_BLENDING_ENANLED)
                    // 乗算
                    // v = lerp(x, x*y, t)
                    // v = x + (x*y - x) * t;
                    // v = x + (y - 1) * x * t;
                    float3 muvtex_add = (((diffuse2Amt.rgb * diffuseAmt.rgb) * _BlendMulScale2) - diffuseAmt.rgb) * multi_uv_alpha;
                    //float3 muvtex_add = ((diffuse2Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb) * multi_uv_alpha;
                    diffuseAmt.rgb += muvtex_add;
                #elif defined(MULTI_UV_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                    // need to be blank so it doesn't use the bottom branch code.
                #elif defined(MULTI_UV_MULTIPLICATIVE_BLENDING_EX_ENANLED)
                    diffuse2Amt *= _BlendMulScale2;
		        #elif defined(MULTI_UV_SHADOW_ENANLED)
	                // 影領域として扱う
		        #else
	                // アルファ
	                diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse2Amt.rgb, multi_uv_alpha);
		        #endif //
	        #else // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	            float multi_uv_alpha = (float)i.Color0.a;
	        #endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

            #if defined(MULTI_UV2_ENANLED)
                #if !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
                    float4 diffuse3Amt = tex2D(_DiffuseMap3Sampler, i.uv3.xy);

                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        //diffuse3Amt.rgb = GammaToLinearSpace(diffuse3Amt.rgb);
                    #endif

                    #if defined(MULTI_UV2_FACE_ENANLED)
                        float multi_uv2_alpha = (float)diffuse3Amt.a;
                    #else // defined(MULTI_UV2_FACE_ENANLED)
                        float multi_uv2_alpha = (float)i.Color0.a * diffuse3Amt.a;
			        #endif // defined(MULTI_UV_FACE_ENANLED)

			        #if defined(MULTI_UV2_ADDITIVE_BLENDING_ENANLED)
                        // 加算
                        float3 muvtex_add2 = diffuse3Amt.rgb * multi_uv2_alpha;

                        diffuseAmt.rgb += muvtex_add2;
			        #elif defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_ENANLED)
                        // 乗算
                        // v = lerp(x, x*y, t)
                        // v = x + (x*y - x) * t;
                        // v = x + (y - 1) * x * t;
                        float3 muvtex_add2 = (((diffuse3Amt.rgb * diffuseAmt.rgb) * _BlendMulScale3) - diffuseAmt.rgb) * multi_uv2_alpha;
                        //float3 muvtex_add2 = ((diffuse3Amt.rgb - float3(1.0f, 1.0f, 1.0f)) * diffuseAmt.rgb) * multi_uv2_alpha;
                        diffuseAmt.rgb += muvtex_add2;
                    #elif defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                    // need to be blank so it doesn't use the bottom branch code.
                    #elif defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_EX_ENANLED)
                        diffuse3Amt *= _BlendMulScale3;
                    #elif defined(MULTI_UV2_SHADOW_ENANLED)
	                    // 影領域として扱う
			        #else
                        // アルファ
                        diffuseAmt.rgb = lerp(diffuseAmt.rgb, diffuse3Amt.rgb, multi_uv2_alpha);
                    #endif //
                #endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
            #endif // MULTI_UV2_ENANLED
        #endif // MULTI_UV_ENANLED

        diffuseAmt *= materialDiffuse;

        #if defined(USE_LIGHTING) && (defined(FP_DEFAULT) || defined(FP_PORTRAIT)) //&& defined(RECEIVE_SHADOWS)
            float shadowValue = 1.0f;

            shadowValue = attenuation;

            /*
            {
                #ifdef PRECALC_SHADOWMAP_POSITION
                    if (i.shadowPos.w < 1.0f) {
                        float shadowMin = SampleOrthographicShadowMap(i.shadowPos.xyz, LightShadowMap0, DuranteSettings.x, 1.0f);

                        #ifdef SHADOW_ATTENUATION_ENABLED
                            shadowMin = (float)min(shadowMin + i.shadowPos.w, 1.0f);
                        #endif
                        shadowValue = min(shadowValue, shadowMin);
                    }
                #else // PRECALC_SHADOWMAP_POSITION
                    #if defined(DUDV_MAPPING_ENABLED)
                        float3 dudv0 = float3(dudvValue.x, dudvValue.y, 0.0f);
                        float shadowMin = min(shadowValue, EvaluateShadow(Light0, LightShadow0, LightShadowMap0, i.WorldPositionDepth.xyz + dudv0, i.WorldPositionDepth.w, DuranteSettings.x));
                    #else // DUDV_MAPPING_ENABLED
                        float shadowMin = min(shadowValue, EvaluateShadow(Light0, LightShadow0, LightShadowMap0, i.WorldPositionDepth.xyz, i.WorldPositionDepth.w, DuranteSettings.x));
                    #endif // DUDV_MAPPING_ENABLED

                    #ifdef SHADOW_ATTENUATION_VERTICAL_ENABLED
                        if (scene_MiscParameters2.x > 0.0f) {
                            float shadowMinBias = min(abs(i.WorldPositionDepth.y - scene_MiscParameters2.y) * scene_MiscParameters2.x, 1.0f);
                            shadowMinBias = pow(shadowMinBias, SHADOW_ATTENUATION_POWER_VERTICAL);
                            shadowMin = min(shadowMin + shadowMinBias, 1.0f);
                        }
                    #endif

                    shadowValue = min(shadowValue, shadowMin);
                #endif // PRECALC_SHADOWMAP_POSITION

                #if defined(FP_DUDV_AMT_EXIST)
                    shadowValue = (shadowValue + 1.0f) * 0.5f;
                #endif
            }
            */
        #else // defined(USE_LIGHTING) && defined(FP_DEFAULT) && !defined(FP_PORTRAIT)
            float shadowValue = 1.0f;
        #endif // defined(USE_LIGHTING)

        #if defined(MULTI_UV_ENANLED)
            #if defined(MULTI_UV_SHADOW_ENANLED)
                // 影領域として扱う
                shadowValue = min(shadowValue, 1.0f - (diffuse2Amt.r * multi_uv_alpha));
            #endif //

            #if defined(MULTI_UV2_SHADOW_ENANLED)
                // 影領域として扱う
                shadowValue = min(shadowValue, 1.0f - (diffuse3Amt.r * multi_uv2_alpha));
            #endif //
        #endif // MULTI_UV_ENANLED

        #if defined(PROJECTION_MAP_ENABLED)
            float4 projTex = tex2D(_ProjectionMapSampler, i.ProjMap.xy);

            #if !defined(UNITY_COLORSPACE_GAMMA)
                //projTex.r = LinearToGammaSpaceExact(projTex.r);
                //projTex.a = LinearToGammaSpaceExact(projTex.a);
            #endif

            shadowValue = min(shadowValue, 1.0f - projTex.r * projTex.a);
        #endif // PROJECTION_MAP_ENABLED

        #if !defined(UNITY_COLORSPACE_GAMMA)
            //shadowValue = GammaToLinearSpaceExact(shadowValue);
        #endif

        #if defined(SPECULAR_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED))
	        float glossValue = 1.0f;

	        #if defined(SPECULAR_MAPPING_ENABLED)
	            glossValue = tex2D(_SpecularMapSampler, i.uv.xy).x;

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    glossValue.x = LinearToGammaSpaceExact(glossValue);
                #endif
	        #endif // SPECULAR_MAPPING_ENABLED

            #if defined(MULTI_UV_ENANLED)
                #if defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)
                    float glossValue2 = tex2D(_SpecularMap2Sampler, i.uv2.xy).x;

                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        glossValue2.x = LinearToGammaSpaceExact(glossValue2);
                    #endif

                    glossValue = lerp(glossValue, glossValue2, multi_uv_alpha);
                #endif // defined(MULTI_UV_SPECULAR_MAPPING_ENABLED)

                #if defined(MULTI_UV2_SPECULAR_MAPPING_ENABLED)
                    float glossValue3 = tex2D(_SpecularMap3Sampler, i.uv3.xy).x;
                    
                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        glossValue2.x = LinearToGammaSpaceExact(glossValue2);
                    #endif

                    glossValue = lerp(glossValue, glossValue3, multi_uv2_alpha);
                #endif // defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
            #endif // 
        #else // SPECULAR_MAPPING_ENABLED
            float glossValue = 1.0f;
        #endif // SPECULAR_MAPPING_ENABLED

        #if defined(OCCULUSION_MAPPING_ENABLED) || (defined(MULTI_UV_ENANLED) && defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)) || (defined(MULTI_UV2_ENANLED) && defined(MULTI_UV_OCCULUSION2_MAPPING_ENABLED))
	        float occulusionValue = 1.0f;

	        #if defined(OCCULUSION_MAPPING_ENABLED)
	            occulusionValue = tex2D(_OcculusionMapSampler, i.uv.xy).x;

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    //occulusionValue.x = GammaToLinearSpaceExact(occulusionValue.x);
                #endif
	        #endif // OCCULUSION_MAPPING_ENABLED

	        #if defined(MULTI_UV_ENANLED)
		        #if defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)
	                float4 occulusionValue2 = tex2D(_OcculusionMap2Sampler, i.uv2.xy).x;
                    
                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        //occulusionValue2.x = GammaToLinearSpaceExact(occulusionValue2.x);
                    #endif

			        #if defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)
	                    multi_uv_alpha = occulusionValue2.a;
			        #endif // !defined(MULTI_UV_NO_DIFFUSE_MAPPING_ENANLED)

	                occulusionValue = lerp(occulusionValue, occulusionValue2.x, multi_uv_alpha);
		        #endif // defined(MULTI_UV_OCCULUSION_MAPPING_ENABLED)

		        #if defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	                float4 occulusionValue3 = tex2D(_OcculusionMap3Sampler, i.uv3.xy).x;
                    
                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        //occulusionValue3.x = GammaToLinearSpaceExact(occulusionValue3.x);
                    #endif

			        #if defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)
	                    float multi_uv2_alpha = occulusionValue3.a;
			        #endif // !defined(MULTI_UV2_NO_DIFFUSE_MAPPING_ENANLED)

	                occulusionValue = lerp(occulusionValue, occulusionValue3.x, multi_uv2_alpha);
		        #endif // defined(MULTI_UV2_ENANLED) && defined(MULTI_UV2_OCCULUSION_MAPPING_ENABLED)
	        #endif // defined(MULTI_UV_ENANLED)

	        float3 ambientOcclusion = (float3)i.Color0.rgb * occulusionValue;
        #else // OCCULUSION_MAPPING_ENABLED
	        float3 ambientOcclusion = (float3)i.Color0.rgb;
        #endif // OCCULUSION_MAPPING_ENABLED

        #if defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	        #if defined(USE_LIGHTING)
                #if defined(USE_DIRECTIONAL_LIGHT_COLOR)
                    float3 subLightColor = _LightColor0.rgb;
                #else
                    float3 subLightColor = _MainLightColor.rgb;
                #endif

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    subLightColor = LinearToGammaSpace(subLightColor.rgb);
                #endif
	        #else
	            float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
	        #endif

	        #if defined(SPECULAR_MAPPING_ENABLED)
		        #if defined(RECEIVE_SHADOWS)
	                subLightColor *= (glossValue + shadowValue + 1.0f) * 0.5f;
		        #endif
	        #else
		        #if defined(RECEIVE_SHADOWS)
	                subLightColor *= (shadowValue + 1.0f) * 0.5f;
		        #endif
	        #endif
        #else // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	        float3 subLightColor = float3(0.0f, 0.0f, 0.0f);
        #endif // defined(RIM_LIGHTING_ENABLED) || defined(CARTOON_SHADING_ENABLED) || defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)

        float4 resultColor = diffuseAmt;
	    float3 shadingAmt = float3(0.0f, 0.0f, 0.0f);
 	    float3 sublightAmount = float3(0.0f, 0.0f, 0.0f);

        #if defined(USE_LIGHTING)
	        // [PerPixel]
            #if defined(DUDV_MAPPING_ENABLED) && defined(NORMAL_MAPPING_ENABLED)
                float3 worldSpaceNormal = EvaluateNormalFP(i, dudvValue);
            #else
                float3 worldSpaceNormal = EvaluateNormalFP(i);
            #endif

            float3 n1 = worldSpaceNormal;

            #if defined(MULTI_UV_ENANLED) && defined(MULTI_UV_NORMAL_MAPPING_ENABLED)
                #if defined(DUDV_MAPPING_ENABLED)
                    float3 n2 = EvaluateNormal2FP(i, dudvValue);
                #else
                    float3 n2 = EvaluateNormal2FP(i);
                #endif

                //n2.xy *= multi_uv_alpha;
                //worldSpaceNormal = BlendNormals(n1, n2);
                worldSpaceNormal = lerp(n1, n2, multi_uv_alpha);
                worldSpaceNormal = normalize(worldSpaceNormal);
            #endif

	        float3 ambient = float3(0.0f, 0.0f, 0.0f);

	        #if defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
	            //ambient = float3(0.0f, 0.0f, 0.0f);
	        #else // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)
		        #if defined(NO_MAIN_LIGHT_SHADING_ENABLED)
	                //ambient = float3(0.0f, 0.0f, 0.0f);
			        #define FP_NEED_AFTER_MAX_AMBIENT
		        #else // NO_MAIN_LIGHT_SHADING_ENABLED
                    #if defined(FP_PORTRAIT)
	                    ambient = PortraitEvaluateAmbient();
			        #else // FP_PORTRAIT
	                    ambient = EvaluateAmbient(worldSpaceNormal);
			        #endif // FP_PORTRAIT
		        #endif // NO_MAIN_LIGHT_SHADING_ENABLED
	        #endif // defined(ALPHA_BLENDING_ENABLED) && defined(USE_EXTRA_BLENDING)

            float3 worldSpaceEyeDirection = normalize(getEyePosition() - i.WorldPositionDepth.xyz);
            #define FP_WS_EYEDIR_EXIST

	        // リムライトや環境マップの準備
	        #if defined(USE_LIGHTING)
                #if defined(RIM_LIGHTING_ENABLED)
                    #define FP_NDOTE_1
                #endif // RIM_LIGHTING_ENABLED
	        #endif // defined(USE_LIGHTING)

            #if defined(CUBE_MAPPING_ENABLED)
                #define FP_NDOTE_2
            #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED

            #if defined(FP_NDOTE_1) || defined(FP_NDOTE_2)
                float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);
                // defined(DOUBLE_SIDED)
                UNITY_BRANCH
                if (_Culling < 2) {
                    if (ndote < 0.0f) {
                        ndote *= -1.0f;
                        worldSpaceNormal *= -1.0f;
                    }
                }
	        #endif  // defined(FP_NDOTE_1) && defined(FP_NDOTE_2)

            // リムライト
            #if defined(USE_LIGHTING)
                #if defined(RIM_LIGHTING_ENABLED)
                    float rimLightvalue = EvaluateRimLightValue(ndote);

                    #if defined(RIM_TRANSPARENCY_ENABLED)
                        resultColor.a *= saturate(1.0f - rimLightvalue);
                    #else // RIM_TRANSPARENCY_ENABLED
                        #if !defined(RIM_CLAMP_ENABLED)
                            #if !defined(UNITY_COLORSPACE_GAMMA)
                                ambient += rimLightvalue * (float3)LinearToGammaSpace(_RimLitColor) * subLightColor;
                                //ambient += rimLightvalue * (float3)_RimLitColor * subLightColor;
                            #else
                                ambient += rimLightvalue * (float3)_RimLitColor * subLightColor;
                            #endif
                        #endif
                    #endif // RIM_TRANSPARENCY_ENABLED
                #endif // RIM_LIGHTING_ENABLED
            #endif // defined(USE_LIGHTING)

            // キューブマップ/スフィアマップ-PerPixel
            #if defined(CUBE_MAPPING_ENABLED)
                float3 cubeMapParams = reflect(-float3(worldSpaceEyeDirection.x * -1.0f, worldSpaceEyeDirection.y, worldSpaceEyeDirection.z), worldSpaceNormal);
                //float3 cubeMapParams = reflect(-worldSpaceEyeDirection, worldSpaceNormal);
                //float cubeMapIntensity = GammaToLinearSpaceExact((1.0f - max(0.0f, abs(ndote)) * _CubeMapFresnel) * _CubeMapIntensity);

                #if !defined(UNITY_COLORSPACE_GAMMA)
                    //float cubeMapIntensity = (1.0f - max(0.0f, saturate(abs(ndote))) * GammaToLinearSpaceExact(_CubeMapFresnel)) * GammaToLinearSpaceExact(_CubeMapIntensity);
                    float cubeMapIntensity = pow(1.0f - (max(0.0f, saturate(ndote)) * _CubeMapFresnel), 4.0f) * _CubeMapIntensity;
                    //float cubeMapFresnel = cubeMapIntensity * cubeMapIntensity;
                    //cubeMapIntensity *= cubeMapFresnel;
                    //cubeMapIntensity *= _CubeMapIntensity;
                    //float cubeMapIntensity = (1.0f - max(0.0f, ndote) * _CubeMapFresnel) * _CubeMapIntensity;
                #else
                    float cubeMapIntensity = (1.0f - max(0.0f, saturate(abs(ndote))) * _CubeMapFresnel) * _CubeMapIntensity;
                #endif

                float4 cubeMapColor = texCUBE(_CubeMapSampler, cubeMapParams.xyz).rgba;
                //#if !defined(UNITY_COLORSPACE_GAMMA)
                //    cubeMapColor.rgb = LinearToGammaSpace(cubeMapColor.rgb);
                //#endif
            #elif defined(SPHERE_MAPPING_ENABLED)
                float3 viewSpaceNormal = mul((float3x3)UNITY_MATRIX_V, worldSpaceNormal);
                float2 sphereMapParams = viewSpaceNormal.xy * 0.5f + 0.5f;
                float4 sphereMapColor = tex2D(_SphereMapSampler, sphereMapParams.xy).rgba;
                //float4 sphereMapColor = tex2D(_SphereMapSampler, float2(sphereMapParams.x, sphereMapParams.y * -1)).rgba;

                //#if !defined(UNITY_COLORSPACE_GAMMA)
                //    sphereMapColor.rgb = GammaToLinearSpace(sphereMapColor.rgb);
                //#endif
            #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED

            #if !defined(EMVMAP_AS_IBL_ENABLED)
                #if defined(CUBE_MAPPING_ENABLED)
                    //cubeMapColor.rgb = cubeMapColor.rgb - resultColor.rgb;
                    resultColor.rgb = lerp(resultColor.rgb, cubeMapColor.rgb * ambientOcclusion * glossValue, cubeMapIntensity);
                    //resultColor.rgb += cubeMapColor.rgb * cubeMapIntensity * ambientOcclusion * glossValue;
                #elif defined(SPHERE_MAPPING_ENABLED)
                    #if !defined(UNITY_COLORSPACE_GAMMA)
                        //resultColor.rgb += sphereMapColor.rgb * GammaToLinearSpaceExact(_SphereMapIntensity) * ambientOcclusion * glossValue;
                        resultColor.rgb += sphereMapColor.rgb * _SphereMapIntensity * ambientOcclusion * glossValue;
                    #else
                        resultColor.rgb += sphereMapColor.rgb * _SphereMapIntensity * ambientOcclusion * glossValue;
                    #endif
                #endif 
            #endif

            #if defined(FP_SHINING)
                shadingAmt = (1.0f - float3(ndote, ndote, ndote)) * float3(0.345f * 3.5f, 0.875f * 3.5f, 1.0f * 3.5f);
                resultColor.rgb = dot(resultColor.rgb, float3(0.299f, 0.587f, 0.114f));
            #elif defined(FP_PORTRAIT)
                shadingAmt = PortraitEvaluateLightingPerPixelFP(sublightAmount, i.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection, attenuation);
            #else
                shadingAmt = EvaluateLightingPerPixelFP(sublightAmount, i.WorldPositionDepth.xyz, worldSpaceNormal, glossValue, shadowValue, ambient, worldSpaceEyeDirection, attenuation);
            #endif

            // リムライト
            #if defined(USE_LIGHTING)
                #if defined(RIM_LIGHTING_ENABLED)
                    #if defined(RIM_CLAMP_ENABLED)
                        #if !defined(UNITY_COLORSPACE_GAMMA)
                            shadingAmt += rimLightvalue * (float3)LinearToGammaSpace(_RimLitColor) * subLightColor;
                            //shadingAmt += rimLightvalue * (float3)_RimLitColor * subLightColor;
                        #else
                            shadingAmt += rimLightvalue * (float3)_RimLitColor * subLightColor;
                        #endif

                        shadingAmt = min(shadingAmt, (float3)_RimLightClampFactor);
                    #endif
                #endif
            #endif
        #else // !defined(USE_LIGHTING)
	        // [PerVertex]
            float3 subLight = float3(0.0f, 0.0f, 0.0f);
            float3 diffuse = float3(1.0f, 1.0f, 1.0f);
            float3 specular = float3(0.0f, 0.0f, 0.0f);
	        float3 ambient = float3(0.0f, 0.0f, 0.0f);;
	        float3 worldSpaceNormal = normalize(i.normal);

            #if defined(FP_SHINING)
	            float3 worldSpaceEyeDirection2 = normalize(getEyePosition() - i.WorldPositionDepth.xyz);
	            float ndote2 = dot(worldSpaceNormal, worldSpaceEyeDirection2);

	            shadingAmt = (1.0f - float3(ndote2, ndote2, ndote2)) * 1.0f;
	        #else
	            shadingAmt = EvaluateLightingPerVertexFP(i, i.WorldPositionDepth.xyz, glossValue, shadowValue, ambient, diffuse, specular, subLight);
	        #endif
        #endif

        #if defined(FP_NEED_AFTER_MAX_AMBIENT)
            #if defined(FP_PORTRAIT)
                shadingAmt = max(shadingAmt, PortraitEvaluateAmbient());
            #else // !defined(FP_PORTRAIT)
                shadingAmt = max(shadingAmt, EvaluateAmbient(worldSpaceNormal));
            #endif
        #endif

        #if defined(MULTI_UV_ENANLED)
            #if defined(MULTI_UV_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                resultColor.rgb = diffuse2Amt.rgb * resultColor.rgb * (float3)_BlendMulScale2;
            #endif
        #endif

        #if defined(MULTI_UV2_ENANLED)
            #if defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_LM_ENANLED)
                resultColor.rgb = diffuse3Amt.rgb * resultColor.rgb * (float3)_BlendMulScale3;
            #endif
        #endif

        #if defined(USE_SCREEN_UV) //&& defined(ED8_GRABPASS)
            float4 dudvTex = i.ReflectionMap;

            #if defined(DUDV_MAPPING_ENABLED)
                float2 dudvAmt = dudvValue.xy * float2(_ScreenParams.x / _DuDvMapImageSize.x, _ScreenParams.y / _DuDvMapImageSize.y);
                dudvAmt.y *= _CameraDepthTexture_TexelSize.z * abs(_CameraDepthTexture_TexelSize.y);
                //dudvTex.xy += dudvAmt;
                #define FP_DUDV_AMT_EXIST
            #else
                float2 dudvAmt = float2(0.0f, 0.0f);
            #endif // DUDV_MAPPING_ENABLED


            float2 dudvUV = (dudvTex.xy + dudvAmt) / dudvTex.w;
            #if UNITY_UV_STARTS_AT_TOP
                if (_CameraDepthTexture_TexelSize.y < 0) {
                    dudvUV.y = 1 - dudvUV.y;
                }
            #endif

            dudvUV = (floor(dudvUV * _CameraDepthTexture_TexelSize.zw) + 0.5) * abs(_CameraDepthTexture_TexelSize.xy);
            float backgroundDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, dudvUV));
	        float surfaceDepth = UNITY_Z_0_FAR_FROM_CLIPSPACE(dudvTex.z);
	        float depthDifference = backgroundDepth - surfaceDepth;
            dudvAmt *= saturate(depthDifference);
	        dudvUV = (dudvTex.xy + dudvAmt) / dudvTex.w;
            #if UNITY_UV_STARTS_AT_TOP
                if (_CameraDepthTexture_TexelSize.y < 0) {
                    dudvUV.y = 1 - dudvUV.y;
                }
            #endif

            dudvUV = (floor(dudvUV * _CameraDepthTexture_TexelSize.zw) + 0.5) * abs(_CameraDepthTexture_TexelSize.xy);

            float4 refrColor = tex2D(_RefractionTexture, dudvUV).xyzw;
            //float4 refrColor = tex2D(_RefractionTexture, dudvTex.xy / dudvTex.w).xyzw;

            #if !defined(UNITY_COLORSPACE_GAMMA)
                //refrColor.rgb = GammaToLinearSpace(refrColor.rgb);
            #endif

            #if defined(WATER_SURFACE_ENABLED)
                //dudvUV = (dudvTex.xy / dudvTex.w) + (worldSpaceNormal * saturate(dudvTex.w));
                //float4 reflColor = tex2D(_RefractionTexture, float2(dudvUV.x, 1 - dudvUV.y)).xyzw;
                //dudvUV.y = 1 - dudvTex.y;
                float4 reflColor = refrColor.xyzw;
                //float4 reflColor = (0.0f, 0.0f, 0.0f, 0.0f);
            #else
                float4 reflColor = (0.0f, 0.0f, 0.0f, 0.0f);
            #endif // defined(WATER_SURFACE_ENABLED)
        #endif // defined(USE_SCREEN_UV)

        shadingAmt += (float3)_GameMaterialEmission;

        #if (defined(DUDV_MAPPING_ENABLED) || defined(WATER_SURFACE_ENABLED)) && defined(ED8_GRABPASS)
            #if defined(WATER_SURFACE_ENABLED)
                #if !defined(FP_WS_EYEDIR_EXIST)
                    float3 worldSpaceEyeDirection = normalize(getEyePosition() - i.WorldPositionDepth.xyz);
                #endif // FP_WS_EYEDIR_EXIST

                #if !defined(FP_NDOTE_1) && !defined(FP_NDOTE_2)
                    float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);
                #endif

                //float water_ndote = dot(normalize(_UserClipPlane.xyz), worldSpaceEyeDirection);
                //water_ndote = max(0.0f, water_ndote);
                float waterAlpha = pow(1.0f - (max(0.0f, saturate(ndote)) * _ReflectionFresnel), 4.0f) * _ReflectionIntensity;
                resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a) + (reflColor.rgb * waterAlpha);
                float waterGlowValue = reflColor.a + refrColor.a;
            #else // defined(WATER_SURFACE_ENABLED)
                // We need to figure out how to get the refraction texture.
                #if !defined(UNITY_COLORSPACE_GAMMA)
                    //resultColor.rgb = lerp(pow(refrColor.rgb, 6.6f), LinearToGammaSpace(resultColor.rgb), GammaToLinearSpaceExact(resultColor.a));
                    resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a);
                    //resultColor.rgb = lerp(pow(refrColor.rgb, 6.6f), resultColor.rgb, resultColor.a);
                #else
                    resultColor.rgb = lerp(refrColor.rgb, resultColor.rgb, resultColor.a);
                #endif
            #endif // defined(WATER_SURFACE_ENABLED)
        #else // defined(DUDV_MAPPING_ENABLED) || defined(WATER_SURFACE_ENABLED)
            #if defined(WATER_SURFACE_ENABLED)
                #if !defined(FP_WS_EYEDIR_EXIST)
                    float3 worldSpaceEyeDirection = normalize(getEyePosition() - i.WorldPositionDepth.xyz);
                #endif // FP_WS_EYEDIR_EXIST

                #if !defined(FP_NDOTE_1) && !defined(FP_NDOTE_2)
                    float ndote = dot(worldSpaceNormal, worldSpaceEyeDirection);
                #endif

                //float water_ndote = dot(normalize(_UserClipPlane.xyz), worldSpaceEyeDirection);
                //water_ndote = max(0.0f, water_ndote);
                float waterAlpha = pow(1.0f - (max(0.0f, saturate(ndote)) * _ReflectionFresnel), 4.0f) * _ReflectionIntensity;
                resultColor.rgb += reflColor.rgb * waterAlpha;
                float waterGlowValue = reflColor.a + refrColor.a;
            #endif
        #endif

        #if defined(CARTOON_SHADING_ENABLED)
		    #if !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
			    #if defined(CARTOON_HILIGHT_ENABLED)
	                float hilightValue = tex2D(_HighlightMapSampler, i.CartoonMap.xy).r;
	                float3 hilightAmt = hilightValue * _HighlightIntensity * _HighlightColor * subLightColor;
                    #define FP_HAS_HILIGHT
			    #endif // CARTOON_HILIGHT_ENABLED
		    #endif // !defined(CUBE_MAPPING_ENABLED) && !defined(SPHERE_MAPPING_ENABLED)
	    #endif // CARTOON_SHADING_ENABLED

	    #if defined(FP_HAS_HILIGHT)
	        sublightAmount += hilightAmt;
	    #endif // FP_HAS_HILIGHT

        #if defined(SHADOW_COLOR_SHIFT_ENABLED)
	        // [Not Toon] 表面下散乱のような使い方
	        float3 subLightColor2 = max(float3(1.0f, 1.0f, 1.0f), subLightColor * 2.0f);

            #if !defined(UNITY_COLORSPACE_GAMMA)
                //subLightColor2 = LinearToGammaSpace(subLightColor2);
            #endif

            shadingAmt.rgb += (float3(1.0f, 1.0f, 1.0f) - min(float3(1.0f, 1.0f, 1.0f), shadingAmt.rgb)) * _ShadowColorShift * subLightColor2;
        #endif // SHADOW_COLOR_SHIFT_ENABLED

        #if defined(CUBE_MAPPING_ENABLED) || defined(SPHERE_MAPPING_ENABLED)
	        float3 envMapColor = ambientOcclusion;
	    #else // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED
	        float3 envMapColor = float3(1.0f, 1.0f, 1.0f);
	    #endif // CUBE_MAPPING_ENABLED || SPHERE_MAPPING_ENABLED

        #if defined(EMVMAP_AS_IBL_ENABLED)
	        // キューブマップ/スフィアマップ-適用 (IBL)
	        #if defined(CUBE_MAPPING_ENABLED)
	            shadingAmt.rgb += cubeMapColor.rgb * cubeMapIntensity * envMapColor * glossValue;
	        #elif defined(SPHERE_MAPPING_ENABLED)
	            shadingAmt.rgb += sphereMapColor.rgb * _SphereMapIntensity * envMapColor * glossValue;
	        #endif // CUBE_MAPPING_ENABLED
        #endif // EMVMAP_AS_IBL_ENABLED

        #if !defined(UNITY_COLORSPACE_GAMMA)
            //ambientOcclusion.rgb = LinearToGammaSpace(ambientOcclusion.rgb);
        #endif
    
        shadingAmt *= ambientOcclusion;
	    //shadingAmt += sublightAmount;

        #if defined(EMISSION_MAPPING_ENABLED)
	        float4 emiTex = tex2D(_EmissionMapSampler, i.uv.xy);
            //#if !defined(UNITY_COLORSPACE_GAMMA)
            //    emiTex.rgb = GammaToLinearSpace(emiTex.rgb);
            //#endif

	        shadingAmt.rgb = lerp(shadingAmt.rgb, float3(1.0f, 1.0f, 1.0f), float3(emiTex.r, emiTex.r, emiTex.r));
        #endif // EMISSION_MAPPING_ENABLED

        #if defined(UNITY_PASS_FORWARDBASE)
            #if !defined(UNITY_COLORSPACE_GAMMA)
                //shadingAmt.rgb = LinearToGammaSpace(shadingAmt.rgb);
            #endif

            resultColor.rgb *= shadingAmt;
        #elif defined(UNITY_PASS_FORWARDADD)
            resultColor.rgb *= sublightAmount;
        #endif

        #if defined(UNITY_PASS_FORWARDBASE)
            #if defined(MULTI_UV_ENANLED)
                #if defined(MULTI_UV_MULTIPLICATIVE_BLENDING_EX_ENANLED)
                    resultColor = tex2D(_MainTex, i.uv.xy 
                    #if defined(DUDV_MAPPING_ENABLED)
                        + dudvValue.xy
                    #endif // DUDV_MAPPING_ENABLED
                    );

                    resultColor.a *= (float)i.Color0.a * diffuse2Amt.a;
                    resultColor.rgb = (((diffuse2Amt.rgb * resultColor.rgb) - shadingAmt.rgb) * resultColor.a) + shadingAmt.rgb;
                    resultColor *= materialDiffuse;
                #endif
            #endif

            #if defined(MULTI_UV2_ENANLED)
                #if defined(MULTI_UV2_MULTIPLICATIVE_BLENDING_EX_ENANLED)
                    resultColor = tex2D(_MainTex, i.uv.xy 
                    #if defined(DUDV_MAPPING_ENABLED)
                        + dudvValue.xy
                    #endif // DUDV_MAPPING_ENABLED
                    );

                    resultColor.a *= (float)i.Color0.a * diffuse3Amt.a;
                    resultColor.rgb = (((diffuse3Amt.rgb * resultColor.rgb) - shadingAmt.rgb) * resultColor.a) + shadingAmt.rgb;
                    resultColor *= materialDiffuse;
                #endif
            #endif
        #endif

        #if defined(ALPHA_TESTING_ENABLED)
            resultColor.a *= 1 + max(0, CalcMipLevel(i.uv)) * 0.25;
            resultColor.a = (resultColor.a - _AlphaThreshold) / max(fwidth(resultColor.a), 0.0001) + _AlphaThreshold;
        #endif //ALPHA_TESTING_ENABLED

        #if defined(UNITY_PASS_FORWARDBASE)
            #if defined(MULTIPLICATIVE_BLENDING_ENABLED)
                resultColor.rgb += max((1.0f - resultColor.rgb), 0.0f) * (1.0f - shadowValue);
            #endif

            #if defined(FOG_ENABLED) && defined(UNITY_PASS_FORWARDBASE)
                EvaluateFogFP(resultColor.rgb, _FogColor.rgb, i.Color1.a);
            #endif // FOG_ENABLED

            #if defined(SUBTRACT_BLENDING_ENABLED)
                resultColor.rgb = resultColor.rgb * resultColor.a;
            #elif defined(MULTIPLICATIVE_BLENDING_ENABLED)
                resultColor.rgb = (1.0f - resultColor.rgb) * resultColor.a;
            #endif

            #if !defined(UNITY_COLORSPACE_GAMMA)
                //resultColor.rgb = GammaToLinearSpace(resultColor.rgb);
            #endif
        #endif

        #if defined(FP_FORCETRANSPARENT) || defined(FP_SHINING)
            resultColor.rgb = max(resultColor.rgb, float3(0, 0, 0));
            resultColor.a = min(1.0f, resultColor.a);
            return resultColor;
        #elif defined(FP_DEFAULT) || defined(FP_DEFAULTRT) || defined(FP_PORTRAIT)
            #if defined(UNITY_PASS_FORWARDBASE)
                #if defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
                    float glowValue = 0.0f;

                    #if defined(GLARE_MAP_ENABLED)
                        glowValue = tex2D(_GlareMapSampler, i.uv.xy).x;
                        //glowValue.x = GammaToLinearSpaceExact(glowValue.x);
                    #endif

                    #if defined(MULTI_UV_ENANLED) && defined(MULTI_UV_GLARE_MAP_ENABLED)
                        float glowValue2 = tex2D(_GlareMap2Sampler, i.uv.xy).x;
                        //glowValue2.x = GammaToLinearSpaceExact(glowValue2.x);
                        glowValue = lerp(glowValue, glowValue2, multi_uv_alpha);
                    #endif

                    #if defined(GLARE_HIGHTPASS_ENABLED)
                        #if !defined(UNITY_COLORSPACE_GAMMA)
                            float lumi = dot(LinearToGammaSpace(resultColor.rgb), float3(1.0f,1.0f,1.0f));
                        #else
                            float lumi = dot(resultColor.rgb, float3(1.0f,1.0f,1.0f));
                        #endif

                        glowValue += max(lumi - 1.0f, 0.0f);
                    #endif

                    #if defined(GLARE_OVERFLOW_ENABLED)
                        float3 glowof = max(float3(0.0f, 0.0f, 0.0f), resultColor.rgb - _GlowThreshold);
                        glowValue += dot(glowof, 1.0f);
                    #endif

                    #if defined(WATER_SURFACE_ENABLED)
                        //glowValue += waterGlowValue;
                        //return float4(resultColor.rgb, glowValue * _GlareIntensity);
                    //#else 
                        //return float4(resultColor.rgb * glowValue * _GlareIntensity, resultColor.a);
                        //return float4(resultColor.rgb + (resultColor.rgb * glowValue * _GlareIntensity), glowValue * _GlareIntensity * resultColor.a);
                    #endif

                    glowValue *= _GlareIntensity;
                    resultColor.rgb = max(resultColor.rgb + (resultColor.rgb * glowValue), float3(0, 0, 0));
                    resultColor.a = min(1.0f, resultColor.a);

                    #if !defined(ALPHA_BLENDING_ENABLED) && !defined(ALPHA_TESTING_ENABLED)
                        return float4(resultColor.rgb, 1.0f);
                    #else
                        return float4(resultColor.rgb, resultColor.a);
                    #endif
                #else // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
                    resultColor.rgb = max(resultColor.rgb + (resultColor.rgb * _GlareIntensity), float3(0, 0, 0));
                    resultColor.a = min(1.0f, resultColor.a);

                    #if !defined(ALPHA_BLENDING_ENABLED) && !defined(ALPHA_TESTING_ENABLED)
                        return float4(resultColor.rgb, 1.0f);
                    #else
                        return float4(resultColor.rgb, resultColor.a);
                    #endif
                #endif // defined(GLARE_MAP_ENABLED) || defined(GLARE_OVERFLOW_ENABLED) || defined(GLARE_HIGHTPASS_ENABLED)
            #else
                resultColor.rgb = max(resultColor.rgb, float3(0, 0, 0));
                resultColor.a = min(1.0f, resultColor.a);

                #if !defined(ALPHA_BLENDING_ENABLED) && !defined(ALPHA_TESTING_ENABLED)
                    return float4(resultColor.rgb, 1.0f);
                #else
                    return float4(resultColor.rgb, resultColor.a);
                #endif
            #endif
        #endif // FP_DEFAULT || FP_DEFAULTRT
    #endif // NOTHING_ENABLED
}

#undef FP_DUDV_AMT_EXIST
#undef FP_NEED_AFTER_MAX_AMBIENT
#undef FP_WS_EYEDIR_EXIST
#undef FP_HAS_HILIGHT
#undef FP_NDOTE_1
#undef FP_NDOTE_2