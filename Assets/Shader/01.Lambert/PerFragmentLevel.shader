Shader "Master/PerFragmentLevel" {
    
    Properties {
        _Diffuse("Diffuse", Color)= (1,1,1,1)
    }

    SubShader {

        Pass {
            Tags {"LightModel" = "ForwardBase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
            };

            fixed4 _Diffuse;

            v2f vert(appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                fixed NdotL = saturate(dot(i.worldNormal, worldLight));
                if(NdotL > 0.9) {
                    NdotL = 1.0;
                } else if(NdotL > 0.5) {
                    NdotL = 0.6;
                } else {
                    NdotL = 0;
                }
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * NdotL;
                return fixed4(ambient + diffuse, 1.0);
            }

            ENDCG

        }

    }

}
