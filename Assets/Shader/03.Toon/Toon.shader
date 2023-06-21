Shader "Master/Toon" {
    
    Properties {
        _Diffuse("Diffuse", Color) = (1,1,1,1)
        _Specular("Specular", Color) = (1,1,1,1)
        _Gloss("Gloss", Range(8.0, 256)) = 20
    }

    SubShader {
        
        Pass {
            Tags {"LightMode" = "ForwardBase"}

            Cull Front
            CGPROGRAM

            #pragma vertex vert 
            #pragma fragment frag
            #include "Lighting.cginc"

            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
            };

            v2f vert(a2v v) {
                v2f o;
                //获取法线
                float3 normal = v.normal;
                //发现外拓
                v.vertex.xyz += normal * 0.02;
                o.pos = UnityObjectToClipPos(v.vertex);

                return o;

            }

            fixed4 frag(v2f i) : SV_Target {
                return fixed4(0,0,0,1);
            }

            ENDCG

        }

        Pass {
            
            Tags {"LightMode" = "ForwardBase"}
            Cull Back
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"

            fixed3 _Diffuse;
            fixed3 _Specular;
            half _Gloss;

            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float3 worldNormal : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //表面法线
                o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
                //顶点在世界空间中的位置
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                //环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //世界坐标下的发现 归一化
                fixed3 worldNormal = normalize(i.worldNormal);
                //顶点到光源的方向
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

                fixed NdotL = 0.5 + 0.5 * saturate(dot(worldNormal, worldLightDir));

                if(NdotL > 0.6) {
                    NdotL = 1;
                }else if (NdotL > 0.2) {
                    NdotL = 0.3;
                }else {
                    NdotL = 0.1;
                }

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * NdotL;

                //世界坐标下的反射方向
                fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
                //计算摄像机(眼睛)的方向
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

                fixed spec = pow(saturate(dot(reflectDir, viewDir)), _Gloss);

                //高光只有两个色阶,即白色和无色
                if(spec > 0.001) {
                    spec = 1;
                }else {
                    spec = 0;
                }

                //计算高光反射
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * spec;

                return fixed4(ambient + diffuse + specular, 1.0);

            }

            ENDCG

        }

    }

}
