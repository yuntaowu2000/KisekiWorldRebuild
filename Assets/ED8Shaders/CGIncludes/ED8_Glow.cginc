#if defined(GLARE_EMISSION_ENABLED)
    float4 GlowFPShader(DefaultFPInput IN) : COLOR0 {
	    #if defined(NOTHING_ENABLED)
	        return float4(0.0f, 0.0f, 0.0f, 0.0f);
	    #else // NOTHING_ENABLED
	        float4 resultColor = tex2D(_MainTex, IN.TexCoord.xy);
	        resultColor *= (float4)IN.Color0;

		    #if defined(ALPHA_TESTING_ENABLED)
	            clip(resultColor.a - _AlphaThreshold);
		    #endif // defined(ALPHA_TESTING_ENABLED)

            #if defined(FOG_ENABLED)
                EvaluateFogFP(resultColor.rgb, _scene_FogColor.rgb, IN.Color1.a);
            #endif // FOG_ENABLED

	        return float4(resultColor.rgb, resultColor.a * _GlareIntensity);
	    #endif // NOTHING_ENABLED
    }
#endif // GLARE_EMISSION_ENABLED

#if !defined(NOTHING_ENABLED)
	#if defined(GLARE_EMISSION_ENABLED)
		#if defined(GENERATE_RELFECTION_ENABLED)
            float4 GlowFPShaderRT(DefaultFPInput IN) : COLOR0 {
	            float3 waterNorm = float3(IN.WorldPositionDepth.x, IN.WorldPositionDepth.y - _UserClipPlane.w, IN.WorldPositionDepth.z);
	            clip(dot(_UserClipPlane.xyz, normalize(waterNorm) ));

	            float4 resultColor = tex2D(_MainTex, IN.TexCoord.xy);
	            resultColor *= (float4)IN.Color0;

                #if defined(ALPHA_TESTING_ENABLED)
                    clip(resultColor.a - _AlphaThreshold);
                #endif // defined(ALPHA_TESTING_ENABLED)

                #if defined(FOG_ENABLED)
                    EvaluateFogFP(resultColor.rgb, _scene_FogColor.rgb, IN.Color1.a);
                #endif // FOG_ENABLED

	            return float4(resultColor.rgb, resultColor.a * _GlareIntensity);
            }
		#endif // defined(GENERATE_RELFECTION_ENABLEDD)
	#endif // GLARE_EMISSION_ENABLED
#endif // !NOTHING_ENABLED 