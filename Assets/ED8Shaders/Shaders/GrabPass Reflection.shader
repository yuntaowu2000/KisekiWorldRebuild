Shader "ED8/Cold Steel Shader/GrabPass Reflection" {
    Properties { 

    }

    SubShader {
        Tags { 
            "Queue "= "Transparent" 
            "IgnoreProjector" = "True" 
            "RenderType" = "GrabPass" 
            "PreviewType" = "Plane"
            "ForceNoShadowCasting" = "True"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        GrabPass {
            "_ReflectionTexture"
        }

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            float4 vert(void) : SV_POSITION {
                return (0.0).xxxx;
            }

            float4 frag(void) : COLOR {
                return (0.0).xxxx;
            }
            ENDCG
        }
    }
}