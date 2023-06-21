Shader "Specular/FragmentPhong" {

    Properties {
        _Diffuse("Diffuse", Color) = (1,1,1,1)
        _Specular("Specular", Color) = (1,1,1,1)
        _Gloss("Gloss", Range(8.0, 256)) = 20
    }

    SubShader {

        Pass {

            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"

            fixed4 _Diffuse;
            fixed4 _Specular;
            half _Gloss;

            struct a2v {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //世界空间中的发现
                o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
                //顶点在世界空间中的位置
                o.worldPos = mul(unity_WorldToObject, v.vertex).xyz;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                //获取环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //归一化法线
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                //计算漫反射光
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
                //计算反射光
                fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
                //计算摄像机(眼镜)方向
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - worldLightDir.xyz);
                //计算高光反射
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);
                
                return fixed4(ambient + diffuse + specular,1.0);
            }

            ENDCG

        }

    }

    Fallback "Specular"

}